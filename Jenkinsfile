@Library('pipeline_shared_library') _

pipeline { 
    agent any

    parameters{
        
        choice(name: "action", choices: "create\ndelete", description: "choose create\ndelete" )
    }

    stages {
        stage('Git checkout') {
        when { expression {params.action == 'create'}}
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
        when { expression {params.action == 'create'}}
            steps {
                script {
                    codeCompile()
                }
            }
        }

        stage('Run Unit Test') {
        when { expression {params.action == 'create'}}
            steps {
                script {
                    mvnTest()
                }
            }
        }

        stage('Run Integration Test') {
            when { expression {params.action == 'create'}}
            steps {
                script {
                    mvnIntegrationTest()
                }
            }
        }
    }
}



