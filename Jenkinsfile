pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        timestamps()
    }

    environment {
        IMAGE_REPO    = 'vishwanathv/java-webapp'
        APP_SERVER_IP = '172.31.11.116'
        CONTAINER_NAME = 'java-webapp'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn -B clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                      -t "$IMAGE_REPO:$BUILD_NUMBER" \
                      -t "$IMAGE_REPO:latest" .
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_TOKEN'
                    )
                ]) {
                    sh '''
                        set +x

                        echo "$DOCKER_TOKEN" |
                        docker login \
                          --username "$DOCKER_USER" \
                          --password-stdin

                        docker push "$IMAGE_REPO:$BUILD_NUMBER"
                        docker push "$IMAGE_REPO:latest"

                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to App Server') {
            steps {
                sshagent(credentials: ['app-server-ssh']) {
                    sh '''
                        ssh ubuntu@"$APP_SERVER_IP" "
                            docker pull $IMAGE_REPO:$BUILD_NUMBER

                            docker rm -f $CONTAINER_NAME || true

                            docker run -d \
                              --name $CONTAINER_NAME \
                              --restart unless-stopped \
                              -p 8080:8080 \
                              $IMAGE_REPO:$BUILD_NUMBER
                        "
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sshagent(credentials: ['app-server-ssh']) {
                    sh '''
                        ssh ubuntu@"$APP_SERVER_IP" '
                            for attempt in $(seq 1 12)
                            do
                                if curl -fsS http://localhost:8080 |
                                   grep -q "Java DevOps CI/CD Project"
                                then
                                    echo "Application verification successful"
                                    exit 0
                                fi

                                echo "Waiting for Tomcat to start..."
                                sleep 5
                            done

                            echo "Application verification failed"
                            docker logs --tail 50 java-webapp
                            exit 1
                        '
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully."
        }

        failure {
            echo "Pipeline failed. Check the failed stage logs."
        }

        always {
            cleanWs()
        }
    }
}
