pipeline{
    options{
        skipDefaultCheckout()
        
        timeout(time: 10,unit: 'MINUTES')
    }
    agent none
    parameters{
        choice(name: 'ENV',choices: ['prod','dev','test'])
    }
    environment{
        APP_PORT = "${params.ENV == 'prod' ? '8000' : '7000'}"
        IMAGE_NAME = "srinivas06022001/jenkins-pipelines"
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
         stage('build jar'){
                    agent{
                        label 'node1'
                    }
                    options{
                        retry(2)
                    }
                    steps{
                        unstash 'source-code'
                        sh 'mvn clean package'
                        stash name: 'app-war',includes: 'target/*.war'
                    }
                }
        stage('parallel build jar and docker image'){
            failFast true
            parallel{
               
                stage('build image'){
                    agent{
                        label 'node2'
                    }
                    steps{
                           unstash 'source-code'
                            unstash 'app-war'
                        sh '''
                        docker rm -f $(docker ps -aq) || true
                        docker rmi -f $(docker images -aq) || true
                        docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                        '''
                        withCredentials([
                            usernamePassword(
                                credentialsId: 'docker',
                                usernameVariable: 'DOCKER_USER',
                                passwordVariable: 'DOCKER_PASS'
                            )
                        ])
                        {
                            sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                            '''
                        }
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
                docker run -d -p ${APP_PORT}:8080 --name=app ${IMAGE_NAME}:${BUILD_NUMBER}
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
                
                docker run -d -p ${APP_PORT}:8080 --name=app ${IMAGE_NAME}:${BUILD_NUMBER}
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















