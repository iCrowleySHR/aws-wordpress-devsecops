#!/bin/bash
# Atualiza os pacotes do sistema
yum update -y

# Instala pacotes necessários
yum install -y ca-certificates wget amazon-efs-utils

# Instala o Docker
yum install -y docker

# Inicia e habilita o serviço do Docker
systemctl enable docker
systemctl start docker

# Adiciona o usuário ec2-user ao grupo docker
usermod -aG docker ec2-user

# Instala o Docker Compose manualmente
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Cria o diretório de montagem do EFS
mkdir -p /efs

# Monta o sistema de arquivos EFS
sudo mount -t efs -o tls fs-03ca53046c3c6b6ec:/ /efs

# Cria diretório para o WordPress dentro do EFS
mkdir -p /efs/wordpress

# Cria o docker-compose.yml usando cat
cat <<EOF > /home/ec2-user/docker-compose.yml
version: "3.8"

services:
  web:
    image: wordpress
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: 
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: ""
      WORDPRESS_DB_NAME: 
    volumes:
      - /efs/wordpress:/var/www/html
    networks:
      - tunel
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin
    restart: always
    ports:
      - "8080:80"
    environment:
      PMA_HOST: 
      PMA_PORT: 3306

networks:
  tunel:
    driver: bridge
EOF

# Ajusta permissões
chown ec2-user:ec2-user /home/ec2-user/docker-compose.yml

# Inicia os containers com Docker Compose
cd /home/ec2-user
docker-compose up -d
