# Lab 23: Jenkins Pipeline for Application Deployment  

## Objective  
Create a Jenkins pipeline that automates the following processes:  
1. Build a Docker image from a `Dockerfile` in the provided GitHub repository.  
2. Push the Docker image to Docker Hub.  
3. Edit the new image version in `deployment.yaml`.  
4. Deploy the application to a Kubernetes cluster.  
5. Include a post-action step in your `Jenkinsfile`.  

---

## Prerequisites  

1. **Set Up Jenkins**: Ensure Jenkins is installed and configured.  
2. **Plugins to Install**:  
   - Pipeline  
   - Docker Pipeline  
   - Kubernetes CLI  
   - Git
   - Credentials 
   - Credentials Binding
     
3. **Access Configuration**:  
   - Jenkins must have access to your GitHub repository and Docker Hub credentials.  
   - Jenkins should have a Kubernetes cluster kubeconfig file.  

---

## Steps  

### 1. Install and Configure Jenkins as a Service  

1.1  **Update System Packages**:

```bash
sudo apt update && sudo apt upgrade -y
```
1.2 **Install Java: Jenkins requires Java. Install it using**

```bash
sudo apt install openjdk-17-jdk
```
1.3 **Add Jenkins GPG Key**

```bash
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
```
1.4 **Add Jenkins Repository**

```bash
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```

1.5 **Update Package List**

```bash
sudo apt update
```

1.6 **Install and Start Jenkins**

```bash
sudo apt install jenkins -y
```

```bash
sudo systemctl start jenkins
```

```bash
sudo systemctl enable jenkins
```

1.7 **Configure Jenkins**

1.7.1 *Access Jenkins Web Interface by navigating to http://<server-ip>:8080*

1.7.2 *Retrieve Admin Password*

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
1.7.3 *Complete the Setup Wizard*:
- Use the retrieved password to log in.
- Install recommended plugins and set up your admin account.

1.7.4 *The other users don't have permission to access the docker runtime*

```bash
chmod 666 /var/run/docker.sock
```

![image](https://github.com/user-attachments/assets/36b506cf-6efe-4588-bbb3-b782e16fdd25)

- Now Jenkins user can implement docker commands

![image](https://github.com/user-attachments/assets/349d13a0-55f4-42a8-8384-c2bc5a1e6cdd)

### 2. Create Required Ceredentials

2.1 **Create Jenkins Credentials to be able to access the git repo**

`Manage Jenkins` >> `Credentials` >> `Add Credentials`

![image](https://github.com/user-attachments/assets/5bdb8b1e-1db7-4d94-a371-90c0753de1bd)

2.2 **Create a Dockerhub Repository**
  
2.3 **Create Credentials for the Jenkins to be able to access the dockerhub repo**

![image](https://github.com/user-attachments/assets/9bf464ba-d9e6-4993-a601-d44c8d2edc6c)

2.4 **Create Credentials for Jenkins to be able to access the Kubernetes Cluster** 

- Upload the kubconfig file in Kubernetes Cluster to Jenkins Credentials

```bash
~/.kube/config
```
![image](https://github.com/user-attachments/assets/ec03d94e-1e54-4019-8ecf-3a85bb67b246)

### Create a Pipeline Project 

- Add the link of the Repo : https://github.com/abdulrahman-elgohary/ivolve-training in the Pipeline Section


- Change the branch to main
- Add the git repo credentials that you created earlier
- Insert the path of Jenkins File in the Repo to the `Scriptpath` Section

### Check the Jenkins file in the git repo and other related files the run the build 

- Verify the Execution of the Pipeline

```bash
kubectl get deployments
```
![image](https://github.com/user-attachments/assets/aff6fdd9-4edf-47a1-b852-a1a50969e973)

- Check the image used by the pods

```bash
kubectl describe pod <pod-id>
```
![image](https://github.com/user-attachments/assets/98beb73e-eaf7-4b79-885d-e7407cde6f80)
