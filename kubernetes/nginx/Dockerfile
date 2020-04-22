FROM nginx:1.17-alpine

# Wipe conflicting, boilerplate default.conf file
RUN rm /etc/nginx/conf.d/default.conf

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/fredcast.conf /etc/nginx/conf.d/fredcast.conf

EXPOSE 80 443
