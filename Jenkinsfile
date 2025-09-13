pipeline {
    agent any
    
    tools {
        nodejs 'nodejs23'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github-public-token', url: 'https://github.com/alrickgit/End-to-End-CI-CD-Pipeline-for-3-Tier-Node.js-Application-on-AWS-EKS.git'
            }
        }
        
        stage('Frontend Compilation') {
            steps {
                dir('client') {
                    sh 'find . -name "*.js" -exec node --check {} +'
                }
            }
        }
        
        stage('Backend Compilation') {
            steps {
                dir('api') {
                    sh 'find . -name "*.js" -exec node --check {} +'
                }
            }
        }
        
        stage('GitLeaks Scan') {
            steps {
                sh 'gitleaks detect --source ./client --exit-code 1'
                sh 'gitleaks detect --source ./api --exit-code 1'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=NodeJS-Project \
                            -Dsonar.projectKey=NodeJS-Project '''
                }
            }
        }
        stage('Quality Gate Check') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs-report.html .'
            }
        }
        
        stage('Build-Tag & Push Backend Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-creds') {
                        dir('api') {
                            sh 'docker build -t alricklobo01/mern-backend:latest .'
                            sh 'trivy image --format table -o backend-image-report.html alricklobo01/mern-backend:latest '
                            sh 'docker push alricklobo01/mern-backend:latest'
                           
                        }
                    }
                }
            }
        }  
            
        stage('Build-Tag & Push Frontend Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-creds') {
                        dir('client') {
                            sh 'docker build -t alricklobo01/mern-frontend:latest .'
                            sh 'trivy image --format table -o frontend-image-report.html alricklobo01/mern-frontend:latest '
                            sh 'docker push alricklobo01/mern-frontend:latest'
                        }
                    }
                }
            }
             
        }  

        stage('Manual Approval for Production') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    input message: 'Approve deployment to PRODUCTION?', ok: 'Deploy'
                }
            }
        }
        
       stage('Deployment To Prod') {
            steps {
                script {
                    withKubeConfig(caCertificate: '', clusterName: 'three-tier-app', contextName: '', credentialsId: 'k8s-cluster-creds', namespace: 'prod', restrictKubeConfigAccess: false, serverUrl: 'https://0E10F62D68891E3B8B2D0C6AF8513F7B.gr7.ap-south-1.eks.amazonaws.com') {
                        sh 'kubectl apply -f k8s-manifests/sc.yaml'
                        sleep 20
                        sh 'kubectl apply -f k8s-manifests/mysql.yaml -n prod'
                        sh 'kubectl apply -f k8s-manifests/backend.yaml -n prod'
                        sh 'kubectl apply -f k8s-manifests/frontend.yaml -n prod'
                        sh 'kubectl apply -f k8s-manifests/ci.yaml'
                        sleep 30
                        sh 'kubectl apply -f k8s-manifests/ingress.yaml -n prod'
                        sleep 30
                    }
                }
            }
        }
        
        stage('Verify Deployment To Prod') {
            steps {
                script {
                    withKubeConfig(caCertificate: '', clusterName: 'three-tier-app', contextName: '', credentialsId: 'k8s-cluster-creds', namespace: 'prod', restrictKubeConfigAccess: false, serverUrl: 'https://0E10F62D68891E3B8B2D0C6AF8513F7B.gr7.ap-south-1.eks.amazonaws.com') {
                        sh 'kubectl get pods -n prod'
                        sleep 20
                         sh 'kubectl get ingress -n prod'
                        
                    }
                }
            }
        }
        
    }
}
