pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:$PATH"
    }
    stages {
        stage('Deploy Data Base') {
            steps {
                echo 'Deploying....'
                script {
                    def customImage = docker.image("flyway/flyway:7.2.1").run( '-v $PWD/sql:/flyway/sql -v $PWD/conf:/flyway/conf -v $PWD/jars:/flyway/jars')
                    customImage.inside {
                            sh 'migrate'
                    }
                }
            }
        }
    }
}
