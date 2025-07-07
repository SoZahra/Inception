#!/bin/bash
echo "=== TEST SERVEUR FTP ==="
echo "1. Container FTP :"
docker ps | grep ftp

echo -e "\n2. Logs FTP :"
docker logs ftp | tail -5

echo -e "\n3. Ports ouverts :"
ss -tlnp | grep :21 || netstat -tlnp | grep :21

echo -e "\n4. Fichiers WordPress accessibles :"
docker exec ftp ls -la /var/www/html | head -5
