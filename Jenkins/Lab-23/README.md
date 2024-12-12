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
3. **Access Configuration**:  
   - Jenkins must have access to your GitHub repository and Docker Hub credentials.  
   - Jenkins should have a Kubernetes cluster kubeconfig file.  

---

## Steps  

### 1. Run the Jenkins Container with the following charactrestics: 

1. Mounting volumes
- Mount Jenkins Home
- Mount the docker volume
- Mount the docker runtime

```bash
docker run -p 8080:8080 -p 50000:50000 -d \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $(which docker):/usr/bin/docker jenkins/jenkins:lts
```
2. Change permissions of Jenkins user using the root user

```bash
docker exec -it -u 0 33e0ee647ff8 bash
```
![image](https://github.com/user-attachments/assets/8d3658f1-58b4-451e-a9f6-b06774b3b82e)

- The other users don't have permission to the docker runtime

```bash
chmod 666 /var/run/docker.sock
```

![image](https://github.com/user-attachments/assets/36b506cf-6efe-4588-bbb3-b782e16fdd25)

- Now you can use the jenkins user to implement docker commands

![image](https://github.com/user-attachments/assets/349d13a0-55f4-42a8-8384-c2bc5a1e6cdd)

### 2. Build an image from a Docker file 

- Create Jenkins Credentials to be able to access the git repo

`Manage Jenkins` >> `Credentials` >> `Add Credentials`

![image](https://github.com/user-attachments/assets/5bdb8b1e-1db7-4d94-a371-90c0753de1bd)

- Build a new Job to automate the process of building the image from the docker file in the repo

- In the `Source Code Management` Section paste the URL of the Repo and choose your credentials change the branch to `main`

![image](https://github.com/user-attachments/assets/58cba648-0e09-4916-9af2-44fafbcd0618)

- In the `Build Steps` Section choose `Execute Shell` and insert the following line

```bash
docker build -t python-image:1.0 .
```

- Run the Build

![image](https://github.com/user-attachments/assets/a390d516-1b1c-4b60-b7a3-f3eaae7f9008)

- Verify that the image has been built in your local machine

```bash
docker images
```

![image](https://github.com/user-attachments/assets/5afe4a52-c72c-4b82-b53d-8c0b85c5a745)

### 3.




  
