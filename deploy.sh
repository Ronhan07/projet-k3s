#!/bin/bash
set -e

echo "=== [1/3] Vérification de la connectivité du cluster ==="
ANSIBLE_HOST_KEY_CHECKING=False ansible k3s_cluster -m ping -i inventory.ini --vault-password-file /home/k3smaster/.vault-pass.txt

echo "=== [2/3] Lancement du déploiement global automatisé ==="
ansible-playbook -i inventory.ini deploy-cluster.yml --vault-password-file /home/k3smaster/.vault-pass.txt

echo "=== [3/3] Validation de l'état du cluster Kubernetes ==="
sudo kubectl get nodes

echo "✅ Déploiement complet, automatisé et réussi avec succès !"
