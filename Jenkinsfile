pipeline{
  agent none 
  stages{
    stage('checkout & build'){ 
      agent{ label 'code1' }
      steps{
        checkout scm
            echo "iam in build step" 
        echo "succesful pulled code"
        sh '''
           echo "in agent"
            mvn clean package 
        '''
        stash name: 'war-app',includes: 'target/*.war' 
      } }
    stage('image building'){
      agent{ label 'node2'
           } steps{ echo "in agent2 node"
                   checkout scm
                   unstash 'war-app'
                   sh '''
                   docker build -t tomcat-war:v1 .
                   docker run --name=webapp1 -p 8000:8080 -d tomcat-war:v1 ''' } } } }
