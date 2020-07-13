apk update
apk add openssl
mkdir /etc/nginx/ssl
cd /etc/nginx/ssl
openssl req -x509 -nodes  -subj '/CN=localhost' -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
