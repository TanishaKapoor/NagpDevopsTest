pipeline{
    agent any

    options{
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr:'30'))
    }

    environment{
        Nuget_Url= 'https://api.nuget.org/v3/index.json'
        SonarQube_Project_Key='sqs:k-tanishakapoor-develop'
         SonarQube_Project_Name='sqs:project-tanishakapoor-develop'
          SonarQube_Version ='1.0.0'
          scannerHome = tool name :'sonar_scanner_dotnet',type:'hudson.plugins.sonar.MsBuildSQRunnerInstallation'
    }
    stages{
        stage('nuget store'){
            steps{
                echo 'I am in develop branch'
                bat 'dotnet clean'
                bat 'dotnet restore'
            }
        }
        stage('start sonarqube analysis'){
            steps{
                withSonarQubeEnv('Test_Sonar'){
                    bat "dotnet \"${scannerHome}/SonarScanner.MsBuild.dll\" begin /k:${env.SonarQube_Project_Key} /n:${env.SonarQube_Project_Name} /v:${env.SonarQube_Version}"
                }
            }
        }
        stage('build code'){
            steps{
                bat 'dotnet build -c release -o app/build --no-restore'
            }
        }

        stage('stop sonarQube analysis'){
            steps{
                withSonarQubeEnv('Test_Sonar'){
                    bat "dotnet \"${scannerHome}/SonarScanner.MsBuild.dll\" end"
                }
            }
        }
        stage('release artifacte'){
            steps{
                bat "dotnet publish -c release -o app/release --no-restore"
            }
        }

        stage('docker image'){
            steps{
                bat "docker build -t i-tanisha-develop ."
            }
        }
        stage('stop running container'){
            steps{
                script{
                    containerID = powershell(returnStdout:true,script:'docker ps -af name=^"c-tanishakapoor-develop" --format "{{.ID}}"')
                    if(containerID){
                        bat "docker stop ${containerID}"
                        bat "dockr rm -f ${containerID}"
                    }
                }
            }
        }
        stage('docker deployment'){
            steps{
                bat "docker run -d -p 8080:80 --name c-tanishakapoor-develop i-tanishakapoor-develop"
            }
        }
    }
}