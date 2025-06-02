pipeline {
    agent any

    environment {
        REPO_URL     = 'https://github.com/pavani84-hub/website.git'
        TEST_HOST    = '172.31.9.120'
        PROD_HOST    = '172.31.14.205'
        REMOTE_USER  = 'ubuntu'
        SSH_KEY_ID   = '72c3b26b-1bb4-4db7-ac51-330a491e8404'
        BRANCH_NAME  = 'develop'
    }

    triggers {
        githubPush()//pollSCM('* * * * *')  // Optional; use GitHub webhook for real-time
    }

    stages {
        stage('Checkout') {
            when {
                branch 'develop'
            }
            steps {
                git branch: "${BRANCH_NAME}", url: "${REPO_URL}"
                stash name: 'code'
            }
        }

        stage('Deploy to Test') {
            agent { label 'test' }
            steps {
                unstash 'code'
                sshagent (credentials: [env.SSH_KEY_ID]) {
                    sh '''
                        echo "Deploying to TEST server..."
                        ssh -o StrictHostKeyChecking=no $REMOTE_USER@$TEST_HOST "mkdir -p /home/ubuntu/jenkins"
                        scp -o StrictHostKeyChecking=no -r * $REMOTE_USER@$TEST_HOST:/home/ubuntu/jenkins
                    '''
                }
            }
        }

        stage('Deploy to Prod') {
            agent { label 'prod' }
            steps {
                unstash 'code'
                sshagent (credentials: [env.SSH_KEY_ID]) {
                    sh '''
                        echo "Deploying to PROD server..."
                        ssh -o StrictHostKeyChecking=no $REMOTE_USER@$PROD_HOST "mkdir -p /home/ubuntu/prod-deploy"
                        scp -o StrictHostKeyChecking=no -r * $REMOTE_USER@$PROD_HOST:/home/ubuntu/prod-deploy
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Full deployment pipeline completed successfully!"
        }
        failure {
            echo "❌ Deployment pipeline failed."
        }
    }
}
