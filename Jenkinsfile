pipeline {
    agent any

    environment {
        AWS_CREDENTIALS_ID = 'aws-credentials-id' // Replace with your Jenkins AWS credentials ID
        // TERRAFORM_VERSION = '1.1.0' // Specify your required Terraform version
        S3_BUCKET = 'labexercise1' // Replace with your S3 bucket for Terraform state
        // DYNAMODB_TABLE = 'your-terraform-lock-table' // Replace with your DynamoDB table for state locking
        TF_WORKSPACE = 'default'
    }

    stages {
        // stage('Checkout') {
        //     steps {
        //         git branch: 'main', url: 'https://your-git-repo-url.git'
        //     }
        // }

        stage('Terraform Init') {
            steps {
                script {
                    withAWS(credentials: "${AWS_CREDENTIALS_ID}") {
                        sh """
                        terraform init \
                            -backend-config="bucket=${S3_BUCKET}" \
                            -backend-config="key=terraform/${TF_WORKSPACE}/terraform.tfstate"
                        """
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    withAWS(credentials: "${AWS_CREDENTIALS_ID}") {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Approve Terraform Apply?', ok: 'Apply'
                script {
                    withAWS(credentials: "${AWS_CREDENTIALS_ID}") {
                        sh 'terraform apply tfplan'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
