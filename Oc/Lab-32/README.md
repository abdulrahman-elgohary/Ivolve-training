# Lab 32: Configuring a MySQL Pod using ConfigMap and Secret

## Objective

- Create a namespace called `ivolve` and apply a resource quota to limit resource usage within the namespace.
- Create a Deployment in the `ivolve` namespace for MySQL with:
  - Resource requests: CPU: 0.5 vCPU, Memory: 1G.
  - Resource limits: CPU: 1 vCPU, Memory: 2G.
- Define MySQL database name and user in a ConfigMap.
- Store the MySQL root password and user password in a Secret.
- Exec into the MySQL pod and verify the database configurations.

---

## Implementation Steps

### Step 1: Create the Namespace
```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: ivolve
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: ivolve-quota
  namespace: ivolve
spec:
  hard:
    requests.cpu: "2"
    requests.memory: "4Gi"
    limits.cpu: "4"
    limits.memory: "8Gi"
    pods: "10"
    persistentvolumeclaims: "5"
```

**Apply the namespace and quota configuration:**
```bash
kubectl apply -f namespace-quota.yaml
```

---

### Step 2: Create the ConfigMap
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config
  namespace: ivolve
data:
  MYSQL_DATABASE: ivolve_db
  MYSQL_USER: ivolve_user
```

**Apply the ConfigMap:**
```bash
kubectl apply -f mysql-config.yaml
```

---

### Step 3: Create the Secret
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: ivolve
data:
  MYSQL_ROOT_PASSWORD: cGFzc3dvcmQ=   # Base64 encoded value of 'password'
  MYSQL_PASSWORD: cGFzc3dvcmQ=        # Base64 encoded value of 'password'
```

**Apply the Secret:**
```bash
kubectl apply -f mysql-secret.yaml
```

---

### Step 4: Create the Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: ivolve
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1"
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: MYSQL_ROOT_PASSWORD
        - name: MYSQL_DATABASE
          valueFrom:
            configMapKeyRef:
              name: mysql-config
              key: MYSQL_DATABASE
        - name: MYSQL_USER
          valueFrom:
            configMapKeyRef:
              name: mysql-config
              key: MYSQL_USER
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: MYSQL_PASSWORD
```

**Apply the Deployment:**
```bash
kubectl apply -f mysql-deployment.yaml
```

---

### Step 5: Verify the Configuration

1. **List all resources in the `ivolve` namespace:**
   ```bash
   kubectl get all -n ivolve
   ```
    ![image](https://github.com/user-attachments/assets/85333155-9b7a-47a1-bdf7-bff5b5e09ab4)

2. **Exec into the MySQL pod:**
   ```bash
   kubectl exec -it <mysql-pod-name> -n ivolve -- /bin/bash
   ```

3. **Verify database configurations inside the pod:**
   ```bash
   mysql -u ivolve_user -p
   # Enter the password stored in MYSQL_PASSWORD (decoded from the Secret).
   mysql> SHOW DATABASES;
   ```
    ![image](https://github.com/user-attachments/assets/14cad7be-304c-48e2-934b-4470733c7ff7)

    ![image](https://github.com/user-attachments/assets/c2b017cb-5e19-479c-84e2-77b99e91230d)

---

### Summary

In this lab, we configured a MySQL pod using Kubernetes best practices, including:
- Namespaces and resource quotas for resource isolation.
- ConfigMaps and Secrets to manage environment variables securely.
- Resource requests and limits for optimal pod performance.
- Verification of database configurations by accessing the MySQL pod.
