pipeline {
    agent any
    environment {
        PATH = "${PATH};C:\\Users\\Anubhav\\Downloads\\sonar-scanner-cli-6.2.1.4610-windows-x64\\sonar-scanner-6.2.1.4610-windows-x64\\bin;C:\\Users\\Anubhav\\Downloads\\ZAP_WEEKLY_D-2024-12-02\\ZAP_D-2024-12-02"
        ZAP_HOME = 'C:\\Users\\Anubhav\\Downloads\\ZAP_WEEKLY_D-2024-12-02\\ZAP_D-2024-12-02'
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
        stage('ZAP Security Scan') {
            environment {
                ZAP_API_KEY = credentials('zap-api-key') // Inject the ZAP API key
            }
            steps {
                script {
                    // Start the ZAP scan using the API
                    bat """
                        curl -X GET "http://localhost:8085/UI/ascan/action/scan/?apikey=${ZAP_API_KEY}&url=https://real-legal-drake.ngrok-free.app/&maxChildren=10"
                    """
                }
            }
        }
        stage('Generate ZAP Report') {
            environment {
                ZAP_API_KEY = credentials('zap-api-key') // Inject the ZAP API key
            }
            steps {
                script {
                    bat """
                        curl -X GET "http://localhost:8085/HTML/reports/action/generate/?apikey=7l12l0d7sbanhuvou0qovhe32k&title=CobraFinalProjectReport&template=traditional-html&theme=&description=&contexts=&sites=https://real-legal-drake.ngrok-free.app/&sections=&includedConfidences=&includedRisks=&reportFileName=&reportFileNamePattern=&reportDir=&display="
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
