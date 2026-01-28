pipeline{
    agent none
    parameters{
        choice(name: 'ENV',choices: ['prod','dev','test'])
    }
    environment{
        APP_PORT = "${params.ENV == 'prod' ? '8000' : '7000'}"
    }
    stages{
        stage('checkout'){
            agent{
                label 'node1'
            }
            steps{
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Bunny06022001/jenkins-practice',
                        credentialsId: 'git'
                    ]]
                ])
                 stash name: 'source-code',includes: '**/*'
            }
           
             
        }
        stage('parallel build jar and docker image'){
            parallel{
                stage('build jar'){
                    agent{
                        label 'node1'
                    }
                    steps{
                        unstash 'source-code'
                        sh 'mvn clean package'
                    }
                }
                stage('build image'){
                    agent{
                        label 'node2'
                    }
                    steps{
                        unstash 'source-code'
                        sh '''
                        mvn clean package
                        
                        docker rm -f $(docker ps -aq) || true
                        docker rmi -f $(docker images -aq) || true
                        docker build -t app:${BUILD_NUMBER} .
                        '''
                    }
                    
                }
            }
        }
        stage('prod deploy'){
            agent{
                label 'node2'
            }
              when{
                expression{
                    params.ENV == 'prod'
                }
            }
            steps{
                script{
                    input(
                        message: "are u sure to deploy",
                        ok: "deploy now",
                        submitter: "admin"
                    )
                }
                 sh '''
                docker run -d -p ${APP_PORT}:8080 --name=app-${BUILD_NUMBER} app:${BUILD_NUMBER}
                '''
                
            }
             post{
                always{
                    deleteDir()
                }
            }
            
        }
        stage('non-prod deploy'){
            agent{
                label 'node2'
            }
            when{
                expression{
                    params.ENV != 'prod'
                }
            }
            steps{
                sh '''
                
                docker run -d -p ${APP_PORT}:8080 --name=app app-${BUILD_NUMBER}
                '''
            }
            post{
                always{
                    deleteDir()
                }
            }
        }
    }
}















