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
                    docker.image("flyway/flyway")
                    .run( '-v $PWD/sql:/flyway/sql '
                        + '-v $PWD/conf:/flyway/conf '
                        + '-v $PWD/jars:/flyway/jars '
                        + 'migrate --rm'
                    )
                }
            }
        }
    }
}
