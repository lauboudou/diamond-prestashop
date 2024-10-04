pipeline {
    agent {
        label 'agent_reactjs_node'
    }
    environment{
        DOCKER_HUB_PAT = credentials('docker_hub_pat')
    }
    stages {
        //CI
        stage('Clone (CI)') {
            steps {
                git branch: 'main', credentialsId: 'PAT_GIT_PRESTASHOP', url: 'https://github.com/lauboudou/prestashop-landing-page.git'

            }
        }
        //CD
        stage('Build (CI)') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Test') {
            steps {
                sh 'npm run test'
            }
        }
        stage('Scan'){
            steps {
                withSonarQubeEnv(installationName: 'jenkins_sonarqube'){
                sh '''
                sonar-scanner \
                -Dsonar.projectKey=prestashop-landing-page \
                -Dsonar.sources=. \
                -Dsonar.host.url=http://172.22.0.5:9000 \
                -Dsonar.token=sqp_75dd7d4964b4396c40555330949400174d27a375
                '''
                }
            }
        }
        stage ('Quality Gate'){
            steps {
                timeout(time:4, unit: 'MINUTES'){
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        //CD
        stage('Delivery (CD)') {
            steps {
                sh 'docker login -u dlaubo -p ${DOCKER_HUB_PAT}'
                sh 'docker build . -t dlaubo/prestashop-landing-page:${BUILD_ID}'
                sh 'docker push dlaubo/prestashop-landing-page:${BUILD_ID}'
            }
        }
    }
    //Notification
    /*post {
      success { 
       echo 'This will run only if successful'
        mail bcc: 'admin2@admin.com', body: '''Bonjour, Si vous recevez ce mail, c\'est OK pour moi ! from Diamond Cordialement ''', cc: 'admin1@admin.com', from: '', replyTo: '', subject: 'Jenkins Test Email', to: 'admin@admin.com'
      }
      failure {
        mail bcc: '', body: "<b>Failure Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "ERROR CI: Project name -> ${env.JOB_NAME}", to: "admin@admin.com"
      } 
    }*/
}
