pipeline {
    agent any
    environment {
        PATH = "${PATH};C:\\Users\\Anubhav\\Downloads\\sonar-scanner-cli-6.2.1.4610-windows-x64\\sonar-scanner-6.2.1.4610-windows-x64\\bin"
    }
    triggers {
        githubPush() // Triggers the pipeline on a GitHub push event
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    git credentialsId: 'githubtoken', url: 'https://github.com/sthanubhav/CobraFinalProject.git', branch: 'main'
                }
            }
        }
        stage('SonarQube Analysis') {
            environment {
                SONARQUBE_URL = 'http://192.168.37.143:9000'
                SONAR_PROJECT_KEY = 'CobraFinalProject'
                SONAR_AUTH_TOKEN = credentials('jenkins-sonar') // Inject the SonarQube token
            }
            steps {
                withSonarQubeEnv('sonarqubeserver') {
                    script {
                        bat """
                            sonar-scanner.bat ^ 
                            -Dsonar.projectKey=${SONAR_PROJECT_KEY} ^ 
                            -Dsonar.sources=. ^ 
                            -Dsonar.host.url=${SONARQUBE_URL} ^ 
                            -Dsonar.login=${SONAR_AUTH_TOKEN}
                        """
                    }
                }
            }
        }
        stage('ZAP Security Scan') {
            steps {
                script {
                    bat """
                        curl -X POST "http://localhost:8085/JSON/ascan/action/scan?url=http://localhost:8080&recurse=true&insect=true" ^
                        -H "Content-Type: application/json"
                    """
                }
            }
        }
        stage('Generate ZAP Report') {
            steps {
                script {
                    bat """
                        curl -X GET "http://localhost:8085/JSON/report/action/generate?formMethod=GET&reportType=JSON&source=http://localhost:8080" ^
                        -H "Accept: application/json" ^
                        -o zap-report.json
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
