ip a
ping 8.8.8.8
ping google.com
su -
sudo whoami
sudo curl -sfL https://get.k3s.io | sh -
sudo apt update && sudo apt install -y curl
sudo curl -sfL https://get.k3s.io | sh -
sudo kubectl get nodes
sudo cat /var/lib/rancher/k3s/server/node-token
sudo swapoff -a
sudo kubectl get nodes
sudo kubectl delete node debian
sudo kubectl get nodes
nano portainer.yaml
sudo kubectl apply -f portainer.yaml
nano portainer.yaml
sudo kubectl apply -f portainer.yaml
nano portainer.yaml
sudo kubectl apply -f portainer.yaml
sudo kubectl logs -n portainer deployment/portainer
sudo kubectl rollout restart deployment/portainer -n portainer
sudo kubectl logs -n portainer deployment/portainer --tail=10
nano portainer.yaml
sudo kubectl apply -f portainer.yaml
sudo kubectl rollout restart deployment/portainer -n portainer
nano portainer.yaml
sudo kubectl apply -f portainer.yaml
sudo kubectl rollout restart deployment/portainer -n portainer
nano portainer.yaml
cat portainer.yaml
nano portainer.yaml
sudo kubectl apply -f portainer.yaml
sudo kubectl rollout restart deployment/portainer -n portainer
nano rbac-dev.yaml
sudo kubectl apply -f rbac-dev.yaml
sudo kubectl get rolebinding read-pods -n dev
nano network-policy-default.yaml
sudo kubectl apply -f network-policy-default.yaml
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048   -keyout tls.key -out tls.crt   -subj "/CN=k3s-stage.local/O=Stage/C=FR"
sudo kubectl create secret tls tls-secret   --namespace=dev   --key=tls.key   --cert=tls.crt
nano ingress-secure.yaml
ensunano ingress-secure.yaml
nano ingress-secure.yaml
sudo kubectl apply -f ingress-secure.yaml
sudo kubectl get ingress -n dev
nano app-temoin.yaml
sudo kubectl apply -f app-temoin.yaml
sudo kubectl get pods -n dev
sudo kubectl get pods -n dev -w
sudo kubectl exec -it deploy/mon-application -n dev -- wget -qO- http://localhost
sudo curl -k --resolve k3s-stage.local:443:127.0.0.1 https://k3s-stage.local
sudo kubectl get endpoints mon-application-service -n dev
sudo curl -k --resolve k3s-stage.local:443:192.168.2.220 https://k3s-stage.local
sudo kubectl get svc traefik -n kube-system
sudo curl -k --resolve k3s-stage.local:32470:127.0.0.1 https://k3s-stage.local:32470
sudo kubectl describe ingress secure-ingress -n dev
cat ingress-secure.yaml
nano ingress-secure.yaml
sudo kubectl apply -f ingress-secure.yaml
cat ingress-secure.yaml
sudo kubectl logs -n kube-system -l app.kubernetes.io/name=traefik --tail=20
sudo kubectl get svc -n dev
cat app-temoin.yaml
sudo kubectl apply -f ingress-secure.yaml
sudo kubectl apply -f app-temoin.yaml -n dev
sudo kubectl apply -f ingress-secure.yaml
sudo kubectl get secret tls-secret -n dev
sudo curl --resolve k3s-stage.local:32624:127.0.0.1 http://k3s-stage.local:32624
sudo kubectl get ingress secure-ingress -n dev -o yaml
sudo kubectl get pods -n dev -o wide
sudo curl -k -H "Host: k3s-stage.local" https://127.0.0.1:443/
sudo kubectl get svc -n kube-system traefik
sudo kubectl run test-curl --rm -it --image=alpine -- sh
get svc -n kube-system traefik
sudo kubectl get svc -n kube-system traefik
sudo kubectl run test-curl --rm -it --image=alpine -- sh
sudo kubectl get endpoints mon-application-service -n dev
sudo kubectl port-forward svc/mon-application-service 8080:80 --address 0.0.0.0 -n dev
sudo /usr/local/bin/k3s-uninstall.sh 
sudo rm -f /etc/machine-id
sudo systemd-machine-id-setup
sudo rm /etc/ssh/ssh_host_*
sudo dpkg-reconfigure openssh-server
ip a
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_rsa
ssh-copy-id k3smaster@192.168.2.207
ssh-copy-id k3sworker1@192.168.2.75
ssh-copy-id k3sworker2@192.168.2.189
sudo apt update && sudo apt install -y ansible
nano inventory.ini
ansible k3s_cluster -m ping -i inventory.ini
site.yml
nano site.yml
ansible-playbook -i inventory.ini site.yml -K
nano site.yml
ansible-playbook -i inventory.ini site.yml -K
cat site.yml
nano inventory.ini
ansible-playbook -i inventory.ini site.yml
sudo kubectl get nodes
nano portainer.yml
nano deploy-portainer.yml 
ansible-playbook -i inventory.ini deploy-portainer.yml
sudo kubectl get pods -n portainer -o wide
ip a
sudo kubectl logs -n portainer -l app=portainer --tail=30

