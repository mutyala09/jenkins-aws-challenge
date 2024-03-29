pipeline {
	agent any

	stages {

		stage('Compile') {
			steps {
				withMaven(maven: 'mymaven') {
				  sh "mvn clean compile"
				}
			}
		}

		stage('Package') {
			steps {
				withMaven(maven: 'mymaven') {
				  sh "mvn package"
				}
			}
		}
		stage('Build Docker image') {
			steps {
				script {
					dockerImage = docker.build("mutyala09/spring-boot-app:${BUILD_NUMBER}")
				}
			}
		}
		stage('Push Docker image') {
			steps {
				script {
					docker.withRegistry('', 'dockerhub') {
						dockerImage.push()
					}
				}
			}
		}
    stage ('Deploy') {
      steps {
	  withCredentials([sshUserPrivateKey(credentialsId: "key", keyFileVariable: 'keyfile')]) {
		sh 'scp -i ${keyfile} docker-compose.yaml ubuntu@100.26.238.127:~/'
          	sh 'ssh -i ${keyfile} ubuntu@100.26.238.127 "IMAGE=mutyala09/spring-boot-app:${BUILD_NUMBER} docker-compose -p cicd up -d --build"'
	  }
      }
    }
	}
}
