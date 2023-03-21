pipeline {

    agent any

    parameters {
        string(name: "username", description: "Username for docker hub")
        password(name: "password", description: "Password for docker hub")
    }

    stages {
        stage ('Preparing terraform') {
            steps {
               sh '''
                    cd terraform
                    cp .terraformrc ~/
                    terraform -version
               '''
            }
        }

        stage ('Creating instances') {
            steps {
                sh '''
                    cd terraform
                    terraform init
                    terraform plan -var-file=variables.tfvars
                    terraform apply -var-file=variables.tfvars --auto-approve
                    sleep 30
                    cd ../ansible
                    ansible-playbook common.yaml
                '''
            }
        }

        stage ('Building project') {
            steps {
                sh '''
                    cd ansible
                    set +x
                    echo "username=$username\npassword=$password\n" > docker.properties
                    set -x
                    ansible-playbook build.yaml
                '''
            }
        }

        stage ('Deploying project') {
            steps {
                sh '''
                    cd ansible
                    ansible-playbook deploy.yaml
                '''
            }
        }
    }
}