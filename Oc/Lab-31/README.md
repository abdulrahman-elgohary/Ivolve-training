### Lab 31: Network Configuration

This lab focuses on setting up network configurations for a Kubernetes environment using Minikube. You will build a Docker image, deploy an application, create a network policy, configure ingress, and access the application via a domain name.

---

### **Steps to Implement**

#### **1. Build a Docker Image**
- Clone the repository and navigate to the directory:
  ```bash
  git clone https://github.com/IbrahimmAdel/static-website.git
  cd static-website
  ```
- Point your Docker CLI to use Minikube’s Docker daemon:
  ```bash
  eval $(minikube docker-env)
  ```
- Build the Docker image:
  ```bash
  docker build -t static-web:1.0 .
  ```
- Verify the image:
  ```bash
  docker images | grep static-web:1.0
  ```

  ![image](https://github.com/user-attachments/assets/0c43b780-b694-4e1a-bc0f-a3b114314a67)


#### **2. Create a Deployment**
- Create a `deployment.yml` file:
  ```yaml
  ---
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: static-web-deployment
    namespace: default
  spec:
    replicas: 3
    selector:
      matchLabels:
        app: static-web
    template:
      metadata:
        labels:
          app: static-web
      spec:
        containers:
        - name: static-web-container
          image: static-web:1.0
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
          ports:
          - containerPort: 80
  ```

- Apply the deployment:
  ```bash
  kubectl apply -f deployment.yml
  ```

#### **3. Expose the Deployment as a Service**
- Create a `service.yml` file:
  ```yaml
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: static-web-svc
  spec:
    selector:
      app: static-web
    ports:
    - port: 80
      targetPort: 80
  ```

- Apply the service:
  ```bash
  kubectl apply -f service.yml
  ```

#### **4. Create a Network Policy**
- Define a `network-policy.yml` file:
  ```yaml
  ---
  apiVersion: networking.k8s.io/v1
  kind: NetworkPolicy
  metadata:
      name: allow-same-namespace
      namespace: default
  spec  :
      podSelector:
        matchLabels:
          app: static-web
      ingress:
      - from:
        - podSelector: {}
  ```

- Apply the network policy:
  ```bash
  kubectl apply -f net-policy.yml
  ```

#### **5. Enable NGINX Ingress Controller**
- Enable the NGINX ingress addon:
  ```bash
  minikube addons enable ingress
  ```

#### **6. Create an Ingress Resource**
- Define an `ingress.yaml` file:
  ```yaml
  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
      name: static-website-ingress
      namespace: default
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /
  spec:
      rules:
      - host: static-website.local
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: static-web-svc
                port:
                  number: 80
  ```

- Apply the ingress resource:
  ```bash
  kubectl apply -f ingress.yml
  ```

#### **7. Update `/etc/hosts`**
- Get the Minikube IP address:
  ```bash
  minikube ip
  ```

- Update the `/etc/hosts` file with the domain:
  ```bash
  sudo nano /etc/hosts
  ```

  Add the following line:
  ```
  <MINIKUBE_IP> static-website.local
  ```

#### **8. Access the Application**
- Open a browser or use `curl` to access the application:
  ```bash
  curl http://static-website.local
  ```
---

### **Validation**
1. Verify the deployment:
   ```bash
   kubectl get deployments
   kubectl get pods
   ```
2. Test the network policy by deploying another pod and ensuring only pods in the same namespace can access the service.
3. Check the ingress logs for traffic routing:
   ```bash
   kubectl logs -n kube-system -l app.kubernetes.io/name=ingress-nginx
   ```

### **Output**
- The static website should be accessible via the domain `http://static-website.local`.

![image](https://github.com/user-attachments/assets/f78ee241-02cb-4e48-83c0-630ebc55ea92)

