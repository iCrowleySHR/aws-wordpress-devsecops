# Wordpress em alta-disponibilidade na AWS

Essa arquitetura simula um ambiente de produção real, no qual interrupções não podem 
causar indisponibilidade da aplicação. Além disso, o uso de serviços gerenciados permite 
focar na lógica de implantação e escalabilidade, sem a necessidade de gerenciar 
manualmente servidores de banco de dados ou sistemas de arquivos distribuídos.

Este projeto tem como objetivo desenvolver competências práticas em infraestrutura como 
código, provisionamento de recursos em nuvem, e arquiteturas resilientes, utilizando 
ferramentas modernas e os serviços oferecidos pela AWS

# Como fazer?
Veja o passo a passo a seguir para criar essa aplicação na AWS

<img width="1219" height="550" alt="image" src="https://github.com/user-attachments/assets/825ec8af-1eb9-4bbd-b727-693494b9da12" />

---

## VPC
### Para iniciar devemos criar uma VPC

<img width="1920" height="878" alt="image" src="https://github.com/user-attachments/assets/127989ee-f70a-43c3-8de8-e4cdc0e15331" />

### Nas configurações da VPC, siga a imagem abaixo para criação dela já com a configuração de subnets, zonas de disponibilidade e etc

<img width="1891" height="637" alt="image" src="https://github.com/user-attachments/assets/533ad3e2-ae7f-4c1e-8ad8-d3b1f6c21c0d" />

<img width="411" height="750" alt="image" src="https://github.com/user-attachments/assets/ec8c184b-4db3-4ce5-907b-d3d2c5e7be00" />

<img width="1920" height="860" alt="image" src="https://github.com/user-attachments/assets/1ade46ce-5ec4-4371-8e7b-73e0191cbd76" />

### Após a criação, entre nas suas sub-redes para conferir, alteraremos o nome para melhor compreensão, sendo duas subnets para aplicação (app), duas públicas (public) e duas para o EFS e RDS (data).

<img width="1920" height="468" alt="image" src="https://github.com/user-attachments/assets/f1f46bf8-cc58-43c3-940f-1d4cd343d61c" />

---

## Nat Gateway

### Agora devemos criar duas Nat Gateways para seguir com o diagrama, lembre-se de linkar o IP Elástico e de escolher a sub-net certa conforme a imagem. Para cada região haverá um Nat Gateway, logo, um nat Gateway para a us-east-1a e outro para us-east-1b

<img width="1919" height="904" alt="image" src="https://github.com/user-attachments/assets/dc61311f-c234-4e26-918e-86a9cde1132a" />

<img width="1920" height="897" alt="image" src="https://github.com/user-attachments/assets/71025b7f-2828-4ece-a3a4-58891fd919d5" />

<img width="1919" height="928" alt="image" src="https://github.com/user-attachments/assets/c4bf3590-9c24-4836-80b0-297df1260eaa" />

---

## Tabela de Rotas e Associação do Nat Gateway
### Nas tabelas de rotas, devemos colocar os nat gateways criado e associar as sub-redes de data e app. Segue o passo a passo em imagens de como foi aplicado nas duas regiões

<img width="1920" height="931" alt="image" src="https://github.com/user-attachments/assets/fdeaf6f2-73d4-4563-b39e-16c67e7b839e" />

<img width="1920" height="930" alt="image" src="https://github.com/user-attachments/assets/5541e9e5-5e51-4575-bd4e-01ae040f159a" />

<img width="1920" height="926" alt="image" src="https://github.com/user-attachments/assets/c3f25010-35ce-4ede-a254-8b9703f9989e" />

<img width="1920" height="938" alt="image" src="https://github.com/user-attachments/assets/27064aed-1b8d-4ded-a5c5-3541346773ca" />

<img width="1920" height="926" alt="image" src="https://github.com/user-attachments/assets/08f2dca8-770e-4ddd-9b29-078e4ad43cd7" />

<img width="1915" height="928" alt="image" src="https://github.com/user-attachments/assets/0d3d8daf-8009-47a9-89f2-78c77e2a2bb3" />

<img width="1890" height="928" alt="image" src="https://github.com/user-attachments/assets/948ac489-babb-494e-8a9e-d3083647633e" />

<img width="1920" height="929" alt="image" src="https://github.com/user-attachments/assets/da2b81df-67c0-4296-aeb5-38e8a6ced4f2" />

<img width="1920" height="932" alt="image" src="https://github.com/user-attachments/assets/1375278c-358c-4cbc-bbae-f37c2e04bc8e" />

<img width="1920" height="930" alt="image" src="https://github.com/user-attachments/assets/27480330-db56-4d22-8a39-2ead1dd41458" />

---

## Revisão do Mapa de Recursos
### Com isso, no mapa de recursos da sua VPC, deve ser esse o resultado que você vai encontrar, caso esteja diferente, pode ter ocorrido algum má configuração da aplicação

