pipeline{
    agent{
        label "Agent-1"
    }
    options{        
        // Timeout counter starts before agent is allocated
        timeout(time: 10, unit: "MINUTES")
        disableConcurrentBuilds()
    }

    stages{
        stage("init"){
            steps{
                sh  '''
                ls -d */
                '''
            }
            
        }
        stage("plan"){
            steps{
                sh "echo this is bulid"
            }
            
        }
        stage("apply"){
            steps{
                sh "echo this is deploy"
                sh "echo test the webhook trigger"
            }
        }

        }
    post{
        always{
            echo "this will run always"
        }
        success{
            echo "this will run only if build success"
        }
        failure{
            echo "this will run only if build fails"
        }
    }
    }

