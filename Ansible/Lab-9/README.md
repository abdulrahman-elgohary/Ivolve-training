# Lab 9: Ansible Vault  

## Objective  
Write an Ansible playbook to:  
1. Install MySQL.  
2. Create a database named `ivolve`.  
3. Create a user with all privileges on the `ivolve` database.  
4. Use Ansible Vault to encrypt sensitive information, such as the database user password, and incorporate it into the playbook.

---

## Steps  

### 1. Create an Ansible Vault File  

1. **Create a vault file to store the MySQL user password**:  
    ```bash
    ansible-vault create mysql_cred.yml
    ```

2. **Add the following content to the vault file** and save:  
    ```yaml
    db_name: ivolve
    db_user: ivolve_user
    db_password: 12345
    ```
    - The Content is encrypted until you decrypt the file using the vault password
   
      ![image](https://github.com/user-attachments/assets/1d029061-ef13-4b5a-b3e1-0435f8b09c28)

---

### 2. Create the Ansible Playbook  

1. **Create the playbook file (`Mysql.yml`)**:  
    ```bash
    vim mysql.yml
    ```

2. **Write the playbook**:  
    ```yaml
    ---
    - name: A Playbook to install mysql database and using vault to encrypt sensitive data
      hosts: aws
      become: true
    
      vars_files:
        - ./mysql_cred.yml
    
      tasks:
        - name: Install Mysql
          ansible.builtin.apt:
            name: mysql-server
            state: present
            update_cache: yes
    
    
        - name: Verfiy that mysql is up and running
          ansible.builtin.service:
            name: mysql
            enabled: true
            state: started
    
        - name: Create ivolve database and also create user with password and give him privileges
          ansible.builtin.shell: |
            mysql -u root -e "CREATE DATABASE IF NOT EXISTS {{ db_name }} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
            mysql -u root -e "CREATE USER IF NOT EXISTS '{{ db_user }}'@'%' IDENTIFIED BY '{{ db_pass }}';"
            mysql -u root -e "GRANT ALL PRIVILEGES ON {{ db_name }}.* TO '{{ db_user }}'@'%'; FLUSH PRIVILEGES;"

    ```

---

### 3. Encrypt the Playbook  

 - To encrypt the playbook file:
    
 ```bash
 ansible-vault encrypt Mysql.yml
 ```
  ![image](https://github.com/user-attachments/assets/3f5ed1aa-1973-4702-97c7-4022fd11f6c0)

### 4. Run the Playbook  

      
```bash
ansible-playbook Mysql.yml --ask-vault-pass
```

- You will not be able to run the playbook until you insert the vaul password
    
    ![image](https://github.com/user-attachments/assets/1be583dc-49ce-4311-b9d0-5e987dd67d7f)

