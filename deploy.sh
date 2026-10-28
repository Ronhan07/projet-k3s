#!/bin/bash
set -e

echo "================================================================"
echo "  DÉPLOIEMENT AUTOMATISÉ DU CLUSTER K3S (One-Command Workflow)"
echo "================================================================"

# --- ÉTAPE 0 : VÉRIFICATION ET INSTALLATION D'ANSIBLE ---
if ! command -v ansible &> /dev/null; then
    echo -e "\n=== Installation automatique d'Ansible sur le Master ==="
    sudo apt-get update && sudo apt-get install -y ansible
fi

# --- ÉTAPE 1 : CONFIGURATION INTERACTIVE & INJECTION SSH ---
if [ ! -f ~/.ssh/id_rsa ]; then
    echo -e "\n[INFO] Génération d'une paire de clés SSH sur le Master..."
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
fi

echo -e "\n--- Configuration du Nœud MASTER ---"
master_name=""
while [ -z "$master_name" ]; do
    read -p "Nom d'hôte du Master (ex: k3s-master) : " master_name
done

master_ip=""
while [ -z "$master_ip" ]; do
    read -p "Adresse IP du Master (ex: 192.168.69.20) : " master_ip
done

master_user=""
while [ -z "$master_user" ]; do
    read -p "Utilisateur SSH du Master (ex: master) : " master_user
done

read -s -p "Mot de passe sudo/SSH du Master : " master_pass
echo ""

echo -e "\n--- Configuration des Nœuds WORKERS ---"
read -p "Combien de nœuds workers avez-vous ? (ex: 2) : " worker_count

worker_names=()
worker_ips=()
worker_users=()
worker_passes=()

for ((i=1; i<=worker_count; i++))
do
    echo "-> Configuration du Worker $i :"
    
    w_name=""
    while [ -z "$w_name" ]; do
        read -p "  Nom d'hôte (ex: k3s-worker$i) : " w_name
    done

    w_ip=""
    while [ -z "$w_ip" ]; do
        read -p "  Adresse IP (ex: 192.168.69.2$i) : " w_ip
    done

    w_user=""
    while [ -z "$w_user" ]; do
        read -p "  Utilisateur SSH (ex: worker$i) : " w_user
    done

    read -s -p "  Mot de passe SSH : " w_pass
    echo ""
    
    worker_names+=("$w_name")
    worker_ips+=("$w_ip")
    worker_users+=("$w_user")
    worker_passes+=("$w_pass")
done

# --- GESTION DU MOT DE PASSE VAULT (DYNAMIQUE & SÉCURISÉ) ---
read -s -p "Mot de passe pour Ansible Vault (laisser vide si non utilisé) : " vault_pass
echo ""

VAULT_FILE="$HOME/.vault-pass.txt"
if [ -n "$vault_pass" ]; then
    echo "$vault_pass" > "$VAULT_FILE"
    chmod 600 "$VAULT_FILE"
else
    rm -f "$VAULT_FILE"
fi

# --- CONFIGURATION DES APPLICATIONS (AVEC VALIDATION PORTAINER >= 12 CARACTÈRES) ---
echo -e "\n--- Configuration des applications ---"
while true; do
    read -s -p "Mot de passe administrateur pour Portainer (Minimum 12 caractères) : " PORTAINER_PASS
    echo ""
    if [ ${#PORTAINER_PASS} -ge 12 ]; then
        break
    else
        echo "❌ Erreur : Le mot de passe Portainer doit contenir au moins 12 caractères. Veuillez réessayer."
    fi
done

# --- INJECTION DES CLÉS SSH ---
echo -e "\n=== Injection automatique des clés SSH sur les machines ==="
if ! dpkg -l | grep -q sshpass; then
    sudo apt-get update && sudo apt-get install -y sshpass
fi

for ((i=0; i<worker_count; i++))
do
    echo "Injection de la clé sur ${worker_names[i]} (${worker_ips[i]})..."
    export SSHPASS="${worker_passes[i]}"
    sshpass -e ssh-copy-id -o StrictHostKeyChecking=no ${worker_users[i]}@${worker_ips[i]} || true
done

# --- GÉNÉRATION DE L'INVENTAIRE ANSIBLE ---
echo -e "\nGénération dynamique du fichier inventory.ini..."
cat <<EOF > inventory.ini
[master]
$master_name ansible_host=$master_ip ansible_user=$master_user ansible_become_pass=$master_pass

[workers]
EOF

for ((i=0; i<worker_count; i++))
do
    echo "${worker_names[i]} ansible_host=${worker_ips[i]} ansible_user=${worker_users[i]} ansible_become_pass=${worker_passes[i]}" >> inventory.ini
done

cat <<EOF >> inventory.ini

[k3s_cluster:children]
master
workers

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

echo "✅ Fichier inventory.ini généré avec succès !"

# --- ÉTAPE 2 : VÉRIFICATION DE LA CONNECTIVITÉ ---
echo -e "\n=== [1/3] Vérification de la connectivité du cluster ==="
ANSIBLE_HOST_KEY_CHECKING=False ansible k3s_cluster -m ping -i inventory.ini

# --- ÉTAPE 3 : LANCEMENT DU PLAYBOOK GLOBAL ---
echo -e "\n=== [2/3] Lancement du déploiement global automatisé ==="
if [ -f "$VAULT_FILE" ] && [ -s "$VAULT_FILE" ]; then
    ansible-playbook -i inventory.ini deploy-cluster.yml --vault-password-file "$VAULT_FILE" -e "portainer_admin_password=$PORTAINER_PASS"
else
    ansible-playbook -i inventory.ini deploy-cluster.yml -e "portainer_admin_password=$PORTAINER_PASS"
fi

# --- ÉTAPE 4 : VALIDATION FINALE ---
echo -e "\n=== [3/3] Validation de l'état du cluster Kubernetes ==="
sudo kubectl get nodes

echo -e "\n✅ Déploiement complet, automatisé et réussi avec succès !"
