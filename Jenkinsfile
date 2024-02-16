pipeline {
    agent {
        label 'agente1'
    }
    
    stages {
        stage('Get Code') {
            steps {
                git branch: 'master', url: 'https://github.com/rubenpio/todo-list-aws.git'
                sh 'wget -O samconfig.toml "https://raw.githubusercontent.com/rubenpio/todo-list-aws-config/production/samconfig.toml"'
            }
        }
        stage ('Deploy') {
            steps {
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                sh '''
                    sam build
                    sam deploy --stack-name todo-list-aws-production --region us-east-1 --parameter-overrides Stage=production --no-confirm-changeset --capabilities CAPABILITY_IAM --s3-bucket aws-sam-cli-managed-default-samclisourcebucket-7d3sgygjka7k --no-disable-rollback --save-params --config-file samconfig.toml --config-env production | tee url.txt
                '''
                }
            }
        }
        stage ('Smoke Test') {
            steps {
                sh '''
                    set PYTHONPATH=%WORKSPACE%
                    chmod 774 -R test/integration/scripts
                    ksh test/integration/scripts/script_prod.ksh
                    /var/lib/jenkins/.local/bin/pytest --junitxml=results.xml test/integration/todoApiTestProd.py 
                    test/integration/scripts/reset_prod.ksh
                '''
                junit 'results.xml'
                script {
                    cleanWs()
                }
            }
        }
    }
}