ansible-playbook -i inventory.ini deploy-portainer.yml
cat portainer.yml 
sudo kubectl logs -n portainer -l app=portainer --tail=30
nano portainer.yml 
ansible-playbook -i inventory.ini deploy-portainer.yml
sudo kubectl get pods -n portainer
nano portainer.yml 
nano deploy-portainer.yml 
ansible-playbook -i inventory.ini deploy-portainer.yml
cat portainer.yml 
cat deploy-portainer.yml 
nano portainer.yml 
ansible-playbook -i inventory.ini deploy-portainer.yml
cat portainer.yml 
nano deploy-portainer.yml 
ansible-playbook -i inventory.ini deploy-portainer.yml
nano apps.yml
nano deploy-apps.yml 
ansible-playbook -i inventory.ini deploy-apps.yml
nano wordpress.yml
nano deploy-wordpress.yml
ansible-playbook -i inventory.ini deploy-wordpress.yml
cat deploy-wordpress.yml
cat wordpress.yml
nano wordpress.yml
ansible-playbook -i inventory.ini deploy-wordpress.yml
kubectl delete pod -n demo-apps -l app=wordpress
sudo kubectl delete pod -n demo-apps -l app=wordpress
sudo kubectl get pods -n demo-apps -l app=wordpress -w
ansible-vault encrypt group_vars/all/vault.yml
mkdir -p group_vars/all
nano group_vars/all/vault.yml
ansible-vault encrypt group_vars/all/vault.yml
cat group_vars/all/vault.yml
nano wordpress.yml 
nano deploy-wordpress.yml 
ansible-playbook -i inventory.ini deploy-wordpress.yml --ask-vault-pass
nano network-policy.yml
sudo kubectl apply -f network-policy.yml
ufw
nano setup-firewall.yml
ansible-playbook -i inventory.ini setup-firewall.yml
cat setup-firewall.yml
nano cert-manager-setup.yml
nano deploy-cert-manager-setup.yml
ls
nano deploy-certmanager.yml
ansible-playbook -i inventory.ini deploy-certmanager.yml --ask-vault-pass
cat deploy-certmanager.yml
cat cert-manager-setup.yml
nano deploy-certmanager.yml
ansible-playbook -i inventory.ini deploy-certmanager.yml --ask-vault-pass
nano wordpress.yml 
ansible-playbook -i inventory.ini deploy-wordpress.yml --ask-vault-pass
sudo kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
sudo kubectl top nodes
sudo kubectl top pods -n demo-apps
nano nginx-hpa.yml
sudo kubectl apply -f nginx-hpa.yml
sudo kubectl get hpa -n demo-apps -w
clear
ls
nano deploy-linuxwatch.yml
ls
nano deploy-linuxwatch.yml
kubectl apply -f deploy-linuxwatch.yml
sudo kubectl apply -f deploy-linuxwatch.yml
sudo kubectl get pods
sudo get svc
sudo kubectl get svc
ls
cd backend/ && sudo docker build -t linuxwatch-backend:latest
cd ~/backend
sudo k3s nerdctl build -t linuxwatch-backend:latest .
cd -
cd ..
sudo k3s ctr images import /tmp/linuxwatch-backend.tar
sudo kubectl get pods
sudo k3s crictl images
nano deploy-linuxwatch.yml
sudo kubectl apply -f deploy-linuxwatch.yml
sudo kubectl rollout restart deployment linuxwatch
sudo kubectl get pods
cat deploy-linuxwatch.yml
sudo k3s ctr -n k8s.io images import /tmp/linuxwatch-backend.tar
nano deploy-linuxwatch.yml
sudo kubectl apply -f deploy-linuxwatch.yml
sudo kubectl rollout restart deployment linuxwatch
sudo kubectl get pods
cat deploy-linuxwatch.yml
sudo k3s ctr -n k8s.io images list
sudo kubectl delete pods -l app=linuxwatch
sudo kubectl get pods
ls
sudo kubectl describe pod -l app=linuxwatch
scp linuxwatch-backend.tar k3smaster@192.168.2.189:/tmp/
exit
sudo kubectl get pods
nano ingress-linuxwatch.yml
sudo kubectl apply -f ingress-linuxwatch.yml
nano deploy-frontend.yml
sudo kubectl apply -f deploy-frontend.yml
sudo kubectl get pods
sudo kubectl get pods -o wide
sudo kubectl get pods
nano ingress-linuxwatch.yml
sudo kubectl apply -f ingress-linuxwatch.yml
sudo kubectl get ingress
nano ingress-linuxwatch.yml
sudo kubectl apply -f ingress-linuxwatch.yml
sudo kubectl get svc
cat ingress-linuxwatch.yml 
nano ingress-linuxwatch.yml
sudo kubectl apply -f ingress-linuxwatch.yml
nano ingress-linuxwatch.yml
ls
sudo kubectl rollout restart deployment linuxwatch-frontend
sudo kubectl logs -l app=linuxwatch -f
sudo kubectl describe svc linuxwatch-service
curl -I -H "Host: linuxwatch.local" http://192.168.2.207/socket.io/
sudo kubectl get ingress linuxwatch-ingress -o yaml
sudo kubectl rollout restart deployment linuxwatch
sudo kubectl rollout restart deployment linuxwatch-frontend
sudo kubectl delete deployment linuxwatch linuxwatch-frontend
sudo kubectl delete svc linuxwatch-service linuxwatch-frontend-service
sudo kubectl delete ingress linuxwatch-ingress
ls
ip a
sudo /sbin/poweroff 
ip a
ip a | grep inet
ip a | grep en33
ip a
sudo reboot
ip a
sudo /sbin/poweroff 
ls
cat apps.yml
cat deploy-certmanager.yml 
ls /group_vars
cd group_vars/
pwd
cd -
ls /home/k3smaster/group_vars
ls /home/k3smaster/group_vars/all
cat /home/k3smaster/group_vars/all/vault.yml 
exit
cat apps.yml
cat deploy-certmanager.yml
cat network-policy.yml
cat setup-firewall.yml
app-temoin.yaml
cat app-temoin.yaml
cat deploy-frontend.yml
cat ingress-linuxwatch.yml
cat nginx-hpa.yml
cat site.yml
cat deploy-linuxwatch.yml
cat ingress-secure.yaml
cat portainer.yaml
cat tls.crt
cat cert-manager-setup.yml
cat deploy-portainer.yml
cat inventory.ini
cat portainer.yml
cat tls.key
sudo cat tls.key
cat deploy-apps.yml
cat deploy-wordpress.yml
cat network-policy-default.yaml
cat rbac-dev.yaml
cat wordpress.yml
cat site.yml 
exit
free -h
ip a
ip a show ens33
nano /etc/netplan/01-netcfg.yaml
sudo nano /etc/netplan/01-netcfg.yaml
sudo nano /etc/network/interfaces
sudo systemctl restart networking
ip a show ens
ip a
ip a show ens33
ip a
sudo nano /etc/network/interfaces
ip a show ens37
nano inventory.ini 
ansible k3s_cluster -m ping -i inventory.ini
sudo ansible k3s_cluster -m ping -i inventory.ini
ansible k3s_cluster -m ping -i inventory.ini --ask-vault-pass
ANSIBLE_HOST_KEY_CHECKING=False ansible k3s_cluster -m ping -i inventory.ini --ask-vault-pass
nano ansible.cfg
ansible k3s_cluster -m ping -i inventory.ini
ansible k3s_cluster -m ping -i inventory.ini --ask-vault-pass
nano deploy-cluster.yml
nano deploy.sh
chmod +x deploy.sh
sudo find .vault
sudo fi
sudo find .vault-pass.txt
ls
cd group_vars/
cd all/
ls
cat vault.yml 
history | grep -iE "vault|pass|echo"
find ~ -type f \( -name ".*pass*" -o -name "*vault*" -o -name "*.txt" \) 2>/dev/null
echo " VOTRE_MOT_DE_PASSE_VAULT " > ~/.vault-pass.txt
chmod 600 ~/.vault-pass.txt
echo "master" > ~/.vault-pass.txt
chmod 600 ~/.vault-pass.txt
cat ~/.vault-pass.txt
nano deploy.sh
cd ~
nano deploy.sh
./deploy.sh
ip a
./deploy.sh
sudo kubectl get all -n portainer
sudo kubectl describe pods -n portainer
cat portainer.yml
sudo kubectl delete pod portainer-6b57c69ffd-bgwwj -n portainer --force --grace-period=0
sudo kubectl get pods -n portainer -w
./deploy.sh
sudo kubectl describe pod portainer-6b57c69ffd-7j4ls -n portainer
sudo kubectl delete namespace portainer --grace-period=0 --force
sudo kubectl get pv
sudo kubectl delete pv pvc-d8e2166e-0e8c-400c-91e4-dc5e87235f04
./deploy.sh
cat portainer.yml 
cat /home/k3smaster/deploy-portainer.yml
sudo kubectl describe pod portainer-6b57c69ffd-m5d5r -n portainer
sudo kubectl logs portainer-6b57c69ffd-m5d5r -n portainer
sudo kubectl get pv
sudo kubectl delete pv pvc-d8e2166e-0e8c-400c-91e4-dc5e87235f04 --force
sudo kubectl delete namespace portainer --force --grace-period=0
nano deploy-portainer.yml 
./deploy.sh
cat deploy-portainer.yml 
nano deploy-portainer.yml 
./deploy.sh
nano deploy.sh 
sudo ./deploy.sh
cat ./deploy.sh
nano deploy.sh 
./deploy.sh
sudo kubectl describe node k3s-worker1
ansible k3s_cluster -m shell -i inventory.ini --vault-password-file /home/k3smaster/.vault-pass.txt -b -a "systemctl restart k3s-agent" --limit "k3s-worker1,k3s-worker2"
ssh k3smaster@192.168.69.11
sudo kubectl delete node k3s-worker1 k3s-worker2
ansible k3s_cluster -m shell -i inventory.ini --vault-password-file /home/k3smaster/.vault-pass.txt -b -a "/usr/local/bin/k3s-agent-uninstall.sh" --limit "k3s-worker1,k3s-worker2"
./deploy.sh
