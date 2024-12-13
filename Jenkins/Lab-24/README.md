# Lab 24: Jenkins Shared Libraries  

## Objective  
Implement shared libraries in Jenkins to reuse code across multiple pipelines. Create a shared library for common tasks and demonstrate its usage in different pipelines.  

---

## Prerequisites  

1. **Set Up Jenkins**: Ensure Jenkins is installed and configured.  
2. **Install Pipeline Utility Plugins**:  
   - Pipeline: Shared Groovy Libraries  

---

## Steps  

### 1. Set Up a Shared Library  

1. **Create a Repository for the Shared Library**:  
   - Create a new GitHub repository named `jenkins-shared-library`.  
   - Add a folder structure for the library:  
     ```
     vars/
     src/
     ```
   - **`vars/` Directory**: Contains global functions accessible in pipelines.  
   - **`src/` Directory**: Contains classes and helper methods.  

2. **Add a Global Function**:  
   - Create a file `vars/common.groovy` in the repository:  
     ```groovy
     def printMessage(String message) {
         echo "Shared Library Message: ${message}"
     }

     def buildDockerImage(String imageName, String dockerfilePath = '.') {
         sh "docker build -t ${imageName} ${dockerfilePath}"
     }
     ```

3. **Push the Library to GitHub**:  
   - Commit and push the repository.  

---

### 2. Configure the Shared Library in Jenkins  

1. **Add the Library**:  
   - Go to **Jenkins Dashboard > Manage Jenkins > Configure System**.  
   - Scroll to the **Global Pipeline Libraries** section.  
   - Add a new library:  
     - Name: `common-library`  
     - Default Version: `main`  
     - Retrieval Method: **Modern SCM**  
     - SCM: **Git**  
     - Repository URL: `https://github.com/<your-username>/jenkins-shared-library.git`  

2. Save the configuration.  

![image](https://github.com/user-attachments/assets/1e463f58-f046-4497-9887-fe4a45c61919)

---

### 3. Use the Shared Library in a Pipeline  

1. **Create a Jenkins Pipeline Job**:  
   - Go to **Jenkins Dashboard > New Item > Pipeline**.  
   - Name it `Pipeline with Shared Library`.  

2. **Define the Pipeline**:  

```groovy
@Library('common-library') _
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'your-docker-hub-username/app:latest'
    }

    stages {
        stage('Print Shared Library Message') {
            steps {
                script {
                    common.printMessage('Hello from the shared library!')
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    common.buildDockerImage(DOCKER_IMAGE)
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline with shared library complete!'
        }
    }
}
