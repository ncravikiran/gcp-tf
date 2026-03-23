#!/bin/bash
# Startup script to configure the instance

apt-get update
apt-get install -y nginx
service nginx start