pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:$PATH"
    }
    stages {
        stage ('Create Data Base') {
                when {
                    expression {
                        DATABASE_CONTAINER = sh(returnStdout: true, script: 'docker ps -aqf ancestor=inventory-repair-db:1.0').trim()
                        return !DATABASE_CONTAINER
                    }
                }
                steps {
                    echo 'Creating Data Base'
                    databaseContainerId = sh(returnStdout: true, script: 'docker run -d -it -p 5432:5432 inventory-repair-db:1.0').trim()
                    sh '( docker logs -f ' + databaseContainerId +' | grep -m2 "ready to accept"'
                }
        }
        stage('Deploy Data Base') {
            steps {
                echo 'Deploying....'
                sh 'docker start $(docker ps -aqf ancestor=inventory-repair-db:1.0)'
                sh 'docker run --rm -v $PWD/sql:/flyway/sql -v $PWD/conf:/flyway/conf -v $PWD/jars:/flyway/jars flyway/flyway:7.2.1 migrate'
            }
        }
    }
}
