#!/usr/bin/env groovy

pipeline {
    agent any
    parameters {
        string(name: 'DB_HOST', defaultValue: '192.168.0.100', description: 'db host')
        string(name: 'DB_USER', defaultValue: 'inventory_user', description: 'db user')
        string(name: 'DB_PASSWORD', defaultValue: 'inventory_password', description: 'db password')
    }
    stages {
        stage('Example') {
            steps {
                sh 'echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin'
                sh 'docker pull ghcr.io/solutions-for-inventory/inventory-repair-db:1.0'
                sh "docker run --rm -e FLYWAY_URL=jdbc:postgresql://${params.DB_HOST}:5432/inventory_repair_db -e FLYWAY_USER=${params.DB_USER} -e FLYWAY_PASSWORD=${params.DB_PASSWORD} ghcr.io/solutions-for-inventory/inventory-repair-db:1.0 migrate"
            }
        }
    }
}