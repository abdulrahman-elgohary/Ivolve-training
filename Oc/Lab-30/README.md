# Lab 30: OpenShift Security and RBAC  

## Objective  
1. Create a Service Account.  
2. Define a Role named `pod-reader` with read-only access to pods in a namespace.  
3. Bind the `pod-reader` Role to the Service Account and retrieve the Service Account token.  
4. Compare **Service Account**, **Role & RoleBinding**, and **ClusterRole & ClusterRoleBinding**.

---

## Steps  

### Step 1: Create a Yaml file for Service Account - Role - RoleBinding

**Create a yaml file holds the configuration of the following**:

- `Service Account named `my-svc-acc.yml`
- `Role` named `pod-reader`
- `RoleBinding` named `pod-reader-binding`

```yaml
---
#Create the Service Account
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-svc-acc
  namespace: default
secrets:
  - name: svc-secret
---
#Create the Role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: default
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]

---
#Role_Binding
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: default
subjects:
- kind: ServiceAccount
  name: my-svc-acc
  namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

- Apply the Yaml file

```bash
kubectl apply -f service_acc.yml
```

![image](https://github.com/user-attachments/assets/c6ebf614-85cc-4e3d-924f-a13af4215e5d)

- Verify the created resources

```bash
kubectl get serviceaccounts -n default
kubectl get role -n default
kubectl get rolebindings.rbac.authorization.k8s.io -n default 
```

![image](https://github.com/user-attachments/assets/07112101-ed92-491c-b312-f572bf10f1ba)

### Step 2: Create the Token for the Service account

```bash
  kubectl create token <service-account-name> >> token-svc.txt
```

![image](https://github.com/user-attachments/assets/0e20a75e-c205-4f7a-8811-a3ca1f99aea5)

### Step 3: Test the Token

```bash
kubectl auth can-i delete pod --as=system:serviceaccount:default:my-svc-acc
```
![image](https://github.com/user-attachments/assets/e7d9dfb4-3a11-457b-9198-6f3938bed4cd)

### Step 4: Comparison

| Feature             | Service Account            |     Role & RoleBinding		     | ClusterRole & ClusterRoleBinding                                               |
|---------------------|-----------------------------------|----------------------------------------|-----------------------------------------------------------|
| **Definition**      | Provides an identity for processes running in a pod.	|Grants permissions within a specific namespace.	| Grants permissions across all namespaces in the cluster.|
| **Scope**    | Namespace-specific.		              | Namespace-specific.	                     | Cluster-wide.                          |
| **Use Case**          | Used for pod-to-API communication or specific automation tasks.	         	|	Restrict actions on resources like pods, secrets, or configmaps in a single namespace.	         | Used for cluster-wide permissions (e.g., node management, persistent volume access).            |
| **Binding Mechanism**   | A Service Account used by a Jenkins pod to access Kubernetes resources.			|	Granting read-only access to pods in a namespace for a specific user.      | Granting admin access to all nodes or global secrets across namespaces. |
| **Examples**        | Pre-created or dynamically provisioned storage.	|	For pods to request storage via claims.| Simplifies dynamic provisioning of storage. |
