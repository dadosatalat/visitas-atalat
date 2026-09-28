# 🥛 Atalat — Gestão Integrada de Visitas a Produtores de Leite

Sistema web moderno e completo para captação de leite, relacionamento com fornecedores, defesa de rotas, registro de perdas e inteligência de campo da **Atalat Laticínios**.

---

## 🚀 Tecnologias e Arquitetura

* **Frontend:** Single Page Application (HTML5, CSS3 Moderno, JavaScript ES6+).
* **Banco de Dados em Nuvem:** [Supabase](https://supabase.com) (PostgreSQL gerenciado com Realtime e Row Level Security).
* **Armazenamento Offline-First:** Salva localmente no dispositivo (`localStorage`) e sincroniza com a nuvem quando houver conexão.
* **Hospedagem & Deploy:** [Vercel](https://vercel.com) com deploy contínuo via GitHub.
* **Formatos de Exportação:** Microsoft Excel (`.csv` com UTF-8 BOM), Backup completo (`.json`) e Resumos para WhatsApp.

---

## 📁 Estrutura de Arquivos

```
visitas-atalat/
├── index.html                     # Aplicação web principal (pronta para Vercel)
├── Atalat_Visitas_Interativo.html  # Cópia para execução local independente
├── schema.sql                     # Script SQL para criar tabelas e políticas no Supabase
├── vercel.json                    # Configuração de roteamento e segurança da Vercel
├── .gitignore                     # Arquivos ignorados pelo Git
└── README.md                      # Guia completo de configuração e deploy
```

---

## 🛠️ Passo a Passo para Colocar Online

### 1️⃣ Passo 1: Criar o Banco de Dados no Supabase (Grátis)

1. Crie uma conta gratuita em [supabase.com](https://supabase.com) e clique em **"New project"**.
2. Escolha um nome (ex.: `atalat-visitas`), defina uma senha de banco e selecione a região (ex.: *São Paulo / South America*).
3. No menu lateral esquerdo do Supabase, clique em **SQL Editor** (`</>`).
4. Clique em **"New query"**, abra o arquivo [`schema.sql`](schema.sql), copie todo o conteúdo, cole no editor do Supabase e clique em **"Run"** (ou `Ctrl + Enter`).
   * *Isso criará as tabelas `visitas`, `tipos_visitas`, índices de busca, segurança RLS e canal Realtime.*
5. No menu lateral esquerdo, vá em **Project Settings** (ícone de engrenagem ⚙️) > **API**.
6. Guarde duas informações:
   * **Project URL** (ex.: `https://abcdefghijklm.supabase.co`)
   * **anon / public key** (chave longa que começa com `eyJhbGci...`)

---

### 2️⃣ Passo 2: Criar Repositório no GitHub e Fazer o Push

Abra o terminal (PowerShell ou Git Bash) nesta pasta e execute os comandos abaixo:

```bash
# 1. Inicializar o repositório Git local
git init

# 2. Adicionar todos os arquivos
git add .

# 3. Criar o primeiro commit
git commit -m "feat: Sistema de Gestão de Visitas Atalat com Supabase e Vercel"

# 4. Renomear a branch principal para main
git branch -M main

# 5. Criar o repositório no seu GitHub (https://github.com/new) com o nome visitas-atalat
# Em seguida, vincule o repositório remoto (substitua SEU_USUARIO pelo seu usuário no GitHub):
git remote add origin https://github.com/SEU_USUARIO/visitas-atalat.git

# 6. Enviar o código para o GitHub
git push -u origin main
```

---

### 3️⃣ Passo 3: Fazer o Deploy na Vercel (1 Clique)

1. Acesse [vercel.com](https://vercel.com) e faça login (pode entrar com sua conta do GitHub).
2. No painel da Vercel, clique em **"Add New..."** > **"Project"**.
3. Na lista de repositórios do GitHub, localize **`visitas-atalat`** e clique em **"Import"**.
4. Em **Framework Preset**, deixe como **"Other"** (projeto estático / HTML).
5. Clique em **"Deploy"**.
6. Em menos de 1 minuto seu link de produção estará no ar (ex.: `https://visitas-atalat.vercel.app`)!

---

### 4️⃣ Passo 4: Conectar a Aplicação Online ao Supabase

1. Abra o link da sua aplicação na Vercel.
2. No topo da tela, clique no botão **`🟡 Modo Offline / Local`**.
3. Cole a **Project URL** e a **Anon Public Key** obtidas no Passo 1.
4. Clique em **"Salvar e Conectar"**.
5. O status mudará imediatamente para **`🟢 Supabase Conectado`** e todas as visitas cadastradas por você ou pela equipe serão sincronizadas em tempo real na nuvem!

---

## 📱 Recursos e Vantagens para a Equipe de Campo

* **Offline-First:** Funciona mesmo sem sinal de celular ou internet nas fazendas. As visitas são salvas localmente e sincronizam automaticamente ao reconectar.
* **Captura de GPS:** Pressione *📍 Capturar GPS Atual* para registrar latitude e longitude da propriedade.
* **WhatsApp Integrado:** Envie resumos executivos da visita diretamente no WhatsApp da gerência ou do produtor.
* **Exportação para Excel:** Baixe relatórios tabulares em `.csv` compatíveis com Excel brasileiro.
* **Painel Analítico BI:** Gráficos de distribuição de risco, ranking de volume por rota e alerta de ações com prazo vencido.
