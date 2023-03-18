# devops-cert

Before running you have to:

1. Install on your local machine:
- jenkins (2.387.1)
- git (2.34.1)
- terraform (1.1.7)
- ansible (2.10.17)
2. Configure .tfvars files for yandex cloud accessing.
3. Add this repository to jenkins as jenkins-pipeline.
4. Jenkins pipeline requires to add docker credentials. You have to add 2 parameters:
- username - username from dockerhub
- password - password for your user
5. Use it!