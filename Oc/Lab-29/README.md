# Lab 29: Storage Configuration  

## Objective  
1. Create a deployment named `my-deployment` using the NGINX image.  
2. Verify file persistence across pod deletions using a PVC.  
3. Compare PersistentVolume (PV), PersistentVolumeClaim (PVC), and StorageClass.  

---

## Steps  

### Step 1: Create the Deployment  

1.1 **Create a file named `nginx-deployment.yaml`**:  

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 1
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

1.2 **Apply the deployment**

```bash
  kubectl apply -f nginx-lab.yml
```
![image](https://github.com/user-attachments/assets/57479050-ce39-419a-b3fe-9595a07e85ce)

1.3 **Verify the pod is running**

```bash
kubectl get pods
```
![image](https://github.com/user-attachments/assets/f69719b3-1d6a-43e6-920e-c7c45cfe4cdf)

### 2. Exec into the Pod and Create a File

```bash
kubectl exec <my-deployment-589dffc94f-xmpdk> -it bash
```

```bash
echo "hello,this is Abdulrahman" >> /usr/share/nginx/html/hello.txt
```
![image](https://github.com/user-attachments/assets/386d3e82-3b52-4b00-abac-28f8d6cfde4b)


- Verify the file is served by NGINX:

```bash
curl localhost/hello.txt
```
![image](https://github.com/user-attachments/assets/4ec11af7-797d-4798-b813-989550d38729)

### 3. Delete the NGINX Pod

```bash
kubectl delete pod <nginx-pod-name>
```
- Wait for the deployment to create a new pod:

```bash
kubectl get pods
```
![image](https://github.com/user-attachments/assets/f78c663e-8fa9-44c2-ba5c-0cf1010f0ab6)

- Exec into the Pod and check the existence of hello.txt file

```bash
kubectl exec  my-deployment-589dffc94f-q92nz  -it -- ls /usr/share/nginx/html/
```

![image](https://github.com/user-attachments/assets/cd633b42-514d-47d5-a220-8751289badf2)

### 4. Create a PVC and Update the Deployment

**PVC Configuration**

- Create a file named `nginx-pvc.yml`

```yaml
---
apiVersion: v1 
kind: PersistentVolumeClaim
metadata:
  name: nginx-pvc
spec:
  resources:
    requests:
      storage: 1Gi
  accessModes:
    - ReadWriteOnce
```
- Modify the deployment to attach the PVC. Update `nginx-lab.yml` as follows

```bash
#Create a Delpoyment
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
  
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: my-container
        image: nginx:latest
        ports:
        - containerPort: 80
        volumeMounts: 
        - name: nginx-volume
          mountPath: /usr/share/nginx/html
        volumes: 
        - name: nginx-volume
          PersistentVolumeClaim:
            claimName: nginx-pvc
```
- Apply the updated deployment

```bash
kubectl apply -f nginx-deployment.yaml
```

### 5. Verify File Persistence 

5.1 **Exec into the Pod and Create the File**


```bash
kubectl exec -it my-deployment-95b85cccd-jqnqm bash
```

![image](https://github.com/user-attachments/assets/689958b4-1b84-4b7c-a7fb-f3ebe7a0980e)

5.2 **Delete the pod**

```bash
kubectl delete pod <nginx-pod-name>
```

5.3 **Verify the File in the New Pod**

```bash
kubectl exec -it <new-nginx-pod-name> -- cat /usr/share/nginx/html/hello.txt
```

![image](https://github.com/user-attachments/assets/7c5efcf3-0488-4efb-864a-fb5721cc02c0)


### 6. Comparison Between PV, PVC, and StorageClass

