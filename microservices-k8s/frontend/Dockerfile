# Stage 1
FROM node:14-stretch-slim  as react-build
WORKDIR /app
COPY /. ./
RUN npm i && npm run build


# Stage 2 - the production environment
# https://daten-und-bass.io/blog/serving-a-vue-cli-production-build-on-a-sub-path-with-nginx/
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=react-build /app/build /usr/share/nginx/html/app
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


# cd frontend
# docker build -t <account>/frontend:v0.0.3 .

# Run front-end React as docker container locally
# docker run --rm --name ft -it -p 3001:80 -d <account>/frontend:v0.0.3
# docker exec -it ft sh
# helm install --dry-run --debug micro-frontend --set service.type=NodePort --set service.nodePort=30222 micro-frontend
# helm install micro-frontend --set service.type=NodePort --set service.nodePort=30222 micro-frontend
# kubectl run -i --tty busybox --image=busybox --restart=Never -- sh
# helm install nginx-ingress-controller --set controller.service.type=NodePort --set controller.service.nodePorts.http=30444 bitnami/nginx-ingress-controller
# helm install nginx-ingress --set controller.service.type=NodePort stable/nginx-ingress
# kubectl exec -it $(kubectl get pods | grep "nginx-ingress-controller" | awk -F" " '{print $1}' ) -- cat /etc/nginx/nginx.conf > reversenginx.conf
# kubectl exec -it $(kubectl get pods | grep "nginx-ingress-controller" | awk -F" " '{print $1}' ) -- cat /etc/nginx/nginx.conf > reversenginx.conf
# kubectl get endpoints
# kubectl get ing
# note the ip address of node ingress controller is setup with routing rules using kubectl get ing and add that ip address in host file with hostname in ingress is setup to point
# helm upgrade micro-frontend --set service.type=ClusterIP --set service.nodePort= micro-frontend/
# helm list
# helm upgrade micro-frontend --set replicaCount=2 --set service.type=ClusterIP --set service.nodePort= micro-frontend/