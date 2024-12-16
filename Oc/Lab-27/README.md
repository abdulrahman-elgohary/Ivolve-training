# Lab 27: Updating Applications and Rolling Back Changes  

## Objective  
- Deploy **NGINX** with 3 replicas.  
- Create a service to expose the NGINX deployment and use **port forwarding** to access it locally.  
- Update the NGINX image in the deployment to **Apache**.  
- View the deployment's **rollout history**.  
- Roll back the NGINX deployment to the previous image version and monitor pod status to confirm successful rollback.  

---

## Steps  

### 1. Deploy NGINX with 3 Replicas  

1. Create a deployment YAML file named `nginx.yaml`:  

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-deployment
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - name: nginx
            image: nginx:latest
            ports:
            - containerPort: 80
    ```

2. Apply the deployment:  

    ```bash
    kubectl apply -f nginx.yaml
    ```


3. Verify the deployment:  

    ```bash
    kubectl get deployments
    kubectl get pods
    ```
   ![image](https://github.com/user-attachments/assets/8b66e24b-9050-4cbf-874e-51cc117a2bb4)

   ![image](https://github.com/user-attachments/assets/7aaacc21-d7fd-4781-b359-b66d971efaea)

---

### 2. Expose NGINX Deployment with a Service  

1. Create a service YAML file named `service.yaml`:  

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx-service
    spec:
      ports:
      - protocol: TCP
        port: 80
        targetPort: 80
      selector:
        app: nginx
    ```

2. Apply the service:  

    ```bash
    kubectl apply -f nginx-service.yaml
    ```

    ![image](https://github.com/user-attachments/assets/db64fe34-778a-4640-b2a6-72364562af6c)

- If you try to access the nginx server from web browser it fails, because the exposing is inside the cluster only

3. Forward the service port locally:  

    ```bash
    kubectl port-forward service/nginx-service 9080:80
    ```
    ![image](https://github.com/user-attachments/assets/b99e4261-c4a7-4fbe-bcba-a582a373f3d0)

- Now you can access the nginx server from internet from the port `9080`

4. Access NGINX locally:  

    Open a browser and navigate to `http://localhost:9080`.  

    ![image](https://github.com/user-attachments/assets/2ce02a69-339f-489c-a81f-08fc9af4021f)

---

### 3. Update Deployment Image to Apache  

1. Update the deployment to use the **Apache** image:  

    ```bash
    kubectl set image deployment/nginx-deployment nginx=httpd:latest
    ```
   - Change `nginx` to your container name and `httpd` to the new desired image
   - When you observe the creation of the new pods using the following command

   ```bash
   watch kubectl get pods
   ```
   
   ![image](https://github.com/user-attachments/assets/e27bca4e-ef75-4025-b87f-d56523aee3ac)

   - You will notice that new pod is created first then the old pod is deleted and this algorithm to reduce the downtime 

3. Monitor the rollout status:  

    ```bash
    kubectl rollout status deployment/nginx-deployment
    ```
    ![image](https://github.com/user-attachments/assets/e8526ba4-4582-4c4b-a6b7-b52a4123acbd)

4. Verify the updated pods:  

    ```bash
    kubectl get pods -o wide
    ```
    - The old pods
      
    ![image](https://github.com/user-attachments/assets/dc10a8c9-19b9-4e4d-ae99-887cf8d85f93)

    - The new pods after the rollout ( Notice the change in the names )

    ![image](https://github.com/user-attachments/assets/8747dd1f-a2dd-4981-baf4-2a600f235051)

    - To verify that the pod is created from the new image
      
    ```bash
    kubectl describe pod <pod-name>
    ```
    ![image](https://github.com/user-attachments/assets/3ef2d9fc-981f-4d69-901b-2d1264760cb1)

---

### 4. View Rollout History  

1. Check the rollout history:  

    ```bash
    kubectl rollout history deployment/nginx-deployment
    ```
    ![image](https://github.com/user-attachments/assets/c769068d-88a0-4a28-9b2d-adcbf1c2b6a8)

---

### 5. Roll Back to Previous NGINX Image  

1. Roll back the deployment:  

    ```bash
    kubectl rollout undo deployment/nginx-deployment
    ```

2. Monitor the pod status:  

    ```bash
    kubectl get pods -w
    ```
    ![image](https://github.com/user-attachments/assets/c9d3a783-03d1-4ccc-a33f-a9df389753f4)

3. Verify the rollback:  

    ```bash
    kubectl rollout history deployment/nginx-deployment
    kubectl describe deployment nginx-deployment
    ```

    ![image](https://github.com/user-attachments/assets/daac0e70-3208-480c-8d66-a7335b5434f3)


    ![image](https://github.com/user-attachments/assets/20348a1f-6a42-444e-887c-84fb592a3ee8)

---

