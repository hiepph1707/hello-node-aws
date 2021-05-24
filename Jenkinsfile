
pipeline {
   
   agent { label 'master' }
   
   environment { 
	   
	DOCKER_IMAGE = 'nodejs/app'
	   
	ECR_REPO = '685218805491.dkr.ecr.ap-southeast-1.amazonaws.com/nodejs'
	APP_VERSION = "${BUILD_ID}"
        APP_ENV = "${BRANCH_NAME}"
   
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
	AWS_DEFAULT_REGION    = 'ap-southeast-1'
	AWS_DEFAULT_OUTPUT    = 'json'
	   
	STAGING_TASK    = 'td-ecs-toja04-nodejs-staging'
	STAGING_CLUSTER = 'ecs-toja04-nodejs-staging'
	STAGING_SERVICE = 'srv-ecs-toja04-nodejs-staging'
	   
	RELEASE_TASK    = 'td-ecs-toja04-nodejs-release'
	RELEASE_CLUSTER = 'ecs-toja04-nodejs-release'
	RELEASE_SERVICE = 'srv-ecs-toja04-nodejs-release'
   }

   stages {

      stage('[NODEJS] Build') {
         steps {
            echo '****** Build app ******'
            sh './jenkins/build.sh'
         }
      }
      
      stage('[NODEJS] Push to ECR') {
         steps {
            echo '****** Push docker image to ECR ******'
            sh './jenkins/push.sh'
         }
      }
      
      stage('[NODEJS] Deploy to staging') {
            when {
                branch 'staging' 
	    }
            steps {
		echo "****** Deploy to ${BRANCH_NAME} branch ******"
                sh './jenkins/deploy_staging.sh'
            }
        }
      stage('[NODEJS] Deploy to production') {
           when {
                branch 'main' 
            }
            steps {
		echo "****** Deploy to ${BRANCH_NAME} branch ******"
                sh './jenkins/deploy_release.sh'
            }
        }
   }
      post {
           always {
           	emailext attachLog: true, body: """<p>Check console output at ${env.BUILD_URL} to view the results.:</p>""", to: '$DEFAULT_RECIPIENTS', subject: """${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} [${currentBuild.currentResult}]"""
      	   }
      }
}
