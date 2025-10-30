stage('Checkout K8S manifest SCM') {
    steps {
        git branch: 'main', url: 'https://github.com/vaseem-06/Hiring-app-argocd.git'
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
                    git commit -m "Updated deployment image tag to ${BUILD_NUMBER}" || echo "No changes to commit"
                    git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/vaseem-06/Hiring-app-argocd.git main
                '''
            }
        }
    }
}
