pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile.dev'
        }
    }
    stages {
        stage('Test') {
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
    }
    post{
        always{
            cleanWs()
        }
    }
}
