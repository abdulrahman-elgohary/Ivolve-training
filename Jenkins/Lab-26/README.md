# Lab 26: MultiBranch Pipeline Project  

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
- rovide the repository URL (e.g., https://github.com/<your-username>/<repo-name>.git).
- Set credentials if required.
- Under `Discover Branches` Choose `Filter by name with regular expression`
  
![image](https://github.com/user-attachments/assets/7eada1f0-cb93-46fa-8ba5-2d4c5aa431d5)

### 3. Set Up a Jenkins Slave

3.1 **Add a New Node in Jenkins**

- Navigate to Manage Jenkins > Manage Nodes and Clouds > New Node.
- Name the node (e.g., k8s-slave) and choose Permanent Agent.

![image](https://github.com/user-attachments/assets/e797a31c-66ec-4933-a892-3fa01dd2246a)

3.2 **Configure Node Settings**

- Set the Remote Root Directory (e.g., /home/jenkins/).
- Provide the Launch Method (e.g., SSH, Docker container).


### 4. Configure the Gitrepo
- Create two more branches on the gitrepo ( dev , staging )

![image](https://github.com/user-attachments/assets/a894e952-d947-431b-96df-66a7f5e8fdcb)

- Create Jenkinsfile on each branch with the following entry

```bash

```