<img width="1674" height="407" alt="image" src="https://github.com/user-attachments/assets/1d43e7d8-cf39-4b34-b571-867c95fb4148" />

--- 

## Grupo de Segurança
### Agora iremos configurar os grupos de segurança da nossa aplicação, veja as configurações conforme o diagrama

<img width="1920" height="933" alt="image" src="https://github.com/user-attachments/assets/b2cd5d71-e013-4d08-9086-c6e730feb9e2" />

### Load Balancer

<img width="1920" height="803" alt="image" src="https://github.com/user-attachments/assets/6c6d5014-9409-4c6a-8024-a90d6441f41c" />

### Bastion

<img width="1920" height="933" alt="image" src="https://github.com/user-attachments/assets/07ef4061-ae61-477d-8bcc-9eb78be546cf" />

### EC2

<img width="1728" height="717" alt="image" src="https://github.com/user-attachments/assets/fd47bdc7-0a3c-4e1a-98ae-2879011d6ee0" />

> Na porta 8080 do TCP personalizado, deixe com o Grupo de Segurança do Load Balance, igual a do Wordpress na porta 80, na porta 22 o SG do Bastion

### RDS (RELATIONAL DATABASE)

<img width="1915" height="927" alt="image" src="https://github.com/user-attachments/assets/25db4ce8-3cc6-4b8b-92cb-e69d4a400bb3" />

### EFS

<img width="1920" height="923" alt="image" src="https://github.com/user-attachments/assets/19c5dbe8-65c9-4e84-ae86-9bc5dab2f287" />

---

## Subnet do RDS
### Agora iremos no serviço Aurora and RDS, nela iremos na configuração `Grupos de sub-redes`

<img width="1920" height="935" alt="image" src="https://github.com/user-attachments/assets/2064ad1f-f4a8-41b6-9ba3-e62b2b94f009" />

### Criaremos uma sub-redes entre as duas zonas de disponibilidade, veja as configurações abaixo conforme a imagem

<img width="1920" height="930" alt="image" src="https://github.com/user-attachments/assets/2edc3ba0-ab2d-47ec-9be1-bd2a8565cd7b" />

---

## Banco de Dados RDS
### Depois de criarmos, iremos criar nossa instância do Banco de Dados

<img width="1920" height="929" alt="image" src="https://github.com/user-attachments/assets/274d3fb5-8a75-4357-a1ae-032914226cab" />

<img width="1920" height="717" alt="image" src="https://github.com/user-attachments/assets/fa5ff95b-7c05-48d4-8001-5b5c602d9ce8" />

<img width="1920" height="506" alt="image" src="https://github.com/user-attachments/assets/52ae8612-c03d-4996-8054-a80ee74574f5" />

<img width="1920" height="579" alt="image" src="https://github.com/user-attachments/assets/45b77769-844d-4b4f-9e10-37ab523cd6ee" />

<img width="1920" height="707" alt="image" src="https://github.com/user-attachments/assets/73e35d01-0386-46bd-af69-68f833eb75b9" />

<img width="1920" height="504" alt="image" src="https://github.com/user-attachments/assets/2915d236-90dd-4594-a668-738d8dcae120" />

> Vá em configurações adicionais e crie o nome do banco com o mesmo nome da instancia! Se não vai dar erro de falta de conexão no Wordpress

---

## EFS
### Agora vamos configurar e criar o EFS

<img width="1920" height="929" alt="image" src="https://github.com/user-attachments/assets/5c95e978-4e2a-4686-a202-75123f551585" />

<img width="1920" height="888" alt="image" src="https://github.com/user-attachments/assets/e99a8f6d-66c1-4a1b-b213-7939235e08d7" />

> Clica em personalizar

<img width="1920" height="926" alt="image" src="https://github.com/user-attachments/assets/da8219ca-6b65-4773-9158-78615f48fafa" />

<img width="1920" height="931" alt="image" src="https://github.com/user-attachments/assets/3a88152d-0d2a-444b-8bfa-5ab2cfe57a98" />

> Coloque a subnet (data) da sua respectiva região e o Grupo de Segurança do EFS que criamos anteriormente 

---

## Launch Template (Modelo de execução)
### Para as nossas instâncias já vierem configurada, iremos usar um Launch Template junto com o User Data do nosso repositório
#### Lembre-se de colocar as suas credencias para conexão do banco do phpMyAdmin, Wordpress e montagem do EFS

<img width="1920" height="926" alt="image" src="https://github.com/user-attachments/assets/145fdeff-7e8e-43f3-be30-c9a954bb6962" />

<img width="1917" height="466" alt="image" src="https://github.com/user-attachments/assets/09764daa-e41f-4a84-a6e2-78a1c87e3d77" />

<img width="1077" height="558" alt="image" src="https://github.com/user-attachments/assets/6bac01a2-332d-455c-ad7c-a915335dc2da" />

<img width="1918" height="972" alt="image" src="https://github.com/user-attachments/assets/2336de80-2c3b-41c2-be89-bb2255aef243" />

