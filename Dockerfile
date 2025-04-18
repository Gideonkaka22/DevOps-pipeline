FROM node:14

WORKDIR /app

COPY server.js .

EXPOSE 8081

CMD ["node", "server.js"]
