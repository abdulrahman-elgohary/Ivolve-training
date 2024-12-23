# Lab 33: Multi-container Applications

## Objective:
- Create a deployment for Jenkins with an init container that sleeps for 10 seconds before the Jenkins container starts.
- Use readiness and liveness probes.
- Create a NodePort service to expose Jenkins.
- Verify that the init container runs successfully and Jenkins is properly initialized.
- Explain the differences between readiness & liveness probes, and init & sidecar containers.

---

## Steps:

### 1. Create Deployment YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-deployment
  labels:
    app: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      initContainers:
      - name: init-container
        image: busybox
        command: ["sh", "-c", "echo Initializing... && sleep 10"]
      containers:
      - name: jenkins
        image: jenkins/jenkins:lts
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /login
            port: 8080
          initialDelaySeconds: 20
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /login
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 15
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1"
```

### 2. Apply Deployment

```bash
kubectl apply -f jenkins-deployment.yaml
```

### 3. Create NodePort Service YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
spec:
  type: NodePort
  selector:
    app: jenkins
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080
    nodePort: 30000
```

![image](https://github.com/user-attachments/assets/ab53a18f-58cc-4b76-911d-0e5747157bf6)

### 4. Apply Service

```bash
kubectl apply -f jenkins-service.yaml
```

### 5. Verify Initialization and Access Jenkins

- Check the status of the init container:

```bash
kubectl get pods
```
![image](https://github.com/user-attachments/assets/4bc0a2c6-09e6-48a9-8d01-91453bee6bea)

- It takes a while until it's ready because of the Readiness Probe

- Ensure the init container completes successfully and Jenkins initializes properly:

```bash
kubectl logs <jenkins-pod-name> -c init-container
```
![image](https://github.com/user-attachments/assets/1a5f71a3-b949-49ce-ad4d-5bf4c89a02ee)

- Retrieve the node-ip
```bash
minikube ip
```
- Access Jenkins via `http://<node-ip>:30000`.

![image](https://github.com/user-attachments/assets/2167360e-bf9d-491e-a997-3cfafc99b43a)

---

## Differences:

### Readiness Probe vs. Liveness Probe
| Aspect             | Readiness Probe	           |     Liveness Probe	     |                                               
|---------------------|-----------------------------------|----------------------------------------|  
| **Purpose**      |Ensures the application is ready to serve traffic.		|Ensures the application is alive and not stuck.| 
| **When Checked**    | Before sending traffic to the pod.		              | Periodically during the pod's lifecycle.| 
| **Behavior**          | Marks the pod as "not ready" if it fails.	         	|	Restarts the pod if it fails.     |           
| **Example Use**   |Database connectivity check.			|	Memory leak detection or infinite loop.      | 

### Init Container vs. Sidecar Container
| Aspect             | Init Container	         |     Sidecar Container     |                                               
|---------------------|-----------------------------------|----------------------------------------|  
| **Purpose**      |Prepares the environment for the main container.		|Augments the main container's functionality.| 
| **Lifecycle**          | Runs once before the main container starts.		         	|	Runs alongside the main container.     |           
| **Example Use**   |Configuration setup, database migration.				|	Logging, monitoring, or caching.    | 

---

## Verification Checklist:
- Ensure the init container completes its sleep task.
- Confirm the readiness and liveness probes work as intended by inspecting pod logs and status.
- Access Jenkins via the NodePort service endpoint.

---
