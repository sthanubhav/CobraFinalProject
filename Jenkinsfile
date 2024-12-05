pipeline {
    agent any
    triggers {
        githubPush() // Triggers the pipeline on a GitHub push event
    }
    environment {
        SONAR_HOST_URL = 'http://192.168.37.143:9000'
        SONAR_AUTH_TOKEN = credentials('sonarqubetoken') // Uses your SonarQube token
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    // Cloning the repo and checking out the 'main' branch
                    git credentialsId: 'githubtoken', url: 'https://github.com/sthanubhav/CobraFinalProject.git', branch: 'main'
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    // Echo message to indicate the start of the build
                    echo 'Hello, this is a test build step!!'
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') { // Replace 'SonarQube' with your SonarQube configuration name in Jenkins
                    script {
                        sh """
                        sonar-scanner \
                        -Dsonar.projectKey=CobraFinalProject \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_AUTH_TOKEN
                        """
                    }
                }
            }
        }
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
