pipeline{
    agent none
    stages{
        stage('checkout & build'){
            agent{
                label 'linux-agent'
            }
            steps{
                checkout scm
                    echo "iam in build step"
                    echo "succesful pulled code"
                    sh '''
                        echo "in agent"
                        mvn clean package
                    '''
                    stash name: 'jar',includes: 'target/*.jar'
            }
        }
        stage('image building'){
            agent{
                label 'node2'
            }
            steps{
                echo "in agent2 node"
                checkout scm
                    unstash 'jar'
                    sh '''
                        docker build -t ubuntu-jar:v1 .
                    '''
            }
        }
    }
}
