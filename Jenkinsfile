pipeline {
    agent any
    environment {
        SONAR_HOST_URL = 'http://192.168.37.143:9000'
        SONAR_AUTH_TOKEN = credentials('sonarqubetoken') // Replace with your SonarQube token's credentials ID
    }
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'githubtoken', url: 'https://github.com/sthanubhav/CobraFinalProject.git', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                echo 'Building the project...'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqubeserver') {
                    bat """
                    sonar-scanner.bat ^
                    -Dsonar.projectKey=CobraFinalProject ^
                    -Dsonar.sources=. ^
                    -Dsonar.host.url=%SONAR_HOST_URL% ^
                    -Dsonar.login=%SONAR_AUTH_TOKEN%
                    """
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
