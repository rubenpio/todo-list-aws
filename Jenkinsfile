pipeline {
    agent any
    environment {
        GITHUB_TOKEN = credentials('TOKEN')
    }
    stages {
        stage('Get Code') {
            steps {
                git branch: 'master', url: 'https://github.com/rubenpio/todo-list-aws.git'
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
                    ksh test/integration/scripts/script.ksh
                    /var/lib/jenkins/.local/bin/pytest --junitxml=results.xml test/integration/todoApiTest.py 
                    ksh test/integration/scripts/reset.ksh
                '''
                junit 'results.xml'
            }
        }
        stage ('Promote') {
            steps {
                sh '''
                    git add . 
                    git commit -m "Release 1.0.0"
                     git push https://rubenpio:${env.GITHUB_TOKEN}@github.com/rubenpio/todo-list-aws.git develop
                    git checkout master
                    git merge -X theirs develop
                    git push -f https://rubenpio:${env.GITHUB_TOKEN}@github.com/rubenpio/todo-list-aws.git master 
                '''
                junit 'results.xml'
                script {
                    cleanWs()
                }
            }
        }
    }
}