> Troque as variaves com as suas credencias do seu RDS (senha, user, host e banco), região da AWS e id da EFS

---

## Application Load Balancer
### Para fazer o direcionamento de rotas para as instâncias, vamos configurar o ALB. Nessa etapa também criamos o Targets Groups (Grupos de destino)

<img width="1917" height="974" alt="image" src="https://github.com/user-attachments/assets/858168b4-31ad-4574-b13d-76acd2b55ff4" />

<img width="1920" height="938" alt="image" src="https://github.com/user-attachments/assets/14435b26-7b3c-4878-98c5-0ada274f0e74" />

<img width="1913" height="635" alt="image" src="https://github.com/user-attachments/assets/91b14fde-714d-4130-99ca-4c525aca590c" />

<img width="1920" height="533" alt="image" src="https://github.com/user-attachments/assets/9cab8720-464e-439f-bcf3-1621859f46a7" />

<img width="1920" height="207" alt="image" src="https://github.com/user-attachments/assets/d2207dfd-7bf9-4515-9c7f-e6d28e08dc57" />

<img width="1920" height="776" alt="image" src="https://github.com/user-attachments/assets/792cc159-9650-4c13-a75f-cfc0161d343d" />

>  Vá em criar grupo de destino

## Grupos de destino
### Crie o grupo de destino para o Wordpress

<img width="1919" height="696" alt="image" src="https://github.com/user-attachments/assets/18a0fb79-2a93-418e-8337-42caca2c664a" />

<img width="1920" height="526" alt="image" src="https://github.com/user-attachments/assets/0c3f5382-d44c-4188-955e-fb591636aef2" />

<img width="1920" height="927" alt="image" src="https://github.com/user-attachments/assets/8965810d-cfa4-4cc8-8ed4-1b4f26af3fcf" />

<img width="1920" height="862" alt="image" src="https://github.com/user-attachments/assets/71f88d0f-7f82-4998-81e0-017215ed4d3f" />

### Crie outra Grupo de destino para a porta 8080, para redirecionar o tráfego pro PhpMyAdmin, seguindo a mesma configuração, apenas mudando a porta.


<img width="1641" height="827" alt="image" src="https://github.com/user-attachments/assets/887c20df-9d37-4abd-915e-c2c05f9f22cc" />

<img width="1920" height="930" alt="image" src="https://github.com/user-attachments/assets/18c9922a-7dcf-452e-8b4b-15e46a0f31de" />

## ALB + Target Group

<img width="1427" height="697" alt="image" src="https://github.com/user-attachments/assets/07286063-3353-4e7b-a602-3cb970008fd8" />

> Errei nos Target Group, porém, coloque o 80 no Wordpress e o 8080 no phpMyAdmin

> Na imagem está as duas portas no phpMyAdmin

<img width="1373" height="509" alt="image" src="https://github.com/user-attachments/assets/ba12e597-d5a1-43e6-83b1-4b46db23007a" />


#### No final ficará assim, a 80 para o Wordpress e o 8080 para o phpMyAdmin

<img width="1920" height="930" alt="image" src="https://github.com/user-attachments/assets/adcac135-0a95-4ff6-866e-e572391902ed" />

---

## Configuração do Auto Scaling
### Para ter o escalonamento automático da nossa Lauch Template pré configurada, vamos usar o Auto Scaling


<img width="1920" height="932" alt="image" src="https://github.com/user-attachments/assets/cda016c0-47c9-4a0b-bd99-41b36d5b5d49" />

<img width="1920" height="921" alt="image" src="https://github.com/user-attachments/assets/6441e22c-30a2-4369-a86e-f3b8ed5e4346" />

<img width="1920" height="931" alt="image" src="https://github.com/user-attachments/assets/85d5cb9f-000b-45e7-bb00-d8bb2f64704c" />

<img width="1920" height="899" alt="image" src="https://github.com/user-attachments/assets/6f6e5334-88d6-423f-95e8-083bae0b6dc2" />

<img width="1915" height="709" alt="image" src="https://github.com/user-attachments/assets/0c0a6950-f96d-424d-b816-6a701efea4dc" />



<img width="1919" height="694" alt="image" src="https://github.com/user-attachments/assets/beeee04f-4a35-4525-a111-283d9f1301ac" />

<img width="1918" height="892" alt="image" src="https://github.com/user-attachments/assets/10e01e50-fce4-4fb1-9a50-cea67511d9b7" />

---

## Conclusão

### Pegue o DNS do seu Load Balance que você já vai conseguir acessar, colocando o porta 8080 você consegue acessar o phpMyAdmin

#### Para o Wordpress

```bash
http://SEUDNSALB.COM:80
```

#### Para o phpMyAdmin

```bash
http://SEUDNSALB.COM:8080
```

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/68450d1f-b932-4b92-b816-5554616c90c2" />

## Veja o vídeo abaixo da aplicação funcionando
