pipeline {
    agent { label 'Docker' }
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
