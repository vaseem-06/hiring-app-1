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
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub', variable: 'hubPwd')]) {
                    sh """
                    echo ${hubPwd} | docker login -u vaseem06 --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
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
                        sed -i "s/[0-9]\\+/${BUILD_NUMBER}/g" dev/deployment.yaml
                        git config --global user.email "vaseem06@gmail.com"
                        git config --global user.name "vaseem06"
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
