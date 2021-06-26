pipeline {
	agent any

	stages {

		stage('Compile') {
			steps {
				withMaven {
				  sh "mvn clean compile"
				}
			}
		}

		stage('Package') {
			steps {
				withMaven {
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
          sh 'ssh ubuntu@18.209.225.51 "IMAGE=mutyala09/spring-boot-app:${BUILD_NUMBER} docker-compose up -d --build"'
      }
    }
	}
}
