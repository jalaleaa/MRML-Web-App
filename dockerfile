#docker build -t mrml-web-app .^

FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build


FROM nginx:1.27-alpine

# ลบ config เดิม
RUN rm /etc/nginx/conf.d/default.conf

# copy config ใหม่
COPY nginx.conf /etc/nginx/conf.d/default.conf

# copy build
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 8097

CMD ["nginx", "-g", "daemon off;"]