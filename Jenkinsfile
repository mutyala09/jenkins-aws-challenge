pipeline {
	agent any

	stages {

		stage('Compile') {
			steps {
				sh 'mvn clean compile'
			}
		}

		stage('Package') {
			steps {
				sh "mvn package"
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
          sh 'ssh ubuntu@${REMOTE_HOST} "IMAGE=mutyala09/spring-boot-app:${BUILD_NUMBER} docker-compose up -d --build"'
      }
    }
	}
}
