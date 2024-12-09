# Lab 8: Ansible Playbooks for Web Server Configuration  

## Objective  
Write an Ansible playbook to automate the configuration of a web server, including installation and basic setup.

---

## Steps  

### 1. Create the Ansible Playbook  

1. **Navigate to your Ansible project directory**:  
    ```bash
    cd ~/Lab-8
    ```

2. **Create a playbook file (`webserver.yml`)**:  
    ```bash
    vim webserver.yml
    ```

3. **Write the playbook**:  
    ```yaml
    ---
    - name: Playbook to configure a web server
      hosts: aws
      become: true
    
      tasks:
    
        - name: Update Repository Cache
          ansible.builtin.apt:
            update_cache: yes
    
        - name: Install Nginx
          ansible.builtin.apt:
            name: nginx
            state: present
    
        - name: Verfiy that Nginx is up and running
          ansible.builtin.service:
            name: nginx
            enabled: true
            state: started
    
        - name: Adding a new index.html file
          ansible.builtin.copy:
            content: "<h1> Ansible has configured this web server </h1>"
            dest: /var/www/html/index.html
            mode: '0644'
 

---

### 2. Run the Playbook  

Execute the playbook on the managed hosts:  
```bash
ansible-playbook webserver.yml
```
![image](https://github.com/user-attachments/assets/0ca7d580-705a-490f-9db0-379e3b4bba75)

### 3. Verify the Web Server

- Check Nginx status on the managed hosts:
```bash
ansible aws -b -a "systemctl status nginx"
```
![image](https://github.com/user-attachments/assets/6ff51df7-8059-4490-aea1-c639d66b9549)

- Access the web server: Open a browser and navigate to http://<server_ip> to verify the custom welcome page.
- Server 1
  
  ![image](https://github.com/user-attachments/assets/399333da-b055-4d67-880c-ba53955b2d4b)
  
- Server 2
  
  ![image](https://github.com/user-attachments/assets/e17b4099-bcff-4d17-b5d4-b88955ac9296)


