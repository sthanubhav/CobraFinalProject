pipeline {
    agent any
    environment {
        // Add paths for SonarQube Scanner to the system PATH
        PATH = "${PATH};C:\\Users\\Anubhav\\Downloads\\sonar-scanner-cli-6.2.1.4610-windows-x64\\sonar-scanner-6.2.1.4610-windows-x64\\bin"
        ZAP_URL = 'http://localhost:8085'  // URL for the ZAP server
    }
    triggers {
        // Trigger the pipeline on a GitHub push event
        githubPush()
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the code from the specified GitHub repository
                    git credentialsId: 'githubtoken', url: 'https://github.com/sthanubhav/CobraFinalProject.git', branch: 'main'
                }
            }
        }
        stage('SonarQube Analysis') {
            environment {
                SONARQUBE_URL = 'http://192.168.37.143:9000'  // SonarQube server URL
                SONAR_PROJECT_KEY = 'CobraFinalProject'  // Unique key for the project in SonarQube
                SONAR_AUTH_TOKEN = credentials('jenkins-sonar')  // Inject SonarQube token securely
            }
            steps {
                // Run the SonarQube scanner with the configured environment
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
        stage('OWASP ZAP Security Scan') {
            steps {
                script {
                    // Run ZAP scan using the ZAP API on the specified URL
                    bat """
                        curl -X POST ${ZAP_URL}/JSON/ascan/action/scan?url=http://localhost:8080&recurse=true&insect=true
                    """
                    // Wait for ZAP scan to complete (adjust wait time as needed)
                    sleep(time: 30, unit: 'SECONDS')

                    // Generate a report after the scan
                    bat """
                        curl -X GET ${ZAP_URL}/JSON/report/action/generate?formMethod=GET&reportType=JSON&source=http://localhost:8080 > zap-report.json
                    """
                }
            }
        }
        stage('Quality Gate') {
            steps {
                // Wait for the SonarQube quality gate result and abort the pipeline if it fails
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
