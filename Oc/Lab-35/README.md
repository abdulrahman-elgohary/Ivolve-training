### Lab 35: Helm Chart Deployment

#### Objective
- Create a new Helm chart for Nginx.
- Deploy the Helm chart and verify the deployment.
- Access the Nginx server.
- Delete the Nginx release.

---

#### Steps

1. **Create a New Helm Chart**  
   - Install Helm if not already installed:  
     ```bash
     curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
     ```
   - Create a new Helm chart for Nginx:  
     ```bash
     helm create nginx-chart
     ```
   - Navigate to the Helm chart directory:  
     ```bash
     cd nginx-chart
     ```
   - Edit `values.yaml` to configure the Nginx deployment:
     ```yaml
     replicaCount: 1
     image:
       repository: nginx
       tag: "latest"
       pullPolicy: IfNotPresent
     service:
       type: NodePort
       port: 80
     ingress:
       enabled: false
     resources:
       limits:
         cpu: 500m
         memory: 512Mi
       requests:
         cpu: 250m
         memory: 256Mi
     ```
   - Ensure templates are correctly set for Deployment and Service in the `templates/` directory.

2. **Deploy the Helm Chart**  
   - Deploy the Helm chart using:  
     ```bash
     helm install nginx-release ./nginx-chart
     ```
   - Verify the deployment:  
     ```bash
     kubectl get all
     ```
     ![image](https://github.com/user-attachments/assets/3210d5b4-7e1c-4f90-9589-52933f73f46d)

3. **Access the Nginx Server**  
   - Retrieve the NodePort assigned to the Nginx service:  
     ```bash
     kubectl get svc
     minikube ip
     ```
     ![image](https://github.com/user-attachments/assets/3ab350b9-3c87-4333-bcab-eddd1e9f02b9)

   - Access the server using `http://<Node-IP>:<NodePort>`.

     ![image](https://github.com/user-attachments/assets/2d0da822-b003-43b9-b19c-32e6f64a8470)

4. **Delete the Nginx Release**  
   - Uninstall the Helm release:  
     ```bash
     helm uninstall nginx-release
     ```
   - Verify the resources are deleted:  
     ```bash
     kubectl get all
     ```

     ![image](https://github.com/user-attachments/assets/e1377300-4378-4b27-a14f-4537f24bd244)

---

#### Additional Notes

- **Helm Chart Structure**  
  Helm charts have a predefined structure:
  ```
  nginx-chart/
  ├── Chart.yaml        # Metadata about the chart
  ├── values.yaml       # Default values for the templates
  ├── templates/        # Kubernetes resource definitions
  │   ├── deployment.yaml
  │   ├── service.yaml
  │   └── others...
  ```

- **Common Commands**  
  - Upgrade a release:  
    ```bash
    helm upgrade nginx-release ./nginx-chart
    ```
  - View Helm release history:  
    ```bash
    helm history nginx-release
    ```

- **Concepts**  
  - Helm is a package manager for Kubernetes, simplifying deployments.
  - Charts encapsulate Kubernetes resources into reusable packages.
