pipeline {
    agent any
    triggers {
        githubPush() // Triggers the pipeline on a GitHub push event
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
                    echo 'Hello, this is a test build step!'
                    // Add build commands below as needed
                    sh 'echo "Build step executed successfully"'
                }
            }
        }
    }
}
