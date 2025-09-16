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


## VPC
Entraremos no serviço **VPC** e criaremos uma Virtual Private Cloud.

`VPC -> Suas VPCs -> Criar VPC`

<img width="1397" height="684" alt="image" src="https://github.com/user-attachments/assets/15157df7-baaf-4ae1-b29c-830b206096d4" />


## Subnets
Agora entraremos e configuraremos as 6 **Subnets** conforme o diagrama.

`VPC -> Sub-redes -> Criar sub-redes`

<img width="1674" height="308" alt="image" src="https://github.com/user-attachments/assets/44110044-74c1-4a9c-bd07-995951c909df" />

> Em todas as subnets você vai selecionar a VPC que criamos anteriormente!

### Públicas
<img width="1642" height="755" alt="image" src="https://github.com/user-attachments/assets/8a72ccd9-bcd9-4b22-80d4-0ea36ce5d529" />

<img width="1650" height="776" alt="image" src="https://github.com/user-attachments/assets/92ef52d7-9c59-4482-8d5b-46a9c5f14b49" />

### Privadas

#### Data
<img width="1659" height="795" alt="image" src="https://github.com/user-attachments/assets/f1e864b8-3660-4a8e-993e-01df74d262f9" />

<img width="1655" height="793" alt="image" src="https://github.com/user-attachments/assets/9e7b0923-76dd-4fbd-85e5-155586443ee3" />

#### App

<img width="1658" height="798" alt="image" src="https://github.com/user-attachments/assets/e1088424-9396-4594-9aad-8294aca60bab" />

<img width="1643" height="796" alt="image" src="https://github.com/user-attachments/assets/1ff7596d-574d-4c03-b5cc-982f722df78c" />

---

No final você vai encontrar esse resultado na sua lista de **Subnets**

<img width="1656" height="349" alt="image" src="https://github.com/user-attachments/assets/e0bf5cf8-3f67-49e9-992e-82bb14e1bf2a" />

## Gateway da Internet

Criaremos um **Gateway da Internet** e atrelaremos a nossa VPC.

`VPC -> Gateways da Internet -> Criar gateway da Internet`

<img width="1462" height="473" alt="image" src="https://github.com/user-attachments/assets/9b60ec61-34a5-49e2-8647-e2f9dc360b8d" />

Depois de criar, devemos associar a nossa VPC

<img width="1665" height="408" alt="image" src="https://github.com/user-attachments/assets/afe7cc59-1955-4e12-8abc-b9ad44dc900f" />

<img width="1473" height="318" alt="image" src="https://github.com/user-attachments/assets/e062110b-f0a2-44ca-9b9e-5e44aacccac2" />

## Nat Gateway

Criaremos um **Nat Gateway** e atrelaremos as nossas subnets públicas.

`VPC -> Gateways NAT -> Criar gateway NAT`

<img width="1646" height="751" alt="image" src="https://github.com/user-attachments/assets/4a96608f-1d6f-4010-8c84-b1e9a8310381" />

<img width="1649" height="749" alt="image" src="https://github.com/user-attachments/assets/5404ceb6-711a-4f0c-b6ea-5d8badd50306" />

## Route Table

Criaremos as **Routers Tables** públicas e privadas paras os serviços.

<img width="1655" height="554" alt="image" src="https://github.com/user-attachments/assets/4c3c7d2d-1bbe-4e99-b5f1-885fa3512ed2" />

<img width="1664" height="559" alt="image" src="https://github.com/user-attachments/assets/6117df50-7f8f-4b58-86ba-4b50786ac601" />

<img width="1668" height="278" alt="image" src="https://github.com/user-attachments/assets/2f11cee4-4d63-4498-ac60-bb9c766f0d36" />

### Associar Routers Tables em Subnets

Para associar, faça:

<img width="1675" height="415" alt="image" src="https://github.com/user-attachments/assets/fef20d77-f5e4-42d2-b1d7-0bdee42c41a5" />

<img width="1691" height="613" alt="image" src="https://github.com/user-attachments/assets/d45079b2-eec7-4943-bf35-660ca703d9a7" />

<img width="1672" height="425" alt="image" src="https://github.com/user-attachments/assets/8e0915e1-1b25-48e4-8b75-b4e8f425749e" />

<img width="1711" height="591" alt="image" src="https://github.com/user-attachments/assets/870f97a1-c8a6-4a57-ae15-6b94c4ac5df6" />

## Security Groups

Criaremos todos os Grupos de segurança

`VPC -> Grupos de segurança -> Criar grupo de segurança`

<img width="1914" height="844" alt="image" src="https://github.com/user-attachments/assets/c2421332-95e7-4c00-be84-9b1ff999c45e" />

> Criaremos primeiros sem regras de entrada e saída, configuraremos depois da criação de todos os SG.

## Regras

### EC2

<img width="1920" height="631" alt="image" src="https://github.com/user-attachments/assets/74ee8810-7c83-4031-a748-e489b52dfffe" />

<img width="1911" height="609" alt="image" src="https://github.com/user-attachments/assets/1a16d044-9869-4d35-af7f-63aea393795a" />

### Application Load Balancer

<img width="1920" height="555" alt="image" src="https://github.com/user-attachments/assets/f15f973e-2735-445a-9b2f-3ecf750a4442" />

<img width="1920" height="489" alt="image" src="https://github.com/user-attachments/assets/3dc69e3c-db41-4d42-883b-7f80ddfd3565" />

### RDS 

<img width="1920" height="492" alt="image" src="https://github.com/user-attachments/assets/5b9e702f-802d-4043-acdf-19d3ae265c60" />

<img width="1920" height="516" alt="image" src="https://github.com/user-attachments/assets/f5754ea5-c43d-4ac7-878b-357c2caeb7b1" />

### EFS

<img width="1920" height="535" alt="image" src="https://github.com/user-attachments/assets/6de68e17-4760-48da-adc9-395212ab5647" />

<img width="1920" height="494" alt="image" src="https://github.com/user-attachments/assets/1d88a100-5713-4d1d-858c-cf7c3316c728" />

### Bastion

<img width="1920" height="600" alt="image" src="https://github.com/user-attachments/assets/d8a81cf1-58f8-4c09-9105-5f4493374be5" />

<img width="1920" height="551" alt="image" src="https://github.com/user-attachments/assets/d90a599a-0986-4394-9cdc-2cd33212d70a" />







