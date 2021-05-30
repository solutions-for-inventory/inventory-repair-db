#!/usr/bin/env groovy

pipeline {
    agent any
    parameters {
        choice(
                name: 'env',
                choices: ['--one--'], description: 'some input'
        )
        text(name: 'db_host', defaultValue: '192.168.0.100', description: 'Enter some information about the person')
        text(name: 'db_user', defaultValue: 'inventory_user', description: 'db user')
        password(name: 'db_password', defaultValueAsSecret: 'inventory_password', description: 'Enter a password')
    }

    stages {
        stage('Run DB patch') {
            steps {
                sh 'echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin'
                sh 'docker pull ghcr.io/solutions-for-inventory/inventory-repair-db:1.0'
            }

            steps {
                echo 'Deploying....'
                sh "docker run --rm -v FLYWAY_URL:jdbc:postgresql://${params.db_host}:5432/inventory_repair_db -v FLYWAY_USER:${params.db_user} -v FLYWAY_PASSWORD:${params.db_password} ghcr.io/solutions-for-inventory/inventory-repair-db:1.0 migrate"
            }
        }
    }
}