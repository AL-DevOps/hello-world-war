pipeline {
    agent {
       label "built-in"
    }
    tools {
        maven 'Maven3'
    }
    environment {
    DOCKERHUB_CREDENTIALS = credentials('DockerHub')
    }
    stages {
        stage('Checkout code') {
            steps {
                cleanWs()
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'GitHub-user-password', url: 'https://github.com/AL-DevOps/hello-world-war']]]) 
            }
        }
        stage('Build_test_package') {
            steps {
                sh 'mvn compile'
                sh 'mvn test'
                sh 'mvn package'
            }
        }
        stage('Publish artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.war', defaultExcludes: false, followSymlinks: false, onlyIfSuccessful: true
                
                slackSend channel: 'andreyl_devops', 
                color: 'good', 
                message: " *${currentBuild.currentResult}:* Job ${env.JOB_NAME}, build # ${env.BUILD_NUMBER} , build ID ${env.BUILD_ID} ", 
                teamDomain: 'devopsoctober-x1n6658', 
                tokenCredentialId: 'slack-token'
                
                slackUploadFile channel: 'andreyl_devops',
                credentialId: 'slack-token',
                filePath: 'target/*.war',
                initialComment: 'Results'
            }
        }
        stage('Build Docker image') {
            steps {  
                sh 'docker build -t aldevops1/hello-world:$BUILD_NUMBER .'
            }
        }
        stage('Login to Dockerhub') {
            steps{
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push Docker image') {
            steps{
                sh 'docker push aldevops1/hello-world:$BUILD_NUMBER'
            }
        }
        stage('Update deployment.yaml') {
            steps {
                sh """
                    sed -i "s%{{GGG}}%${BUILD_NUMBER}%g" deployment.yaml
                """
            }
        }


        stage('Update GITHUB2') {
            steps {
                sh "cat deployment.yaml"
                sh "git clone https://github.com/AL-DevOps/andrey-final-project-terraform-ansible-EKS.git"
                dir('/var/lib/jenkins/workspace/Final-Project-Hello-World-Push-DockerHub/andrey-final-project-terraform-ansible-EKS') {
                    checkout([$class: 'GitSCM', branches: [[name: '*/dev']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/AL-DevOps/andrey-final-project-terraform-ansible-EKS.git']]])
                    sh "cp -r  /var/lib/jenkins/workspace/Final-Project-Hello-World-Push-DockerHub/deployment.yaml /var/lib/jenkins/workspace/Final-Project-Hello-World-Push-DockerHub/andrey-final-project-terraform-ansible-EKS/deployment.yaml"
                    sh "cat /var/lib/jenkins/workspace/Final-Project-Hello-World-Push-DockerHub/andrey-final-project-terraform-ansible-EKS/deployment.yaml"               
                    sh "git add ."
                    sh "git commit -m ' Build deployment #: ${BUILD_NUMBER}'"
                    sh "git push https://AL-DevOps:$GitHubPassword@github.com/AL-DevOps/andrey-final-project-terraform-ansible-EKS.git HEAD:dev"
            
                }      
            }
        }
        
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}
