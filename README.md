# docker-images
A project for building docker images used by services and infrastructure


## Building and pushing the image
```
sudo docker login https://registry.alexanderhopgood.com
export TAG=$(date "+%Y%m%d-%H%M%S")
sudo docker build -f Dockerfile . -t reclusive/jenkins-agent-docker-cli:${TAG} -t reclusive/jenkins-agent-docker-cli:latest
sudo docker push reclusive/jenkins-agent-docker-cli:${TAG}
sudo docker push reclusive/jenkins-agent-docker-cli:latest
docker logout 
```
## Nomad-Jenkins-Agent

Adding to tests:
```
sudo dgoss edit -e DOCKER_HOST=tcp://192.168.56.10:4243 \
    -e JENKINS_SECRET=01fa19003732d879d8bcf3f85a4c33e6b0fb243ad3b8a4aaf80e6bda6bae0942 \
    -e JENKINS_TUNNEL=192.168.56.10:50000 \
    -e JENKINS_AGENT_NAME=nomad \
    -e JENKINS_URL=http://192.168.56.10:8080 \
    -d reclusive/jenkins-agent-docker-cli:latest
```
Running tests:
```
sudo dgoss run -e DOCKER_HOST=tcp://192.168.56.10:4243 \
    -e JENKINS_SECRET=01fa19003732d879d8bcf3f85a4c33e6b0fb243ad3b8a4aaf80e6bda6bae0942  \
    -e JENKINS_TUNNEL=192.168.56.10:50000 \
    -e JENKINS_AGENT_NAME=nomad \
    -e JENKINS_URL=http://192.168.56.10:8080 \
    -d reclusive/jenkins-agent-docker-cli:latest
````
