pipeline {
    agent { label 'Docker' }
    environment {
        IMAGE_NAME="jenkins-agent-docker-cli"
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
                git credentialsId: 'github_token', url: 'https://github.com/ahopgood/docker-images.git', branch: '${BRANCH_NAME}'
                sh 'docker --version'
                sh 'git --version'
                sh '''
                    chmod +x getVersionTag.sh
                    VERSION=$(./getVersionTag.sh)
                    docker build . -t ${IMAGE_NAME}:${VERSION}

                    echo "Docker Image version: ${VERSION}"
                '''
            }
        } //End build stage
        stage('Docker Image Vulnerability Scan') {
            agent { label 'Docker && Grype' }
            steps {
                git credentialsId: 'github_token', url: 'https://github.com/ahopgood/domain-placeholders.git', branch: '${BRANCH_NAME}'
                sh'''
                    grype version
                    chmod +x getVersionTag.sh
                    VERSION=$(./getVersionTag.sh)
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
                        chmod +x getVersionTag.sh
                        VERSION=$(./getVersionTag.sh)
                        NAMESPACE="reclusive/"

                        echo "Docker Image version: ${VERSION}"
                        echo "Docker registry: ${DOCKER_REGISTRY}"

                        echo ${PASSWORD} | docker login --username ${USERNAME} --password-stdin  https://${DOCKER_REGISTRY}
                        docker tag ${IMAGE_NAME}:${VERSION} ${DOCKER_REGISTRY}/${NAMESPACE}${IMAGE_NAME}:${VERSION}
                        docker tag ${IMAGE_NAME}:${VERSION} ${DOCKER_REGISTRY}/${NAMESPACE}${IMAGE_NAME}:latest

                        docker push ${DOCKER_REGISTRY}/${NAMESPACE}${IMAGE_NAME}:${VERSION}
                        docker push ${DOCKER_REGISTRY}/${NAMESPACE}${IMAGE_NAME}:latest
                        docker logout https://${DOCKER_REGISTRY}
                    '''
                } //End credentials block
            }
        } //End push to registry stage
    }
}
