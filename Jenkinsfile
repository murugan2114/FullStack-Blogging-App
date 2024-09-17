@Library('pipeline_shared_library') _

pipeline { 
    agent any

    stages {
        stage('Git checkout') {
            steps {
                script {
                    gitCheckout(
                        branch: "main",
                        url: "https://github.com/murugan2114/FullStack-Blogging-App.git",
                        credentialsId: "git-creds"
                    )
                }
            }
        }

        stage('Code Compile') {
            steps {
                script {
                    codeCompile()
                }
            }
        }

        stage('Run Unit Test') {
            steps {
                script {
                    mvnTest()
                }
            }
        }

        stage('Run Integration Test') {
            steps {
                script {
                    mvnIntegrationTest()
                }
            }
        }
    }
}



