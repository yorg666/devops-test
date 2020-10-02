pipeline {
    environment { 
	registry = "yorgdockers/buildit"
	registryCredential = 'dockerhub'
	dockerImage = ''
    }
  agent {
    kubernetes {
      // this label will be the prefix of the generated pod's name
      label 'jenkins-agent-my-app'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    component: ci
spec:
  containers:
    - name: docker
      image: docker
      command:
        - cat
      tty: true
      volumeMounts:
        - mountPath: /var/run/docker.sock
          name: docker-sock
    - name: kubectl
      image: lachlanevenson/k8s-kubectl:v1.19.2 # use a version that matches your K8s version
      command:
        - cat
      tty: true
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
"""
    }
  }

  stages {
    stage('Build image') {
      steps {
        container('docker') {
	script {
		dockerImage = docker.build registry + ":$BUILD_NUMBER"
		}
        }
      }
      }

    stage('Push image') {
      steps {
        container('docker') {
	script {
		docker.withRegistry( '', registryCredential ) {
		dockerImage.push()
		}
        }
      }
      }
     }

    stage('Deploy') {
      steps {
        withCredentials([kubeconfigContent(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_CONTENT')]){
        container('kubectl') {
          sh ''' mkdir ~/.kube && echo "$KUBECONFIG_CONTENT" > ~/.kube/config && kubectl get pods '''
        }
      }
    }
    }
  }
}
