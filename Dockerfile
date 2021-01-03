FROM node:8.16-alpine
ENV NODE_ENV=production
ENV HOST 0.0.0.0
RUN mkdir -p /app
COPY . /app
WORKDIR /app
EXPOSE 8011
#RUN npm config set registry https://registry.npm.taobao.org
RUN npm install
RUN npm run build
CMD [ "npm","start" ]
