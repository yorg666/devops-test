pipeline {

  agent {
  kubernetes {
    cloud 'kubernetes'
    inheritFrom 'jenkins-slave'
    namespace 'jenkins'
  }
}
  stages {

    stage('Checkout Source') {
      steps {
        git url:'https://github.com/yorg666/devops-test.git', branch:'master'
      }
    }
    
      stage("Build image") {
            steps {
                script {
                    myapp = docker.build("yorgdockers/buildit:${env.BUILD_ID}")
                }
            }
        }
    
      stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                            myapp.push("latest")
                            myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }

    
    stage('Deploy App') {
      steps {
        script {
          kubernetesDeploy(configs: "k8s/jenkins_deployment.yml", kubeconfigId: "buildit")
        }
      }
    }

  }

}
