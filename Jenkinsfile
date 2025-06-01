pipeline{
    agent{
        label "Agent-1"
    }
    options{        
        // Timeout counter starts before agent is allocated
        timeout(time: 30, unit: "MINUTES")
        disableConcurrentBuilds()
        ansiColor('xterm')
    }

    stages{
        stage("init"){
            steps{
                sh  '''
                   cd 01-vpc
                   terraform init -reconfigure
                '''
            }
            
        }
        stage("plan"){
            steps{
                sh '''
                  cd 01-vpc
                '''
            }
            
        }
        stage("apply"){
            input{
                message "should we continue"
                ok "Yes! we should."
            }
            steps{
                sh '''
                  cd 01-vpc
                  terraform destroy --auto-approve
                '''
            }
        }

        }
    post{
        always{
            echo "this will run always"
            deleteDir()
        }
        success{
            echo "this will run only if build success"
        }
        failure{
            echo "this will run only if build fails"
        }
    }
    }

