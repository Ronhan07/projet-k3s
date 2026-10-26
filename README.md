# Déploiement Automatisé d'un Cluster K3s Haute Sécurité (IaC)

Projet de fin d'études / Stage de Licence (L3) — Conception, déploiement et sécurisation d'un cluster Kubernetes léger sur réseau isolé.

---

## Architecture du Projet
* **Topologie :** 3 Nœuds sous Debian (1 Master `192.168.69.10` et 2 Workers `.11`, `.12`) sur réseau isolé (`VMnet1`).
* **Orchestration :** Ansible (Infrastructure as Code).
* **Réseau & Sécurité :** Pare-feu UFW granulaire, Network Policies, Chiffrement TLS via `cert-manager`.
* **Applications & Supervision :** Portainer CE, Ingress Traefik, WordPress & MySQL persistants.

---

## Structure du Dépôt
```text
.
├── inventory.ini             # Inventaire des hôtes du cluster
├── deploy.sh                 # Script maître d'automatisation globale
├── deploy-cluster.yml        # Orchestration globale des playbooks Ansible
├── setup-firewall.yml        # Configuration et durcissement UFW
├── site.yml                  # Préparation des OS et installation K3s
├── deploy-certmanager.yml    # Déploiement de Cert-Manager & ClusterIssuers
├── deploy-portainer.yml      # Automatisation et init API de Portainer CE
├── deploy-wordpress.yml      # Déploiement sécurisé de WordPress & MySQL
└── manifests/                # Manifestes Kubernetes (YAML)
    ├── wordpress.yml
    ├── portainer.yml
    ├── security-demo-apps.yml
    └── ...
