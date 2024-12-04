pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/username/repo-name.git', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                sh 'echo "Build step here"'
                // Replace with actual build commands, e.g., 'mvn clean install'
            }
        }
    }
}
