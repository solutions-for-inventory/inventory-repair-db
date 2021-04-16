pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:$PATH"
    }
    stages {
        /*
        stage ('Create Data Base') {
                when {
                    expression {
                        DATABASE_CONTAINER = sh(returnStdout: true, script: 'docker ps -aqf ancestor=inventory-repair-db:1.0').trim()
                        return !DATABASE_CONTAINER
                    }
                }
                steps {
                    echo 'Creating Data Base'
                    sh '( docker logs -f ' + sh(returnStdout: true, script: 'docker run -d -it -p 5432:5432 inventory-repair-db:1.0').trim() + ' & ) | grep -m2 "ready to accept"'
                }
        }
        stage('Deploy Data Base') {
            steps {
                echo 'Deploying....'
                sh 'docker start $(docker ps -aqf ancestor=inventory-repair-db:1.0)'
                sh 'docker run --rm -v $PWD/sql:/flyway/sql -v $PWD/conf:/flyway/conf -v $PWD/jars:/flyway/jars flyway/flyway:7.2.1 migrate'
            }
        }
        */
        stage('DockerBuildImage') {
            steps {
                echo 'Starting to build docker image'
                script {
                    def customImage = docker.build("inventory-repair-db:1.0")
                }
            }
        }

        stage('push docker image') {
            steps {
                sh 'echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin'
                sh 'docker image tag inventory-repair-db:1.0 ghcr.io/solutions-for-inventory/inventory-repair-db:1.0'
                sh 'docker push ghcr.io/solutions-for-inventory/inventory-repair-db:1.0'
            }
        }
    }
}
