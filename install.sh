#!/bin/sh
set -e

# This script is meant for quick & easy install via:
# $ curl -fsSL https://raw.githubusercontent.com/lsvMystream/bitrixdock/master/install.sh -o install.sh | sh install.sh
echo "Check requirements"
if [ "$(uname)" = "Linux" ]; then
    apt-get -qq update
hash git 2>/dev/null || { apt-get install -y git; }
hash docker 2>/dev/null || {
    apt update && \
    apt install apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && \ 
    apt-cache policy docker-ce && \
    apt install docker-ce && \
    sudo systemctl status docker; \
}
hash docker-compose 2>/dev/null || { \
    apt update && \
    apt install docker-compose-plugin && \
    docker compose version && \
    sudo rm /usr/local/bin/docker-compose && \
    echo 'alias docker-compose="docker compose"' >> ~/.bashrc && \
    source ~/.bashrc && \
    docker-compose version; \
}
fi


echo "Create folder struct"
mkdir -p /var/www/bitrix && \
cd /var/www/bitrix && \
wget https://www.1c-bitrix.ru/download/scripts/bitrixsetup.php && \
cd /var/www/ && \
git clone https://github.com/lsvMystream/bitrixdock.git && \
cd /var/ && chmod -R 775 www/ && chown -R root:www-data www/ && \
cd /var/www/bitrixdock

echo "Config"
cp -f .env_template .env

echo "Run"
docker-compose up -d