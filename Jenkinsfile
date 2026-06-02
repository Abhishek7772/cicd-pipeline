// Jenkinsfile — CI/CD Pipeline Definition
// Author: Abhishek Parmar
// Project: Cloud-Based Automated CI/CD Pipeline

pipeline {
    agent any

    environment {
        ECR_REGISTRY = '123456789.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPO     = 'my-app'
        IMAGE_TAG    = "${GIT_COMMIT[0..6]}"
        AWS_REGION   = 'ap-south-1'
    }

    stages {

        stage('Source Checkout') {
            steps {
                echo '[checkout] Cloning repository from GitHub...'
                checkout scm
                echo "[checkout] Branch: ${env.GIT_BRANCH}, Commit: ${IMAGE_TAG}"
            }
        }

        stage('Install Dependencies') {
            steps {
                echo '[install] Running: npm ci'
                sh 'npm ci'
                echo '[install] Dependencies installed successfully'
            }
        }

        stage('Lint & Static Analysis') {
            steps {
                echo '[lint] Running ESLint...'
                sh 'npm run lint'
                echo '[lint] No lint errors found'
            }
        }

        stage('Unit Tests') {
            steps {
                echo '[test] Running Jest test suite...'
                sh 'npm test -- --coverage'
                echo '[test] All tests passed'
            }
            post {
                always {
                    junit 'test-results/*.xml'
                }
            }
        }

        stage('Docker Build') {
            steps {
                echo "[docker] Building image: ${ECR_REPO}:${IMAGE_TAG}"
                sh "docker build -t ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} ."
                echo '[docker] Image built successfully'
            }
        }

        stage('Push to ECR') {
            steps {
                echo '[push] Authenticating with AWS ECR...'
                sh """
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REGISTRY}
                """
                echo "[push] Pushing ${ECR_REPO}:${IMAGE_TAG} to ECR..."
                sh "docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}"
                echo '[push] Image pushed successfully'
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo '[deploy] Starting deployment to EC2 instances...'
                sh "bash ./deploy.sh ${IMAGE_TAG}"
                echo '[deploy] Deployment completed'
            }
        }

        stage('Health Check') {
            steps {
                echo '[health] Running health check...'
                sh 'bash ./health-check.sh'
                echo '[health] All health checks passed'
            }
        }
    }

    post {
        success {
            echo "SUCCESS: Build ${BUILD_NUMBER} deployed successfully"
            mail to: 'abhishek.parmar@example.com',
                 subject: "Pipeline SUCCESS - Build #${BUILD_NUMBER}",
                 body: "Build ${IMAGE_TAG} deployed successfully in ${currentBuild.durationString}"
        }
        failure {
            echo "FAILURE: Build ${BUILD_NUMBER} failed — initiating rollback"
            sh 'bash ./rollback.sh'
            mail to: 'abhishek.parmar@example.com',
                 subject: "Pipeline FAILED - Build #${BUILD_NUMBER}",
                 body: "Build ${IMAGE_TAG} failed. Rollback initiated automatically."
        }
    }
}
