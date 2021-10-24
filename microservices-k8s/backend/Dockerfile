FROM python:3.8-slim-bullseye

RUN mkdir -p /data/microservice

# We copy just the requirements.txt first to leverage Docker cache
COPY ["backend/requirements.txt","backend/app.py", "/data/"]
COPY ["backend/microservice/", "/data/microservice/"]

RUN apt update \
&& pip install --upgrade pip \
&& pip install --no-cache-dir -r /data/requirements.txt 

WORKDIR /data

ENTRYPOINT ["gunicorn"]

CMD ["--bind", "0.0.0.0:8000", "app:app"]

# cd backend/ && export FLASK_APP=app && flask run  # port 5000   
# docker build -t <account>/microservice:v0.0.1 .
# docker run --rm --name micro-service -it -e PSQL_DB_ADDRESS=192.168.1.45 -p 5001:8000 -d <account>/microservice:v0.0.1
# helm install --dry-run --debug micro-backend  --set service.type=NodePort --set service.nodePort=30222 micro-backend 
# helm install micro-backend  --set service.type=NodePort --set service.nodePort=30222 micro-backend 
# helm upgrade micro-backend --set replicaCount=4 --set service.type=ClusterIP --set service.nodePort= micro-backend\ 
# kubectl run -i --tty busybox --image=busybox --restart=Never -- sh
