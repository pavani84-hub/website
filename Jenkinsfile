pipeline {
    agent any

    environment {
        IMAGE_NAME = "pavaniambica/webapp"
    }

    stages {
        stage('Job1: Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:${BUILD_NUMBER} .'
                sh 'docker push $IMAGE_NAME:${BUILD_NUMBER}'
            }
        }

        stage('Job2: Test') {
           steps {
                  echo 'Running container to verify HTML app is served...'
                  sh '''
                  docker rm -f test-webapp || true
                  docker run -d --name test-webapp -p 8080:80 pavaniambica/webapp:${BUILD_NUMBER}
                  sleep 5
                  curl -f http://localhost:8888/index.html
                  docker stop test-webapp && docker rm test-webapp
                  '''
            }
        }

        stage('Job3: Deploy to Prod') {
            when {
                branch 'master'
            }
            steps {
                sshagent(['9a13c549-b72f-411f-bc76-12176ead5b1f']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@43.204.211.166"
                    docker pull $IMAGE_NAME:${BUILD_NUMBER} &&
                    docker stop webapp || true &&
                    docker rm webapp || true &&
                    docker run -d -p 80:80 --name webapp $IMAGE_NAME:${BUILD_NUMBER}
                    "'''
                }
            }
        }
    }
}
