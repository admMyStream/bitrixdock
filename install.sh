#!/bin/sh
set -e

# This script is meant for quick & easy install via:
# $ curl -fsSL https://raw.githubusercontent.com/lsvMystream/bitrixdock/master/install.sh -o install.sh | sh install.sh
echo "Check requirements"
if [ "$(uname)" = "Linux" ]; then
    apt-get -qq update
    hash git 2>/dev/null || { apt-get install -y git; }
    hash docker 2>/dev/null || { cd /usr/local/src && wget -qO- https://get.docker.com/ | sh; }
    if ! command -v docker-compose &> /dev/null; then
        LATEST_VERSION="2.20.3"
        curl -L "https://github.com/docker/compose/releases/download/$LATEST_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        
        # Create an alias for docker-compose as docker compose
        echo 'alias docker-compose="docker compose"' >> ~/.bashrc
        alias docker-compose="docker compose"
    fi
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