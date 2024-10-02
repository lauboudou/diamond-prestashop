FROM nginx:stable-perl

COPY index.html /usr/share/nginx/html

RUN apt update -y && apt upgrade -y

# Exposer le port 80
#EXPOSE 80
