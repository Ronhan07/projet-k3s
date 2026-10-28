# Utiliser une image Node.js officielle et légère
FROM node:18-alpine

# Installer systemd/utilitaires si nécessaire pour les commandes systemctl du backend
RUN apk add --no-cache systemd-libs

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer uniquement les dépendances de production
RUN npm install --omit=dev

# Copier tout le reste du code source
COPY . .

# Exposer le port sur lequel le backend écoute
EXPOSE 3000

# Commande pour lancer l'application
CMD ["npm", "start"]