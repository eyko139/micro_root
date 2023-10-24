FROM node:16.14.2-alpine as build
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . ./
RUN npm run build

FROM nginx:1.21.0-alpine as production
ENV NODE_ENV production
# Copy built assets from `builder` image
COPY --from=build /app/dist /usr/share/nginx/html
# Add your nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Expose port
EXPOSE 80
# Start nginx
CMD ["nginx", "-g", "daemon off;"]
