# build Dockerfile on our own
# tagging with "latest" and current SHA
docker build -t kuangyu0801/multi-client:latest -t kuangyu0801/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t kuangyu0801/multi-server:latest -t kuangyu0801/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t kuangyu0801/multi-worker:latest -t kuangyu0801/multi-worker:$SHA -f ./server/Dockerfile ./worker

# push all tags to docker hub (already logged-in)
docker push kuangyu0801/multi-client:latest 
docker push kuangyu0801/multi-server:latest 
docker push kuangyu0801/multi-worker:latest 
docker push kuangyu0801/multi-client:$SHA
docker push kuangyu0801/multi-server:$SHA 
docker push kuangyu0801/multi-worker:$SHA

# apply image to deployment
kubectl apply -f k8s
# deploy with the SHA build image to guarantee updated deployment
kubectl set image deployments/server-deployment server=kuangyu0801/multi-server:$SHA
kubectl set image deployments/client-deployment client=kuangyu0801/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=kuangyu0801/multi-worker:$SHA