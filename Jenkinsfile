pipeline {
    agent any
    
    stages {
        stage('Get Code') {
            steps {
                git branch: 'develop', url: 'https://github.com/rubenpio/f.git'
            }
        }
        stage ('Static test') {
            steps {
                sh '''
                     /var/lib/jenkins/.local/bin/flake8 --format=pylint --exit-zero ./src >flake8.out
                     /var/lib/jenkins/.local/bin/bandit --exit-zero -r ./src -f custom -o bandit.out --severity-level medium --msg-template "{abspath}:{line}: [{test_id}, {severity}] {msg}"

                    '''
            }
        }
        stage ('Deploy') {
            steps {
                sh '''
                    sam build
                    sam deploy --stack-name todo-list-aws --region us-east-1 --parameter-overrides Stage=staging --no-confirm-changeset --capabilities CAPABILITY_IAM --s3-bucket aws-sam-cli-managed-default-samclisourcebucket-7d3sgygjka7k --no-disable-rollback --save-params --config-file samconfig.toml --config-env staging | tee url.txt
                '''
            }
        }
        stage ('Rest Test') {
            steps {
                sh '''
                    set PYTHONPATH=%WORKSPACE%
                    ksh script.ksh
                    /var/lib/jenkins/.local/bin/pytest --junitxml=results.xml test/integration/todoApiTest.py 
                '''
            }
        }
    }
}
