@Library('pipeline_shared_library') _

pipeline {
    agent any

    parameters {
        choice(name: 'action', choices: 'create\ndelete', description: 'Choose create/Destroy')
        string(name: 'aws_account_id', description: ' AWS Account ID', defaultValue: '009160043436')
        string(name: 'Region', description: 'Region of ECR', defaultValue: 'us-east-1')
        string(name: 'ECR_REPO_NAME', description: 'name of the ECR', defaultValue: 'fullstack-app')
        string(name: 'cluster', description: 'name of the EKS Cluster', defaultValue: 'demo-cluster1')
    }

    stages {
        stage('Git checkout') {
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
    }
}
