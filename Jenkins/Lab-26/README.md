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
- Launch another Server and Install Jenkins with its Prequistes 
- Navigate to Manage Jenkins > Manage Nodes and Clouds > New Node.
- Name the node (e.g., k8s-slave) and choose Permanent Agent.

![image](https://github.com/user-attachments/assets/e797a31c-66ec-4933-a892-3fa01dd2246a)

3.2 **Preconfigure Node Settings**

-  Connect to the agent server and create a Jenkins user if it's not already exist

```bash
sudo useradd jenkins -m
```
- Set a password
  
```bash
sudo passwd jenkins
```
- Switch to the jenkins user

```bash
su - jenkins
```
- Make ssh directory

```bash
mkdir ~/.ssh && cd ~/.ssh
```
```bash
ssh-keygen -t rsa -C "The access key for Jenkins slaves"
```
-  Add the public to authorized_keys file

```bash
cat id_rsa.pub >> ~/.ssh/authorized_keys
```

- Copy the contents of the private key to the clipboard and paste it to the jenkins credentials
- In Credentials choose the `SSH Username with private key`

![image](https://github.com/user-attachments/assets/6688bb2d-038e-4c65-8c1e-64cf9602dc62)

- Connect to the master Jenkins and copy the content of the public key

```bash
cat ~/.ssh/id_rsa.pub
```
- On the Slave machine paste the content

```bash
echo "<public-key>" >> ~/.ssh/authorized_keys
```

### 5.Configure the Node Setting
- Set the Remote Root Directory (e.g., /var/lib/jenkins/).
- Provide the Launch Method (e.g., SSH).
- Choose the created credentials


### 4. Configure the Gitrepo
- Create two more branches on the gitrepo ( dev , staging )

![image](https://github.com/user-attachments/assets/a894e952-d947-431b-96df-66a7f5e8fdcb)

- Create Jenkinsfile on each branch with the following entry

```bash

```
