pipeline {
	agent any

	tools {
		maven 'M3'
		jdk 'JDK21'
	}

	environment {
		DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
		DOCKER_IMAGE="ahmadelsafty/simple-calculator"
		DOCKER_TAG="latest-${env.BUILD_NUMBER}"
	}

	stages {
		stage('Checkout') {
			steps {
				git branch: 'main',
				url: 'https://github.com/ahmadelsafty/calculator.git'
			}
		}

		stage('Build') {
			steps {
				bat 'mvn clean compile'
			}
		}

		stage('Test') {
			steps {
				bat 'mvn test'
			}
			post {
				always {
					junit 'target/surefire-reports/*.xml'
				}
			}
		}

		stage('Package') {
			steps {
				bat 'mvn package -DskipTests'
			}
		}

		stage('Build Docker Image') {
			steps {
				script {
					bat "docker build -t ${env.DOCKER_IMAGE}:${env.DOCKER_TAG} ."
					bat "docker tag ${env.DOCKER_IMAGE}:${env.DOCKER_TAG} ${env.DOCKER_IMAGE}:latest"
				}
			}
		}

		stage('Push Docker Image') {
			steps {
				script {
					bat "echo ${env.DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${env.DOCKERHUB_CREDENTIALS_USR} --password-stdin"
					bat "docker push ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
					bat "docker push ${env.DOCKER_IMAGE}:latest"
					bat "docker logout"
				}
			}
		}

		stage('Deploy To Docker') {
			steps {
				script {
					bat 'docker stop simple-calculator'
					bat 'docker rm simple-calculator'
					bat 'docker run -d --name simple-calculator ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}'
				}
			}
		}
	}

	post {
		success {
			echo 'Pipeline completed successfully!'
			echo "Docker Image: ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
		}
		failure {
			echo 'Pipeline failed!'
		}
	}
}