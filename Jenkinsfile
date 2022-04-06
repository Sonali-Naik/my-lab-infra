pipeline {
    agent any

    stages {
        stage('Cloning from GitHub') {
            steps {
                echo 'Cloning the repository my-build-infra'
                git branch:'main', url:'https://github.com/Sonali-Naik/my-lab-infra.git'
            }
        }

        stage('Provision the terraform infrastructure') {
            steps {
                echo 'Init the terraform to Download and Apply terraform with auto approve option'
                sh '''
                cd terraform
                terraform init
                terraform validate
                terraform fmt
                echo "its time to apply the code"
                terraform apply -auto-approve
                '''
            }
        }
    }
}