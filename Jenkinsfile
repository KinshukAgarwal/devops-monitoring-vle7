pipeline {
  agent any
  environment {
    // Local registry on the EC2 (k3s pulls from it, see /etc/rancher/k3s/registries.yaml)
    IMAGE = "localhost:5000/myapp:${BUILD_NUMBER}"
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t myapp -t $IMAGE .'
        sh 'docker push $IMAGE'
      }
    }
    stage('Deploy') {
      steps {
        sh 'sed -i "s|localhost:5000/myapp:.*|$IMAGE|" deployment.yaml'
        sh 'kubectl apply -f deployment.yaml'
        sh 'kubectl rollout status deployment/myapp --timeout=180s'
        sh 'kubectl get pods -l app=myapp -o wide'
      }
    }
  }
}
