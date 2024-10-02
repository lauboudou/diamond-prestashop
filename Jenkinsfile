pipeline {
    agent {
        label 'agent_reactjs_node'
    }
    
    environment{
        DOCKER_CREDENTIALS_ID = 'dockerhub_credentials'
    }
    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/lauboudou/horoscope-zodiac-js.git'
            }
        }
        stage('Build') {
            steps {
                sh 'npm install && npm run build'
            }
        }
        stage('Test') {
            steps {
                sh 'npm run test'
            }
        }
        stage('Scan'){
            steps {
                 withSonarQubeEnv(installationName: 'sonarqube-server'){
                    sh '''
                      sonar-scanner \
                      -Dsonar.projectKey=Sonar-horoscope-zodiac-js \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=http://172.18.0.2:9000 \
                      -Dsonar.token=sqp_d24cfb91332ef4caad3522ca08b7ed0fd995a5aa


                    '''
                }
            }
        }
        stage ('Quality Gate'){
          steps {
                 timeout(time:4, unit: 'MINUTES'){ waitForQualityGate abortPipeline: true }
          }
        }
        stage('Delivery') {
            steps {
                script {
                  withCredentials([usernamePassword(credentialsId: "${env.DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                        sh 'docker login -u $DOCKERHUB_USER -p $DOCKERHUB_PASS'
                        sh 'docker build . -t dlaubo/horoscope-zodiac-js:${BUILD_ID}'
                        sh 'docker push dlaubo/horoscope-zodiac-js:${BUILD_ID}'
                  }
                }
            }
        }
    }
    post {
      success { 
       echo 'This will run only if successful'
        mail bcc: 'admin2@admin.com', body: '''Bonjour, Si vous recevez ce mail, c\'est OK pour moi ! from zodiacJS Cdt ''', cc: 'admin1@admin.com', from: '', replyTo: '', subject: 'Jenkins Test Email', to: 'admin@admin.com'
      }
      failure {
        mail bcc: '', body: "<b>Failure Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "ERROR CI: Project name -> ${env.JOB_NAME}", to: "admin@admin.com"
      } 
    }
}
    