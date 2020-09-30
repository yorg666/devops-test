pipeline {
  agent {
    kubernetes {
      label 'buildit'
      defaultContainer 'jnlp'
      yaml """

apiVersion: "v1"
kind: "Pod"
metadata:
  labels:
    jenkins/buildit-jenkins-jenkins-slave: "true"
    jenkins/label: "buildit-jenkins-jenkins-slavex"
  name: "default-s7m1k"
spec:
  containers:
  - args:
    - "********"
    - "default-s7m1k"
    env:
    - name: "JENKINS_SECRET"
      value: "********"
    - name: "JENKINS_TUNNEL"
      value: "buildit-jenkins-agent:50000"
    - name: "JENKINS_AGENT_NAME"
      value: "default-s7m1k"
    - name: "JENKINS_NAME"
      value: "default-s7m1k"
    - name: "JENKINS_AGENT_WORKDIR"
      value: "/home/jenkins"
    - name: "JENKINS_URL"
      value: "http://buildit-jenkins.default.svc.cluster.local:8080"
    image: "jenkins/inbound-agent:4.3-4"
    imagePullPolicy: "IfNotPresent"
    name: "jnlp"
    resources:
      limits:
        memory: "512Mi"
        cpu: "512m"
      requests:
        memory: "512Mi"
        cpu: "512m"
    securityContext:
      privileged: false
    tty: false
    volumeMounts:
    - mountPath: "/home/jenkins"
      name: "workspace-volume"
      readOnly: false
    workingDir: "/home/jenkins"
  - name: docker
    image: docker:latest
    command:
    - cat
    tty: true
    resources:
      limits:
        memory: "512Mi"
        cpu: "512m"
      requests:
        memory: "256Mi"
        cpu: "256m"
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  nodeSelector:
    beta.kubernetes.io/os: "linux"
  restartPolicy: "Never"
  securityContext: {}
  serviceAccount: "default"
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
    - emptyDir:
        medium: ""
      name: "workspace-volume"
"""
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
          container('docker') {
            sh """
               docker build -t yorgdockers/buildit:$BUILD_NUMBER .
            """
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
  }
}