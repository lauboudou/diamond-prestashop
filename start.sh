#!/bin/bash

# Lancer Prestashop et sa base myslq
# --env-file ./.env : charge le fichier des variabales d'environnement 

docker compose --env-file ./.env up -d

#docker run -d --name prestashop-landing-page -p 84:80 -v ./volumes/landing-data:/usr/share/nginx/html --network diamond-network dlaubo/prestashop-landing-page:latest
