# Lab 26: MultiBranch Pipeline Project  

![image](https://github.com/user-attachments/assets/abfd7a7b-df2d-4164-a37f-9d6d439a52fe)

## Objective  
- Create **three namespaces** in a Kubernetes environment.  
- Set up a **Multibranch Pipeline** in Jenkins to deploy to the corresponding namespace based on the GitHub branch.  
- Create a **Jenkins slave** to run the pipeline.  

---

## Prerequisites  

1. **Kubernetes Cluster**: Ensure your Kubernetes cluster is running.  
2. **Jenkins Setup**: Jenkins must be installed and accessible, with required plugins.  
   - Install the **Multibranch Pipeline Plugin**.  
   - Install the **Kubernetes Plugin** for Jenkins.  

---

## Steps  

### 1. Create Namespaces in Kubernetes  

- Run the following commands to create the namespaces:  

```bash
kubectl create namespace dev  
kubectl create namespace staging  
kubectl create namespace production
```
- Verify the namespaces

```bash
kubectl get namespaces
```
![image](https://github.com/user-attachments/assets/6d6d4b9b-88cd-48c0-bb5c-8264c4c9a4d3)

### 2. Configure Jenkins Multibranch Pipeline

2.1 **Set Up a Multibranch Pipeline**

- Go to Jenkins Dashboard and click New Item.
- Select Multibranch Pipeline, name it (e.g., K8S-Deployment), and click OK.

2.2 **Configure Branch Sources**

- Under `Branch Sources`, add a Git source.
- Provide the repository URL (e.g., https://github.com/<your-username>/<repo-name>.git).
- Set credentials if required.
- Under `Discover Branches` Choose `Filter by name with regular expression`
  
![image](https://github.com/user-attachments/assets/7eada1f0-cb93-46fa-8ba5-2d4c5aa431d5)

### 3. Set Up a Jenkins Slave

3.1 **Add a New Node in Jenkins**

- Launch another Server and Install Java.
  
  ```bash
  sudo apt install openjdk-17-jdk
  ```

- Install Kubectl on the slave
  ```bash
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
  kubectl version --client
  ```
- Navigate to Manage Jenkins > Manage Nodes and Clouds > New Node.
- Name the node (e.g., k8s-slave) and choose Permanent Agent.

![image](https://github.com/user-attachments/assets/e797a31c-66ec-4933-a892-3fa01dd2246a)

3.2 **Preconfigure Node Settings**


-  Add the public key of the master to authorized_keys file on the slave
- **On Master**
```bash
cat ~/.ssh/id_rsa.pub
```
**On Slave**

```bash
echo "Output of Public Key" >> ~/.ssh/authorized_keys
```
- Copy the contents of the private key of the master and paste it to the jenkins credentials
- In Credentials choose the `SSH Username with private key`

![image](https://github.com/user-attachments/assets/6688bb2d-038e-4c65-8c1e-64cf9602dc62)

### 5.Configure the Node Setting

- Set the Remote Root Directory (e.g., /var/lib/jenkins/).
- Insert `my-slave` in the label section
- Provide the Launch Method (e.g., SSH).
- Choose the earlier created credentials
- Create the node

![image](https://github.com/user-attachments/assets/1a999ebb-ed27-4e2b-8264-704dadba9824)

### 4. Configure the Gitrepo
- Create two more branches on the gitrepo ( dev , staging )

![image](https://github.com/user-attachments/assets/a894e952-d947-431b-96df-66a7f5e8fdcb)

- Create Jenkinsfile on each branch with the following entry

```bash
pipeline {
    agent {
        label 'my-slave'
    } 
    environment {
        KUBE_CONFIG = credentials('kubeconfig-file')
    }
    stages {
        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-file']) {
                    script {
                        // Dynamically set the namespace based on the branch name
                        def namespace = ''
                        if (env.BRANCH_NAME == 'main') {
                            namespace = 'production'
                        } else if (env.BRANCH_NAME == 'staging') {
                            namespace = 'staging'
                        } else {
                            namespace = 'dev'
                        }
                        
                        echo "Deploying to namespace: ${namespace}"

                        sh """
                            kubectl apply -f deployment.yaml -n ${namespace}
                        """
                    }
                }
            }
        }
    }
}
```
### 6. Test the Multibranch Pipeline

Trigger Builds:

- Push changes to each GitHub branch (dev, staging, production).
- Verify that Jenkins detects the branch and triggers a build.

![image](https://github.com/user-attachments/assets/72c180bf-f778-4ce2-8df0-076c2b832251)

```bash
kubectl get pods -n dev
kubectl get pods -n staging
kubectl get pods -n production
```
![image](https://github.com/user-attachments/assets/2de8ecc1-4143-40b6-afb5-3432d60f4c30)

