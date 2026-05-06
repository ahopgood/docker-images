pipeline {
    agent { label 'Docker && Grype' }
    environment {
        IMAGE_NAME="jenkins-agent-docker-cli"
        VERSION=sh(script: "chmod +x getVersionTag.sh && ./getVersionTag.sh", returnStdout:true)
    }
    stages {
        stage ('Test') {
            steps {
                sh '''
                    bash --version
                    docker --version
                '''
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker --version'
                sh 'git --version'
                sh '''
                    docker build . -t ${IMAGE_NAME}:${VERSION}

                    echo "Docker Image version: ${VERSION}"
                '''
            }
        } //End build stage
        stage('Goss - verify configuration of docker image') {
            steps {
                sh 'docker --version'
                sh 'git --version'
                sh '''
                docker build . -t ${IMAGE_NAME}:${VERSION}
                GOSS_VERSION=v0.3.10
                curl -L "https://github.com/aelsabbahy/goss/releases/download/${GOSS_VERSION}/dgoss" -o /usr/local/bin/dgoss
                chmod +rx /usr/local/bin/dgoss
                     curl -L "https://github.com/aelsabbahy/goss/releases/download/${GOSS_VERSION}/goss-linux-amd64" -o /usr/local/bin/goss
                     chmod +rx /usr/local/bin/goss
      
                dgoss run -e DOCKER_HOST=tcp://anyhost:anyport \
                    -e JENKINS_SECRET=01fa19003732d879d8bcf3f85a4c33e6b0fb243ad3b8a4aaf80e6bda6bae0942 \
                    -e JENKINS_TUNNEL=anyhost:anyport \
                    -e JENKINS_AGENT_NAME=nomad \
                    -e JENKINS_URL=http://192.168.56.10:8080 \
                    -d ${IMAGE_NAME}:${VERSION}
                '''
            }
        } //End test stage
        stage('Docker Image Vulnerability Scan') {
            steps {
                sh'''
                    grype version
                    grype ${IMAGE_NAME}:${VERSION} -c .grype.yaml
                '''
            }
        } //End Vulnerability Scan Stage
        stage ('Push Docker Image to Prod Registry') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                        NAMESPACE="reclusive/"

                        echo "Docker Image version: ${VERSION}"
                        echo "Docker registry: ${DOCKER_REGISTRY}"

                        echo "${PASSWORD}" | docker login --username ${USERNAME} --password-stdin  https://${DOCKER_REGISTRY}
                        docker tag ${IMAGE_NAME}:${VERSION} ${DOCKER_REGISTRY}${NAMESPACE}${IMAGE_NAME}:${VERSION}
                        docker tag ${IMAGE_NAME}:${VERSION} ${DOCKER_REGISTRY}${NAMESPACE}${IMAGE_NAME}:latest

                        docker push ${DOCKER_REGISTRY}${NAMESPACE}${IMAGE_NAME}:${VERSION}
                        docker push ${DOCKER_REGISTRY}${NAMESPACE}${IMAGE_NAME}:latest
                        docker logout https://${DOCKER_REGISTRY}
                    '''
                } //End credentials block
            }
        } //End push to registry stage
    }
}
