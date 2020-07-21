pipeline {
    agent {
        dockerfile { 
            filename 'Dockerfile.build'
        }
    }
    stages {
        stage('Test') {
            steps {
                sh '''
                    /opt/satosa/bin/pip install -r /src/satosa/tests/test_requirements.txt
                    /opt/satosa/bin/pip install -r ./tests/test_requirements.txt
                    /opt/satosa/bin/pytest --cov-report xml --cov-report term-missing --cov ./ --deselect tests/flows/test_oidc-saml.py::TestOIDCToSAML::test_full_flow --deselect tests/satosa/scripts/test_satosa_saml_metadata.py::TestConstructSAMLMetadata::test_oidc_saml
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
