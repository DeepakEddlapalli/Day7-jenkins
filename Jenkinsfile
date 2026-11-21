
pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building Maven project'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests'
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
                echo 'Archiving JAR artifact'

                archiveArtifacts artifacts: 'target/*.jar',
                                 fingerprint: true
            }
        }

        stage('Deploy to Nexus') {
            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'nexus-creds',
                    usernameVariable: 'NEXUS_USER',
                    passwordVariable: 'NEXUS_PASS'
                )]) {

                    sh '''
                        set -e

                        NEXUS_URL="http://172.31.33.127:8081/repository/maven-releases"

                        JAR_FILE="target/jenkins-day7-1.0.0.jar"
                        POM_FILE="pom.xml"

                        echo "Uploading JAR to Nexus..."

                        curl --fail --silent --show-error \
                            --user "$NEXUS_USER:$NEXUS_PASS" \
                            --upload-file "$JAR_FILE" \
                            "$NEXUS_URL/com/example/jenkins-day7/1.0/jenkins-day7-1.0.jar"

                        echo "Uploading POM to Nexus..."

                        curl --fail --silent --show-error \
                            --user "$NEXUS_USER:$NEXUS_PASS" \
                            --upload-file "$POM_FILE" \
                            "$NEXUS_URL/com/example/jenkins-day7/1.0/jenkins-day7-1.0.pom"

                        echo "Artifact successfully uploaded to Nexus."
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check console output.'
        }

        always {
            echo 'Pipeline execution completed.'
        }
    }
}

