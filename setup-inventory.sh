#!/bin/bash

echo "================================================================"
echo "  CONFIGURATION INTERACTIVE & INJECTION SSH AUTOMATISÉE"
echo "================================================================"

# --- 0. GÉNÉRATION DE LA CLÉ SSH LOCALE SI ELLE N'EXISTE PAS ---
if [ ! -f ~/.ssh/id_rsa ]; then
    echo -e "\n[INFO] Génération d'une paire de clés SSH sur le Master..."
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
else
    echo -e "\n[INFO] Clé SSH locale déjà existante."
fi

# Nettoyage de l'ancien inventaire s'il existe
rm -f inventory.ini

# --- 1. CONFIGURATION DU MASTER ---
echo -e "\n--- Configuration du Nœud MASTER ---"
read -p "Nom d'hôte du Master (ex: k3s-master) : " master_name
read -p "Adresse IP du Master (ex: 192.168.69.10) : " master_ip
read -p "Utilisateur SSH du Master (ex: k3smaster) : " master_user
read -s -p "Mot de passe sudo/SSH du Master : " master_pass
echo ""

# --- 2. CONFIGURATION DES WORKERS ---
echo -e "\n--- Configuration des Nœuds WORKERS ---"
read -p "Combien de nœuds workers avez-vous ? (ex: 2) : " worker_count

worker_names=()
worker_ips=()
worker_users=()
worker_passes=()

for ((i=1; i<=worker_count; i++))
do
    echo "-> Configuration du Worker $i :"
    read -p "  Nom d'hôte (ex: k3s-worker$i) : " w_name
    read -p "  Adresse IP (ex: 192.168.69.1$i) : " w_ip
    read -p "  Utilisateur SSH (ex: k3sworker$i) : " w_user
    read -s -p "  Mot de passe SSH : " w_pass
    echo ""
    
    worker_names+=("$w_name")
    worker_ips+=("$w_ip")
    worker_users+=("$w_user")
    worker_passes+=("$w_pass")
done

# --- 3. INJECTION AUTOMATIQUE DES CLÉS SSH ---
echo -e "\n=== Injection automatique des clés SSH sur les machines ==="
# Pour l'outil sshpass (nécessaire pour automatiser l'envoi du mot de passe en CLI)
if ! dpkg -l | grep -q sshpass; then
    echo "Installation de sshpass pour automatiser l'échange de clés..."
    sudo apt-get update && sudo apt-get install -y sshpass
fi

# Injection sur soi-même (Master) si besoin, ou passage direct
# Pour les workers :
for ((i=0; i<worker_count; i++))
do
    echo "Injection de la clé sur ${worker_names[i]} (${worker_ips[i]})..."
    export SSHPASS="${worker_passes[i]}"
    sshpass -e ssh-copy-id -o StrictHostKeyChecking=no ${worker_users[i]}@${worker_ips[i]}
done

# --- 4. GÉNÉRATION DU FICHIER INVENTORY.INI (VERSION PRO : SANS MOT DE PASSE) ---
echo -e "\nGénération du fichier inventory.ini (mode sécurisé par clé SSH)..."

cat <<EOF > inventory.ini
[master]
$master_name ansible_host=$master_ip ansible_user=$master_user ansible_become_pass=$master_pass

[workers]
EOF

for ((i=0; i<worker_count; i++))
do
    # Plus besoin de stocker le mot de passe SSH dans l'inventaire grâce à la clé !
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

# --- 5. VÉRIFICATION / INSTALLATION D'ANSIBLE ---
if ! command -v ansible &> /dev/null; then
    echo -e "\n=== Installation automatique d'Ansible sur le Master =="
    sudo apt-get update && sudo apt-get install -y ansible
fi

# --- 6. TEST DE CONNECTIVITÉ FINAL VIA ANSIBLE ---
echo -e "\n=== Test de connectivité du cluster via Ansible (sans mot de passe) ==="
ANSIBLE_HOST_KEY_CHECKING=False ansible k3s_cluster -m ping -i inventory.ini

if [ $? -eq 0 ]; then
    echo "🎉 Connexion SSH par clé validée sur tous les nœuds !"
    
    # --- 7. LANCEMENT AUTOMATIQUE DU DÉPLOIEMENT GLOBAL ---
    read -p "Voulez-vous lancer le déploiement complet du cluster K3s maintenant ? (o/n) : " launch_deploy
    if [[ "$launch_deploy" == "o" || "$launch_deploy" == "O" ]]; then
        if [ -f "./deploy.sh" ]; then
            chmod +x deploy.sh
            exec ./deploy.sh
        else
            echo "⚠️ Le fichier deploy.sh est introuvable à la racine."
        fi
    else
        echo "✅ Configuration terminée. Vous pourrez lancer './deploy.sh' plus tard."
    fi
else
    echo "⚠️ Attention : Échec du test de ping Ansible. Le déploiement est suspendu."
fi
