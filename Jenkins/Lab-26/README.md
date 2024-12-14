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

- Under `Branch Sources`, add a GitHub source.
- rovide the repository URL (e.g., https://github.com/<your-username>/<repo-name>.git).
- Set credentials if required.
- Under `Discover Branches` Choose all branches
  
![image](https://github.com/user-attachments/assets/74613de4-4bca-424c-a52d-d1c793ce1012)
