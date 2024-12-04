# Lab 10: Ansible Roles for Applications Deployment  

## Objective  
Organize Ansible playbooks using roles. Create an Ansible role to install `Jenkins`, `Docker`, and OpenShift CLI (`oc`).

---

## Steps  

### 1. Create the Ansible Role  

1. **Create the roles** :
   
    ```bash
    mkdir roles
    ```

2. **Directory structure** after creation:  
    ```plaintext
    roles/
    ├── pre_installation
    │    └── tasks
    │      └── main.yml
    ├── docker
    │    └── tasks
    │      └── main.yml
    ├── jenkins
    │    └── tasks
    │      └── main.yml
    ├── oc
    │    └── tasks
    │      └── main.yml
   
    ```

---

### 2. Define Role Tasks  

1. **Edit the `main.yml` file for `pre_installation` role**:  
    ```bash
    vim roles/pre_installation/tasks/main.yml
    ```
2. **Add tasks for installing required packages first**:
   
   ```yaml
   ---
    - name: Update the system
      ansible.builtin.apt:
        update_cache: yes


    - name: Install necessary packages
      ansible.builtin.apt:
        name: "{{ item }}"
        state: latest
      loop:
        - openjdk-17-jdk            #This package is necessary for Jenkins
        - apt-transport-https       #Allowing Download Over HTTPS
        - ca-certificates           #Ensures SSL/TLS
        - curl
        - software-properties-common #Allows Adding Repository easily

    ```

3. **Edit the `main.yml` file for `docker` role**:
   
   ```yaml
   ---
    - name: Adding Docker Repo Key
      ansible.builtin.shell: |
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /usr/share/keyrings/docker-keyring.asc > /dev/null
    
    - name: Adding Docker Repository
      ansible.builtin.apt_repository:
        repo: "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-keyring.asc] https://download.docker.com/linux/ubuntu focal stable"
    
    - name: Installing Docker
      ansible.builtin.apt:
        name: docker-ce
        state: present

    ```

4. **Edit the `main.yml` file for `jenkins` role**:
   
   ```yaml
   ---
    - name: Add Jenkins repository key
      ansible.builtin.apt_key:
        url: https://pkg.jenkins.io/debian/jenkins.io-2023.key
        state: present
    
    - name: Add Jenkins repository
      ansible.builtin.apt_repository:
        repo: 'deb https://pkg.jenkins.io/debian binary/'
        state: present
      notify: update_cache
    
    - name: Update Cache
      ansible.builtin.apt:
        update_cache: yes
    
    - name: Install Jenkins
      ansible.builtin.apt:
        name: jenkins
        state: present
    
    
    - name: Start and enable Jenkins
      ansible.builtin.service:
        name: jenkins
        state: started
        enabled: true
    
    
    - name: Allow traffic on Jenkins port (8080)
      ansible.builtin.ufw:
        rule: allow
        port: 8080
        proto: tcp
    
       
5. **Edit the `main.yml` file for `oc` role**:
   
   ```yaml
   ---
    - name: Downloading Openshift CLI
      ansible.builtin.get_url:
        url: https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
        dest: /tmp/oc.tar.gz
    
    - name: Extracting and moving the Binary
      ansible.builtin.unarchive:
        src: /tmp/oc.tar.gz
        dest: /usr/local/bin
        remote_src: yes
    

    ```

---

### 3. Create a Playbook to Use the Role  

1. **Create a playbook file (`playbook.yml`)**:  
    ```bash
    vim playbook.yml
    ```

2. **Add the role to the playbook**:  
    ```yaml
    ---
    - name: A playbook to install Docker and Jenkins and OpenShift CLI using Roles
    hosts: aws
    become: true
  
  
    roles:
      - pre_installation
      - docker
      - jenkins
      - oc

    ```
---

### 4. Run the Playbook  

Execute the playbook:  
```bash
ansible-playbook playbook.yml
```
![image](https://github.com/user-attachments/assets/8c7384d2-e28a-47ae-8e23-b6b3e0ebe7c6)

### 4. Verify that `Docker` runs
- Replace aws with your group or hosts.
  
```bash
ansible aws -a "docker ps" --become
```
![image](https://github.com/user-attachments/assets/3d035c00-f272-48e1-9091-821f5cdc0043)

### 5. Verify that `Jenkins` runs
- Replace aws with your group or hosts.

```bash
ansible aws -a "jenkins --version"
```
![image](https://github.com/user-attachments/assets/36af0cfb-923e-48a6-8884-9d5108843616)

### 6. Verify that `oc cli` runs
- Replace aws with your group or hosts.
  
```bash
ansible aws -a "oc version"
```
![image](https://github.com/user-attachments/assets/3e879b7b-96d3-48be-8941-8fa04a573ecf)
