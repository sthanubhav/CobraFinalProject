pipeline {
    agent any
    environment {
        PATH = "${PATH};C:\\Users\\Anubhav\\Downloads\\sonar-scanner-cli-6.2.1.4610-windows-x64\\sonar-scanner-6.2.1.4610-windows-x64\\bin;C:\\Users\\Anubhav\\Downloads\\ZAP_WEEKLY_D-2024-12-02\\ZAP_D-2024-12-02"
        ZAP_HOME = 'C:\\Users\\Anubhav\\Downloads\\ZAP_WEEKLY_D-2024-12-02\\ZAP_D-2024-12-02'
        ZAP_URL = 'http://localhost:8085'
        ZAP_API_KEY = credentials('zap-api-key') // Inject the ZAP API key
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
                        echo "SonarQube Analysis: Project Key: ${SONAR_PROJECT_KEY}"
                        echo "SonarQube URL: ${SONARQUBE_URL}"

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
        stage('Run ZAP Scan') {
            steps {
                script {
                    bat """
                        curl -X GET "${ZAP_URL}/JSON/ascan/action/scan/?url=https://real-legal-drake.ngrok-free.app/&apikey=${ZAP_API_KEY}"
                    """
                }
            }
        }
        stage('Generate ZAP Report') {
            steps {
                script {
                    bat """
                        curl -X GET "${ZAP_URL}/JSON/report/action/generate/?apikey=${ZAP_API_KEY}&formattype=json&reportFilePath=C:\\ProgramData\\Jenkins\\.jenkins\\workspace\\CobraFinalProject\\zap-report.json"
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
