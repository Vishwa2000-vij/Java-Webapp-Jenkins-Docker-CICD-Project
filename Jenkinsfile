pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        skipDefaultCheckout(true)
    }

    environment {
        IMAGE_NAME = 'vishwanathv/java-webapp'
        DEPLOY_SCRIPT = '/var/lib/jenkins/project3-deploy.sh'
    }

    stages {
        stage('Verify Environment') {
            steps {
                sh '''
                    echo "Running as: $(whoami)"
                    echo "Jenkins server: $(hostname)"

                    java --version
                    mvn --version
                    docker --version
                    git --version
                '''
            }
        }

        stage('Checkout Source Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Verify WAR File') {
            steps {
                sh '''
                    test -f target/java-webapp.war
                    ls -lh target/java-webapp.war
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                        -t ${IMAGE_NAME}:${BUILD_NUMBER} \
                        -t ${IMAGE_NAME}:latest \
                        .
                '''
            }
        }

        stage('Docker Hub Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    sh '''
                        echo "$DOCKERHUB_TOKEN" |
                        docker login \
                            --username "$DOCKERHUB_USERNAME" \
                            --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                    docker push ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh '''
                    test -x ${DEPLOY_SCRIPT}
                    ${DEPLOY_SCRIPT}
                '''
            }
        }

        stage('Deployment Verification') {
            steps {
                echo "Successfully deployed ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }
    }

    post {
        success {
            echo "Pipeline SUCCESS: ${IMAGE_NAME}:${BUILD_NUMBER}"
        }

        failure {
            echo 'Pipeline FAILED. Check the failed stage in Console Output.'
        }

        always {
            sh 'docker logout || true'
            echo 'Project 3 CI/CD pipeline finished.'
        }
    }
}