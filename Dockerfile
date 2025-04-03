# Usa uma versão mais recente do Node.js
FROM node:22.14-alpine3.21

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia apenas os arquivos essenciais para instalar dependências
COPY package.json package-lock.json* ./

# Copia o restante do código do projeto
COPY . .

# Remove node_modules e package-lock.json para evitar problemas de cache
RUN rm -rf node_modules

ENV NPM_CONFIG_OPTIONAL=false

# Instala as dependências com npm ci para garantir consistência
RUN npm ci --no-optional --force --loglevel verbose

RUN npm install @rollup/rollup-linux-arm64-musl --save-dev

# Expondo a porta padrão do Vite
EXPOSE 5173

# Corrige problemas de permissões
RUN chown -R node:node /app
USER node

# Comando para rodar a aplicação Vue.js
CMD ["npm", "run", "dev"]
