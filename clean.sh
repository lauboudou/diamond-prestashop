#!/bin/bash

# stop conteneur prestashop-landing-page
./stop.sh

# Supprimer les volumes
sudo rm -fR volumes
echo "le(s) volume(s) sont supprimées"
