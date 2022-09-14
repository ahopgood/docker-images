pipeline {
    agent { label 'docker' }
    stages {
        stage ('Test') {
            sh '''
                bash --version
                docker --version
            '''
        }
    }
}
