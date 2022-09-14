pipeline {
    agent { label 'docker' }
    stages {
        stage ('Test') {
            steps {
                sh '''
                    bash --version
                    docker --version
                '''
            }
        }
    }
}
