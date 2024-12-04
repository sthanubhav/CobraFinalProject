pipeline {
    agent any
    triggers {
        githubPush() // This enables Jenkins to respond to GitHub webhooks
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    // Cloning the repo and checking out the 'main' branch
                    git url: 'https://github.com/sthanubhav/CobraFinalProject.git', branch: 'main'
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    // Replace with your build commands
                    sh 'echo "Build step here"'
                }
            }
        }
    }
}
