pipeline {
    agent any

    tools {
        maven 'Maven_3_8_4'
    }

    environment {
        DOCKER_IMAGE = "asg"
    }

    stages {

        stage('Compile and Run Sonar Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh '''
                    mvn clean verify sonar:sonar \
                    -Dsonar.projectKey=webappdevsecproject \
                    -Dsonar.organization=webappdevsecproject \
                    -Dsonar.host.url=https://sonarcloud.io \
                    -Dsonar.token=$SONAR_TOKEN
                    '''
                }
            }
        }

        stage('Run SCA Analysis Using Snyk') {
            steps {
                withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
                    sh '''
                    snyk auth $SNYK_TOKEN
                    mvn snyk:test
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push Docker Image to AWS ECR') {
            steps {
                script {
                    docker.withRegistry(
                        'https://891377015455.dkr.ecr.ap-southeast-2.amazonaws.com',
                        'ecr:ap-southeast-2:aws-credentials'
                    ) {
                        app.push("latest")
                    }
                }
            }
        }
    }
}
