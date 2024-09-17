pipeline { 
    agent any

    stages {
        
        stage('Git checkout') {
            steps {
              script{
                git branch: 'main', credentialsId: 'git-creds', url: 'https://github.com/murugan2114/FullStack-Blogging-App.git
              }
            
            }
        }
        
    }
}
