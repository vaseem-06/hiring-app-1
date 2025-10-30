pipeline {
    agent any

    environment {
        IMAGE_NAME = "vaseem06/hiring-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout App Code') {
            steps {
                git branch: 'main', url: 'https://github.com/vaseem-06/hiring-app-1.git'
            }
        }

        stage('Build WAR using Maven') {
            steps {
                sh '''
                    mvn clean package
                    echo "===== Target Directory Contents ====="
                    ls -l target/
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Push') {
            steps {
                // ✅ Use username/password credentials for Docker Hub login
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Checkout K8S manifest SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/betawins/Hiring-app-argocd.git'
            }
        }

        stage('Update K8S manifest & push to Repo') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                            # ✅ Update image tag in K8s deployment manifest
                            sed -i "s/[0-9]\\+/${BUILD_NUMBER}/g" dev/deployment.yaml

                            # ✅ Configure Git
                            git config --global user.email "vaseem06@gmail.com"
                            git config --global user.name "vaseem06"

                            # ✅ Commit and push changes
                            git add dev/deployment.yaml
                            git commit -m "Updated deployment image tag to ${BUILD_NUMBER}"
                            git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/betawins/Hiring-app-argocd.git main
                        '''
                    }
                }
            }
        }
    }
}
