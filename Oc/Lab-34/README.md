# Lab 34: DaemonSets & Taint and Toleration

## **Objective**
This lab demonstrates the usage of DaemonSets, taints, tolerations, and their role in Kubernetes scheduling.

---

## **What is a DaemonSet and its Use Case?**
A **DaemonSet** ensures that a copy of a specific Pod runs on all (or some) nodes in the cluster. It is typically used for:
- Running system-level services such as log collectors, monitoring agents, or networking components.
- Ensuring each node has a copy of the specified pod to manage tasks node-wide.

---

## **Solution Steps**

### **Step 1: Create a DaemonSet File for Nginx**
1. Create a YAML file (`nginx-daemonset.yaml`) with the following content:

    ```yaml
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: nginx-daemonset
      labels:
        app: nginx
    spec:
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

2. Apply the file:

    ```bash
    kubectl apply -f nginx-daemonset.yaml
    ```

3. Verify the number of Pods running:

    ```bash
    kubectl get pods -o wide
    ```
    ![image](https://github.com/user-attachments/assets/3ba2bf62-82dd-496c-825c-31a7bf626bff)

### **Step 2: Taint the Minikube Node**
1. Add a taint to the Minikube node:

    ```bash
    kubectl taint nodes minikube color=red:NoSchedule
    ```

2. Verify the taint is applied:

    ```bash
    kubectl describe node minikube | grep Taints
    ```
    ![image](https://github.com/user-attachments/assets/fd5203ff-e91b-496f-ba99-ed23f9f113b7)

### **Step 3: Create a Pod with a Toleration**
1. Create a YAML file (`toleration-pod.yaml`) for the pod:

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: toleration-pod
    spec:
      containers:
      - name: nginx
        image: nginx:latest
      tolerations:
      - key: "color"
        operator: "Equal"
        value: "blue"
        effect: "NoSchedule"
    ```

2. Apply the file:

    ```bash
    kubectl apply -f toleration-pod.yaml
    ```

3. Observe the status of the Pod:

    ```bash
    kubectl get pods
    ```
- It will be in the pending state because it doesn't match the tain of the minikube node

  ![image](https://github.com/user-attachments/assets/19cde234-fabc-404b-9fa0-5f13305aa27e)

### **Step 4: Update the Toleration to Match the Taint**
1. Edit the YAML file to update the toleration value to `red`:

    ```yaml
    tolerations:
    - key: "color"
      operator: "Equal"
      value: "red"
      effect: "NoSchedule"
    ```

2. Reapply the updated file:

    ```bash
    kubectl apply -f toleration-pod.yaml
    ```

3. Verify that the Pod is now scheduled on the tainted node:

    ```bash
    kubectl get pods -o wide
    ```
- Now It's on running state because it matches the taint of the Node

  ![image](https://github.com/user-attachments/assets/287aef1f-9573-4cfd-8866-caf07e3537c3)

### **Step 5: Comparison of Taint, Toleration, and Node Affinity**

| **Aspect**          | **Taint**                                                                 | **Toleration**                                                       | **Node Affinity**                                                                 |
|---------------------|---------------------------------------------------------------------------|------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| **Definition**      | Marks a node with restrictions on which Pods can run there.              | Allows Pods to tolerate specific taints and get scheduled on tainted nodes. | Expresses Pod scheduling preferences to certain nodes based on their labels.     |
| **Purpose**         | Prevents Pods from being scheduled unless tolerated.                    | Enables Pods to run on tainted nodes.                                   | Places Pods on nodes matching specific labels.                                   |
| **Scope**           | Applied at the node level.                                               | Applied at the Pod level.                                              | Applied at the Pod level to match node labels.                                   |
| **Key Use Case**    | Reserve nodes for specific workloads or purposes.                       | Allows exceptions to taints for certain Pods.                          | Ensures Pods run on nodes with specific characteristics.                         |

---

## **Conclusion**
This lab covered:
1. The creation of a DaemonSet to run Nginx Pods on all nodes.
2. Application of taints and tolerations to control Pod scheduling.
3. A detailed comparison of Taint, Toleration, and Node Affinity.
