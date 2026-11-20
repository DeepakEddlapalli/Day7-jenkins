
pipeline {

    agent any

    tools {
        maven 'Maven3'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building Maven application'

                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                echo 'Running JUnit test cases'

                sh 'mvn test'
            }

            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Archive Artifact') {
            steps {
                echo 'Archiving generated JAR'

                archiveArtifacts artifacts: 'target/*.jar',
                                 fingerprint: true
            }
        }

    }

    post {

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the console output.'
        }

        always {
            echo 'Pipeline execution finished.'
        }

    }

}

