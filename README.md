# WordPress em Alta Disponibilidade na AWS

Esta arquitetura simula um ambiente de produção real, onde interrupções não podem causar indisponibilidade da aplicação. A utilização de serviços gerenciados permite focar na lógica de implantação e escalabilidade, sem a necessidade de gerenciar manualmente servidores de banco de dados ou sistemas de arquivos distribuídos.

Este projeto tem como objetivo desenvolver competências práticas em infraestrutura como código, provisionamento de recursos em nuvem e arquiteturas resilientes, utilizando ferramentas modernas e os serviços oferecidos pela AWS.

## Arquitetura da Solução

![Diagrama da Arquitetura](https://github.com/user-attachments/assets/825ec8af-1eb9-4bbd-b727-693494b9da12)

## 📋 Índice

- [VPC e Subnets](#vpc-e-subnets)
- [NAT Gateway](#nat-gateway)
- [Tabelas de Rota](#tabelas-de-rota)
- [Grupos de Segurança](#grupos-de-segurança)
- [RDS (Banco de Dados)](#rds-banco-de-dados)
- [EFS (Sistema de Arquivos)](#efs-sistema-de-arquivos)
- [Launch Template](#launch-template)
- [Application Load Balancer](#application-load-balancer)
- [Auto Scaling](#auto-scaling)
- [Configuração Final](#configuração-final)


---

## VPC e Subnets

### Criação da VPC

1. Acesse o serviço *VPC* no console AWS
2. Clique em *"Create VPC"*
3. Configure conforme a imagem abaixo:

*Configurações:*
- *Resources to create*: VPC and more
- *Name tag auto-generation*: Wordpress
- *IPv4 CIDR block*: 10.0.0.0/16
- *Number of Availability Zones*: 2
- *Number of public subnets*: 2
- *Number of private subnets*: 4
- *NAT gateways*: 2 (uma por AZ)



<img width="1920" height="878" alt="image" src="https://github.com/user-attachments/assets/127989ee-f70a-43c3-8de8-e4cdc0e15331" />

<img width="1891" height="637" alt="image" src="https://github.com/user-attachments/assets/533ad3e2-ae7f-4c1e-8ad8-d3b1f6c21c0d" />

<img width="411" height="750" alt="image" src="https://github.com/user-attachments/assets/ec8c184b-4db3-4ce5-907b-d3d2c5e7be00" />

<img width="1920" height="860" alt="image" src="https://github.com/user-attachments/assets/1ade46ce-5ec4-4371-8e7b-73e0191cbd76" />

### Nomenclatura das Subnets

Após a criação, renomeie as subnets para melhor identificação:

- *Public subnets*: wordpress-public1-us-east-1a, wordpress-public2-us-east-1b
- *Private subnets (app)*: wordpress-subnet-private3(app)-us-east-1a, wordpress-subnet-private4(app)-us-east-1b
- *Private subnets (data)*: wordpress-subnet-private1(data)-us-east-1a, wordpress-subnet-private2(data)-us-east-1b

<img width="1920" height="468" alt="image" src="https://github.com/user-attachments/assets/f1f46bf8-cc58-43c3-940f-1d4cd343d61c" />

---

### Criação dos NAT Gateways

Crie dois NAT Gateways, um para cada zona de disponibilidade:

*NAT Gateway A (us-east-1a):*
- *Subnet*: wordpress-public1-us-east-1a
- *Elastic IP allocation*: Alocar novo IP elástico

*NAT Gateway B (us-east-1b):*
- *Subnet*: wordpress-public2-us-east-1b 
- *Elastic IP allocation*: Alocar novo IP elástico

<img width="1919" height="904" alt="image" src="https://github.com/user-attachments/assets/dc61311f-c234-4e26-918e-86a9cde1132a" />

<img width="1920" height="897" alt="image" src="https://github.com/user-attachments/assets/71025b7f-2828-4ece-a3a4-58891fd919d5" />

<img width="1919" height="928" alt="image" src="https://github.com/user-attachments/assets/c4bf3590-9c24-4836-80b0-297df1260eaa" />

---

## Tabelas de Rota

### Configuração das Rotas Privadas

*Para Wordpress-rtb-private1-us-east-1a:*
- Adicione rota: 0.0.0.0/0 → nat-gateway-a
- Associe as subnets: wordpress-data1-us-east-1a e wordpress-app1-us-east-1a

*Para Wordpress-rtb-private2-us-east-1b:*
- Adicione rota: 0.0.0.0/0 → nat-gateway-b
- Associe as subnets: wordpress-data2-us-east-1b e wordpress-app2-us-east-1b

## Wordpress-rtb-private1-us-east-1a

Associe a `nat-gateway-a` como na imagem

<img width="1920" height="930" alt="image" src="https://github.com/user-attachments/assets/5541e9e5-5e51-4575-bd4e-01ae040f159a" />

<img width="1920" height="926" alt="image" src="https://github.com/user-attachments/assets/c3f25010-35ce-4ede-a254-8b9703f9989e" />

<img width="1920" height="938" alt="image" src="https://github.com/user-attachments/assets/27064aed-1b8d-4ded-a5c5-3541346773ca" />

> #### Associe o subnet data e app da região na *Wordpress-rtb-private1-us-east-1a*


<img width="1920" height="926" alt="image" src="https://github.com/user-attachments/assets/08f2dca8-770e-4ddd-9b29-078e4ad43cd7" />

<img width="1915" height="928" alt="image" src="https://github.com/user-attachments/assets/0d3d8daf-8009-47a9-89f2-78c77e2a2bb3" />


## Wordpress-rtb-private2-us-east-1b

Associe a `nat-gateway-b` como na imagem

<img width="1890" height="928" alt="image" src="https://github.com/user-attachments/assets/948ac489-babb-494e-8a9e-d3083647633e" />

<img width="1920" height="929" alt="image" src="https://github.com/user-attachments/assets/da2b81df-67c0-4296-aeb5-38e8a6ced4f2" />

> #### Associe o subnet data e app da região na *Wordpress-rtb-private2-us-east-1b*

<img width="1920" height="932" alt="image" src="https://github.com/user-attachments/assets/1375278c-358c-4cbc-bbae-f37c2e04bc8e" />

<img width="1920" height="930" alt="image" src="https://github.com/user-attachments/assets/27480330-db56-4d22-8a39-2ead1dd41458" />

---

### Mapa de Recursos Final

O mapa de recursos da VPC deve ficar assim:

<img width="1674" height="407" alt="image" src="https://github.com/user-attachments/assets/1d43e7d8-cf39-4b34-b571-867c95fb4148" />

--- 

## Grupo de Segurança

### 1. Load Balancer Security Group
*Entrada:*
- HTTP (80) - 0.0.0.0/0
- HTTP (8080) - Meu IP
  
*Saída:*
- All traffic

<img width="1716" height="344" alt="image" src="https://github.com/user-attachments/assets/1f46065f-93d7-49be-beb1-cf644eed5f3e" />


### 2. Bastion Security Group
*Entrada:*
- SSH (22) - Meu IP
  
*Saída:*
- All traffic

<img width="1920" height="933" alt="image" src="https://github.com/user-attachments/assets/07ef4061-ae61-477d-8bcc-9eb78be546cf" />

### 3. EC2 Security Group  
*Entrada:*
- HTTP (80) - Load Balancer SG
- TCP (8080) - Load Balancer SG
- SSH (22) - Bastion SG
  
*Saída:*
- All traffic

<img width="1728" height="717" alt="image" src="https://github.com/user-attachments/assets/fd47bdc7-0a3c-4e1a-98ae-2879011d6ee0" />

> Na porta 8080 do TCP personalizado, deixe com o Grupo de Segurança do Load Balance, igual a do Wordpress na porta 80, e na porta 22 o SG do Bastion

### 4. RDS Security Group
*Entrada:*
- MySQL/Aurora (3306) - EC2 SG
  
*Saída:*
- All traffic

<img width="1915" height="927" alt="image" src="https://github.com/user-attachments/assets/25db4ce8-3cc6-4b8b-92cb-e69d4a400bb3" />

### 5. EFS Security Group
*Entrada:*
- NFS (2049) - EC2 SG
  
*Saída:*
- All traffic

<img width="1920" height="923" alt="image" src="https://github.com/user-attachments/assets/19c5dbe8-65c9-4e84-ae86-9bc5dab2f287" />

---

## RDS (Banco de Dados)

### Criação do Subnet Group

1. Acesse *RDS* → *Subnet groups*
2. Clique em *"Create DB subnet group"*
3. Configure com as subnets data de cada região

Criaremos uma sub-redes entre as duas zonas de disponibilidade, veja as configurações abaixo conforme a imagem

<img width="1920" height="930" alt="image" src="https://github.com/user-attachments/assets/2edc3ba0-ab2d-47ec-9be1-bd2a8565cd7b" />

---

## Banco de Dados RDS

*Configurações principais:*
- *Engine type*: MySQL
- *Template*: Nivel Gratuito
- *DB instance identifier*: wordpress-db
- *Master username*: admin
- *Master password*: [Senha segura]
- *DB instance class*: db.t3.micro
- *Storage*: 20GB GP2
- *VPC*: Wordpress VPC
- *Subnet group*: Criado anteriormente
- *Public access*: No
- *VPC security group*: RDS Security Group
- *Database name*: wordpress-db

<img width="1920" height="929" alt="image" src="https://github.com/user-attachments/assets/274d3fb5-8a75-4357-a1ae-032914226cab" />

<img width="1920" height="717" alt="image" src="https://github.com/user-attachments/assets/fa5ff95b-7c05-48d4-8001-5b5c602d9ce8" />

<img width="1920" height="506" alt="image" src="https://github.com/user-attachments/assets/52ae8612-c03d-4996-8054-a80ee74574f5" />

<img width="1920" height="579" alt="image" src="https://github.com/user-attachments/assets/45b77769-844d-4b4f-9e10-37ab523cd6ee" />

<img width="1920" height="707" alt="image" src="https://github.com/user-attachments/assets/73e35d01-0386-46bd-af69-68f833eb75b9" />

<img width="1920" height="504" alt="image" src="https://github.com/user-attachments/assets/2915d236-90dd-4594-a668-738d8dcae120" />

> *Importante*: Na seção "Additional configuration", defina o nome do banco igual ao nome da instância!

---

## EFS (Sistema de Arquivos)

*Configurações:*
- *Name*: wordpress
- *VPC*: Wordpress VPC
- *Mount targets*: Crie para cada subnet data (us-east-1a e us-east-1b)
- *Security groups*: EFS Security Group

### Criação do File System

1. Acesse *EFS* → *Create file system*
2. Configure conforme imagens:

<img width="1920" height="929" alt="image" src="https://github.com/user-attachments/assets/5c95e978-4e2a-4686-a202-75123f551585" />

<img width="1920" height="888" alt="image" src="https://github.com/user-attachments/assets/e99a8f6d-66c1-4a1b-b213-7939235e08d7" />

> Clique em personalizar

<img width="1920" height="926" alt="image" src="https://github.com/user-attachments/assets/da8219ca-6b65-4773-9158-78615f48fafa" />

<img width="1920" height="931" alt="image" src="https://github.com/user-attachments/assets/3a88152d-0d2a-444b-8bfa-5ab2cfe57a98" />

> Coloque a subnet (data) da sua respectiva região e o Grupo de Segurança do EFS que criamos anteriormente 

---

## Launch Template (Modelo de execução)

### Criação do Template

1. Acesse *EC2* → *Launch Templates* → *Create launch template*
2. Configure conforme imagens:

*Configurações Básicas:*
- *Name*: wordpress-template
- *AMI*: Ubuntu
- *Instance type*: t3.micro
- *Key pair*: Sua chave existente ou nova
- *Security groups*: EC2 Security Group

>  *Importante*: Lembre-se de colocar as suas credenciais para conexão do banco do phpMyAdmin, Wordpress e montagem do EFS no User Data

*User Data (Script de inicialização):*
```bash
#!/bin/bash
sudo su
sleep 45
apt update -y

apt install -y apt-transport-https ca-certificates curl software-properties-common nfs-common


install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y

apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

systemctl start docker
systemctl enable docker
usermod -a -G docker ubuntu 


apt install docker-compose-plugin -y


EFS_ID="SEU_EFS_ID"
AWS_REGION="SUA_REGIAO_AWS"
EFS_MOUNT_POINT="/mnt/efs-wordpress"

mkdir -p ${EFS_MOUNT_POINT}
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${EFS_ID}.efs.${AWS_REGION}.amazonaws.com:/ ${EFS_MOUNT_POINT}
echo "${EFS_ID}.efs.${AWS_REGION}.amazonaws.com:/ ${EFS_MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab


PROJECT_DIR="/home/ubuntu/wordpress-project"
mkdir -p ${PROJECT_DIR}
WORDPRESS_FILES_PATH="${EFS_MOUNT_POINT}/html"
mkdir -p ${WORDPRESS_FILES_PATH}

DB_HOST="SEU_ENDPOINT_DO_RDS_AQUI"
DB_USER="SEU_USUARIO_DO_BANCO_AQUI"
DB_PASSWORD="SUA_SENHA_DO_BANCO_AQUI"
DB_NAME="SEU_NOME_DO_BANCO_AQUI"

cat <<EOF > ${PROJECT_DIR}/docker-compose.yml
version: '3.8'
services:
  wordpress:
    image: wordpress:php8.3-apache
    container_name: wordpress
    restart: always
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: ${DB_HOST}
      WORDPRESS_DB_USER: ${DB_USER}
      WORDPRESS_DB_PASSWORD: ${DB_PASSWORD}
      WORDPRESS_DB_NAME: ${DB_NAME}
    volumes:
      - ${WORDPRESS_FILES_PATH}:/var/www/html/

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin
    restart: always
    ports:
      - "8080:80"
    environment:
      PMA_HOST: ${DB_HOST}
      PMA_PORT: 3306
EOF

sudo chown -R 33:33 ${WORDPRESS_FILES_PATH}
cd ${PROJECT_DIR}
docker compose up -d
```

<img width="1920" height="926" alt="image" src="https://github.com/user-attachments/assets/145fdeff-7e8e-43f3-be30-c9a954bb6962" />

<img width="1917" height="466" alt="image" src="https://github.com/user-attachments/assets/09764daa-e41f-4a84-a6e2-78a1c87e3d77" />

<img width="1040" height="613" alt="image" src="https://github.com/user-attachments/assets/73356320-9077-414a-9815-20c29dec305d" />

<img width="1077" height="558" alt="image" src="https://github.com/user-attachments/assets/6bac01a2-332d-455c-ad7c-a915335dc2da" />

<img width="1918" height="972" alt="image" src="https://github.com/user-attachments/assets/2336de80-2c3b-41c2-be89-bb2255aef243" />

> *Importante*: Substitua fs-your-efs-id pelo ID real do seu EFS e configure as credenciais do RDS.

> Está em configuração avançadas o textarea para o userdata.

---

## Application Load Balancer

### Criação do ALB

1. Acesse *EC2* → *Load Balancers* → *Create Load Balancer*
2. Selecione *Application Load Balancer*

<img width="1917" height="974" alt="image" src="https://github.com/user-attachments/assets/858168b4-31ad-4574-b13d-76acd2b55ff4" />

<img width="1920" height="938" alt="image" src="https://github.com/user-attachments/assets/14435b26-7b3c-4878-98c5-0ada274f0e74" />

<img width="1913" height="635" alt="image" src="https://github.com/user-attachments/assets/91b14fde-714d-4130-99ca-4c525aca590c" />

<img width="1920" height="533" alt="image" src="https://github.com/user-attachments/assets/9cab8720-464e-439f-bcf3-1621859f46a7" />

<img width="1920" height="207" alt="image" src="https://github.com/user-attachments/assets/d2207dfd-7bf9-4515-9c7f-e6d28e08dc57" />

<img width="1920" height="776" alt="image" src="https://github.com/user-attachments/assets/792cc159-9650-4c13-a75f-cfc0161d343d" />

>  Vá em criar grupo de destino

### Grupos de Destino (Target Groups)

*Target Group 1 - WordPress (Porta 80):*
- *Name*: wordpress-tg
- *Protocol*: HTTP
- *Port*: 80
- *Health check path*: /

*Target Group 2 - phpMyAdmin (Porta 8080):*
- *Name*: phpmyadmin-tg  
- *Protocol*: HTTP
- *Port*: 8080
- *Health check path*: /

<img width="1919" height="696" alt="image" src="https://github.com/user-attachments/assets/18a0fb79-2a93-418e-8337-42caca2c664a" />

<img width="1920" height="526" alt="image" src="https://github.com/user-attachments/assets/0c3f5382-d44c-4188-955e-fb591636aef2" />

<img width="1920" height="927" alt="image" src="https://github.com/user-attachments/assets/8965810d-cfa4-4cc8-8ed4-1b4f26af3fcf" />

<img width="1920" height="862" alt="image" src="https://github.com/user-attachments/assets/71f88d0f-7f82-4998-81e0-017215ed4d3f" />

### Crie outra Grupo de destino para a porta 8080, para redirecionar o tráfego pro PhpMyAdmin, seguindo a mesma configuração, apenas mudando a porta.


<img width="1641" height="827" alt="image" src="https://github.com/user-attachments/assets/887c20df-9d37-4abd-915e-c2c05f9f22cc" />

<img width="1920" height="930" alt="image" src="https://github.com/user-attachments/assets/18c9922a-7dcf-452e-8b4b-15e46a0f31de" />

## ALB + Target Group

### Configuração de Listeners

*Listener 1 (Porta 80):*
- *Default action*: Forward to wordpress-tg

*Listener 2 (Porta 8080):*
- *Default action*: Forward to phpmyadmin-tg

<img width="1427" height="697" alt="image" src="https://github.com/user-attachments/assets/07286063-3353-4e7b-a602-3cb970008fd8" />

> Errei nos Target Group, porém, coloque o 80 no Wordpress e o 8080 no phpMyAdmin

> Na imagem está as duas portas no phpMyAdmin

<img width="1373" height="509" alt="image" src="https://github.com/user-attachments/assets/ba12e597-d5a1-43e6-83b1-4b46db23007a" />


#### No final ficará assim, a 80 para o Wordpress e o 8080 para o phpMyAdmin

<img width="1920" height="930" alt="image" src="https://github.com/user-attachments/assets/adcac135-0a95-4ff6-866e-e572391902ed" />

---

## Auto Scaling

### Criação do Auto Scaling Group

1. Acesse *EC2* → *Auto Scaling Groups* → *Create Auto Scaling group*

*Configurações:*
- *Name*: autoScalingWordpress
- *Launch template*: TemplateWordpress
- *VPC*: Wordpress VPC
- *Subnets*: Subnets app (us-east-1a e us-east-1b)

  *Configuração de Escalabilidade:*
- *Desired capacity*: 2
- *Minimum capacity*: 2  
- *Maximum capacity*: 4

<img width="1920" height="932" alt="image" src="https://github.com/user-attachments/assets/cda016c0-47c9-4a0b-bd99-41b36d5b5d49" />

<img width="1920" height="921" alt="image" src="https://github.com/user-attachments/assets/6441e22c-30a2-4369-a86e-f3b8ed5e4346" />

<img width="1920" height="931" alt="image" src="https://github.com/user-attachments/assets/85d5cb9f-000b-45e7-bb00-d8bb2f64704c" />

> Coloque as subnets app

<img width="1920" height="899" alt="image" src="https://github.com/user-attachments/assets/6f6e5334-88d6-423f-95e8-083bae0b6dc2" />

<img width="1915" height="709" alt="image" src="https://github.com/user-attachments/assets/0c0a6950-f96d-424d-b816-6a701efea4dc" />

<img width="1919" height="694" alt="image" src="https://github.com/user-attachments/assets/beeee04f-4a35-4525-a111-283d9f1301ac" />

<img width="1918" height="892" alt="image" src="https://github.com/user-attachments/assets/10e01e50-fce4-4fb1-9a50-cea67511d9b7" />

---

## Configuração Final

### URLs de Acesso

*WordPress:*
http://SEU-DNS-ALB:80

*phpMyAdmin:*
http://SEU-DNS-ALB:8080

### Configurações Importantes

1. *Acesso ao phpMyAdmin*: Se mudar seu IP, atualize o security group do ALB
2. *URL do WordPress*: Ao mudar o DNS do ALB, atualize a site_url no banco de dados com o phpMyAdmin
3. *Health Checks*: Verifique se as instâncias estão passando nos health checks

### Demonstração

A aplicação final deve ficar semelhante a:

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/68450d1f-b932-4b92-b816-5554616c90c2" />

## Veja o vídeo abaixo da aplicação funcionando

<a href="https://www.youtube.com/watch?v=doqmcvtWcrM" target="_blank">
  <img width="1275" height="665" alt="image" src="https://github.com/user-attachments/assets/d59ce3a0-7c60-4fcf-8723-ff056415c7f4" />
</a>
