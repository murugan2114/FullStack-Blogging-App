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
    }
}


