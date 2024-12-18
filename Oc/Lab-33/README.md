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

- Retrieve the node-ip
```bash
minikube ip
```
- Access Jenkins via `http://<node-ip>:30000`.

![image](https://github.com/user-attachments/assets/2167360e-bf9d-491e-a997-3cfafc99b43a)

---

## Differences:

### Readiness Probe vs. Liveness Probe
- **Readiness Probe**:
  - Checks if the application is ready to serve traffic.
  - If the probe fails, the pod remains in the "NotReady" state, and traffic is not sent to it.
  - Example use case: Ensure a database connection is established before serving requests.

- **Liveness Probe**:
  - Checks if the application is still running.
  - If the probe fails, Kubernetes restarts the container.
  - Example use case: Detect and recover from deadlocks.

### Init Container vs. Sidecar Container
- **Init Container**:
  - Runs once before the main container starts.
  - Used for initialization tasks such as configuration setup or waiting for dependencies.

- **Sidecar Container**:
  - Runs alongside the main container in the same pod.
  - Used for auxiliary tasks such as logging, monitoring, or proxying requests.

---

## Verification Checklist:
- Ensure the init container completes its sleep task.
- Confirm the readiness and liveness probes work as intended by inspecting pod logs and status.
- Access Jenkins via the NodePort service endpoint.

---
