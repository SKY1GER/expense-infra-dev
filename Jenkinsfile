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
    parameters{
        choice(name: "action",  choices: ['apply', 'destroy'], description: "please select to apply or destroy")
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
            when{
                expression{
                    params.action == 'apply'
                }
            }
            steps{
                sh '''
                  cd 01-vpc
                  terraform plan
                '''
            }
            
        }
        stage("apply"){
            when{
                expression{
                    params.action == 'apply'
                }
            }
            input{
                message "should we continue"
                ok "Yes! we should."
            }
            steps{
                sh '''
                  cd 01-vpc
                  terraform apply --auto-approve
                '''
            }
        }
        stage("destroy"){
            when{
                expression{
                    params.action == 'destroy'
                }
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

