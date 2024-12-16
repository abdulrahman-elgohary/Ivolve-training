# Lab 28: Deployment vs. StatefulSet  

## Objective  
- **Compare** Deployment and StatefulSet.  
- Create a YAML file for **MySQL StatefulSet** configuration.  
- Write a YAML file to define a **Service** for the MySQL StatefulSet.  

---

## 1. Comparison: Deployment vs. StatefulSet  

| Feature              | Deployment                                                                 | StatefulSet                                                    |
|----------------------|---------------------------------------------------------------------------|----------------------------------------------------------------|
| **Purpose**          | Used for stateless applications like web servers.                        | Used for stateful applications like databases.                |
| **Pod Identifiers**  | Pods are interchangeable; they don’t have fixed names.                   | Pods have stable network identities and persistent storage.   |
| **Scaling**          | Scales easily, as pods don’t maintain any order or identity.             | Maintains the order of pod creation and stable identities.    |
| **Storage**          | Does not automatically manage persistent storage.                       | Supports persistent storage via PersistentVolumeClaims (PVCs).|
| **Pod Replacement**  | Replaces a pod with a new one without guaranteeing the same storage.     | Re-attaches the same storage to the new pod after failure.    |
| **Examples**         | Web apps, APIs, and stateless microservices.                            | Databases, caching systems, and distributed systems.          |

---

## 2. MySQL StatefulSet Configuration  

Create a file named `mysql-statefulset.yaml`:  

```yaml
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  selector:
    matchLabels:
      app: mysql
  serviceName: mysql-service
  replicas: 1
  template:
    metadata:
      labels:
        app: mysql

    spec:
      containers:
      - name: mysql-container
        image: mysql:8.0
        ports:
        - containerPort: 3306
          name: mysql-port

        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: root-password

        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata:
      name: mysql-persistent-storage
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 5Gi
```
---

### 3. MySQL StatefulSet Service

Create a file named mysql-service.yaml

```yaml
---
apiVersion: v1 
kind: Service
metadata:
  name: mysql-service
  labels:
    app: mysql

spec:
  ports:
  - port: 3306
    targetPort: 3306
    protocol: TCP
  clusterIP: None
  selector:
    app: mysql
```
- `ClusterIP: None` in the Service ensures the pods are individually addressable in a StatefulSet.
  
### 4.Steps to Apply the Configuration

4.1 **Create a Secret for MySQL Root Password**

```bash
kubectl create secret generic mysql-secret --from-literal=root-password=yourpassword
```
![image](https://github.com/user-attachments/assets/72cce236-3ba7-4af1-b5ae-68a397844469)

4.2 **Apply the StatefulSet**

```bash
kubectl apply -f mysql-statefulset.yaml
```
![image](https://github.com/user-attachments/assets/6065ffda-f368-42e7-9ec3-6cb66d239762)

4.3 **Apply the Service**

```bash
kubectl apply -f mysql-service.yaml
```
![image](https://github.com/user-attachments/assets/736c0296-e234-4683-8bd9-fbf18d260f22)

### 5. Access the MySQL Pod

```bash
kubectl exec -it mysql-0 -- mysql -u root -p
```
![image](https://github.com/user-attachments/assets/d8ce4f48-c8c4-40fa-9004-83b913ed1424)



