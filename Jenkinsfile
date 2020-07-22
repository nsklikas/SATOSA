pipeline {
    agent any
    environment {
        GIT_COMMIT_HASH=sh(script: "cd ${WORKSPACE} && git log -1 --format=\"%H\" | cut -c1-8",returnStdout: true).trim()
    }
    stages {
        stage('Test') {
            agent {
                dockerfile {
                    filename 'Dockerfile.dev'
                }
            }
            steps {
                sh '''
                    pytest \
                        --cov-report xml \
                        --cov-report term-missing \
                        --cov satosa \
                        --deselect tests/flows/test_oidc-saml.py::TestOIDCToSAML::test_full_flow \
                        --deselect tests/satosa/scripts/test_satosa_saml_metadata.py::TestConstructSAMLMetadata::test_oidc_saml
                '''
                cobertura coberturaReportFile: '**/coverage.xml'
            }
        }
        stage('Push docker image') {
            when { branch 'eIDAS' }
            steps {
                withCredentials(bindings: [usernamePassword(credentialsId: 'eid-proxy-grnet-registry', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh '''
                        cd ${WORKSPACE}
                        docker login -u $USERNAME -p $PASSWORD registry.docker.grnet.gr
                        docker build --build-arg GIT_COMMIT=$GIT_COMMIT_HASH -t satosa:$GIT_COMMIT_HASH .
                        docker tag satosa:$GIT_COMMIT_HASH registry.docker.grnet.gr/eid-proxy/satosa:$GIT_COMMIT_HASH
                        docker push registry.docker.grnet.gr/eid-proxy/satosa:$GIT_COMMIT_HASH
                    '''
                }
            }
        }
    }
    post{
        always{
            cleanWs()
        }
    }
}
