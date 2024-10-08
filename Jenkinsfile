@Library('pipeline_shared_library') _

pipeline {
    agent any

    parameters {
        choice(name: 'action', choices: ['create', 'delete'], description: 'Choose create/Destroy')
        string(name: 'aws_account_id', description: 'AWS Account ID', defaultValue: '009160043436')
        string(name: 'Region', description: 'Region of ECR', defaultValue: 'us-east-1')
        string(name: 'ECR_REPO_NAME', description: 'Name of the ECR', defaultValue: 'fullstack-app')
        string(name: 'cluster', description: 'Name of the EKS Cluster', defaultValue: 'demo-cluster')
    }

    environment {
        ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        SECRET_KEY = credentials('AWS_SECRET_KEY_ID')
    }

    stages {
        stage('Git Checkout') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    gitCheckout(
                        branch: 'main',
                        url: 'https://github.com/murugan2114/FullStack-Blogging-App.git',
                        credentialsId: 'git-creds'
                    )
                }
            }
        }

        stage('Code Compile') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    codeCompile() // Assuming this is a custom function in your shared library
                }
            }
        }

        stage('Run Unit Test') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    mvnTest() // Assuming this runs Maven tests defined in the shared library
                }
            }
        }

        stage('Run Integration Test') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    mvnIntegrationTest() // Assuming this runs Maven integration tests defined in the shared library
                }
            }
        }

        stage('Static Code Analysis') {
            when { expression { params.action == 'create' } }
            steps {
                script {
                    withSonarQubeEnv('sonar-server') {
                        def sonarQubeCredentialsId = 'sonarqube-api'
                        staticCodeAnalysis(sonarQubeCredentialsId)
                    }
                }
            }
        }

        stage('Quality Gate Status Check : Sonarqube') {
            when { expression {  params.action == 'create' } }
            steps {
                script {
                    def SonarQubecredentialsId = 'sonarqube-api'
                    qualityGateStatus(SonarQubecredentialsId)
                }
            }
        }

        stage('Maven Build : maven') {
            when { expression {  params.action == 'create' } }
            steps {
                script {
                    mvnBuild()
                }
            }
        }

        stage('Docker Image Build') {
            when { expression {  params.action == 'create' } }
            steps {
                script {
                    dockerBuild("${params.aws_account_id}", "${params.Region}", "${params.ECR_REPO_NAME}")
                }
            }
        }

        stage('Docker Image Scan: trivy ') {
            when { expression {  params.action == 'create' } }
            steps {
                script {
                    dockerImageScan("${params.aws_account_id}", "${params.Region}", "${params.ECR_REPO_NAME}")
                }
            }
        }

        stage('Docker Image Push : ECR ') {
            when { expression {  params.action == 'create' } }
            steps {
                script {
                    dockerImagePush("${params.aws_account_id}", "${params.Region}", "${params.ECR_REPO_NAME}")
                }
            }
        }

        stage('Create EKS Cluster : Terraform') {
            when { expression {  params.action == 'create' } }
            steps {
                script {
                    dir('eks_module') {
                        sh """

                          terraform init
                          terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=${params.Region}' --var-file=./config/terraform.tfvars
                          terraform destroy -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'region=${params.Region}' --var-file=./config/terraform.tfvars --auto-approve
                      """
                    }
                }
            }
        }

        stage('Connect to EKS ') {
            when { expression {  params.action == 'create' } }
            steps {
                script {
                    sh """
                aws configure set aws_access_key_id "$ACCESS_KEY"
                aws configure set aws_secret_access_key "$SECRET_KEY"
                aws configure set region "${params.Region}"
                aws eks --region ${params.Region} update-kubeconfig --name ${params.cluster}
                """
                }
            }
        }

        stage('Deployment on EKS Cluster') {
            when { expression {  params.action == 'create' } }
            steps {
                script {
                    def apply = false

                    try {
                        input message: 'please confirm to deploy on eks', ok: 'Ready to apply the config ?'
                        apply = true
                  }catch (err) {
                        apply = false
                        currentBuild.result  = 'UNSTABLE'
                    }
                    if (apply) {
                        sh '''
                      kubectl apply -f .
                    '''
                    }
                }
            }
        }
    }
}
