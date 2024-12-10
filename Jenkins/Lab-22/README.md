# Lab 22: Jenkins Installation  

## Objective  

Install Jenkins as a container.  

---

## Steps  

#### 1. Pre-requisites  

- **Update System Packages**
   
```bash
sudo apt update -y
```
- **Install Docker**
  
```bash
sudo apt install docker.io -y
```
### 2. Start Installing Jenkins

1. **Pull Jenkins Image**
  
```bash
sudo docker pull jenkins/jenkins:lts
```
2. **Run Jenkins Container**

```bash
sudo docker run -d -p 8080:8080 -p 50000:50000 \
--name jenkins \
-v jenkins_home:/var/jenkins_home \
jenkins/jenkins:lts
```
3. **Verfiy Container is running**

```bash
sudo docker ps
```
![image](https://github.com/user-attachments/assets/3e3f5021-916e-4c4a-907d-055f1f6bd587)

### 3. Configure Jenkins

1. **Access Jenkins Web Interface**

- Open a browser and navigate to http://<server-ip>:8080.

2. **Retrieve Admin Password**

```bash
sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
3. **Complete the Setup Wizard**

- Use the retrieved password to log in.
- Install recommended plugins and set up your admin account.
- If you are using a virtual machine you have to add the IP server to your hosts in local machine
  
![image](https://github.com/user-attachments/assets/c7156fb9-1d79-452d-b939-549d5af23c7e)
