# Lab 25: Role-based Authorization  

## Objective  
- Create two users: **user1** and **user2**.  
- Assign the **admin** role to **user1**.  
- Assign the **read-only** role to **user2**.  

---

## Prerequisites  

1. **Set Up Jenkins**: Ensure Jenkins is installed and running.  
2. **Install Role-Based Authorization Plugin**:  
   - Go to **Jenkins Dashboard > Manage Jenkins > Plugin Manager**.  
   - Install the **Role-Based Authorization Strategy** plugin.  

![image](https://github.com/user-attachments/assets/8050998e-bfc1-4d51-83c8-58ec9c60983d)

---

## Steps  

### 1. Configure Role-Based Authorization  

1. **Switch Authorization Strategy**:  
   - Navigate to **Jenkins Dashboard > Manage Jenkins > Security**.  
   - Under **Authorization**, select **Role-Based Strategy**.  
   - Save the changes.
      
![image](https://github.com/user-attachments/assets/aa6d3e1c-d0f3-4eb7-b7d2-7722c396913e)

2. **Access Role Management**:  
   - Go to **Manage Jenkins > Manage and Assign Roles > Manage Roles**.  

---

### 2. Create Roles  

1. **Admin Role**:  
   - Add a role named `admin`.  
   - Under **Permissions**, enable all permissions.  

2. **Read-Only Role**:  
   - Add a role named `read-only`.  
   - Enable only view-related permissions, such as:  
     - **Overall**: Read  
     - **Job**: Read  
     - **View**: Read
       
![image](https://github.com/user-attachments/assets/d392c705-8ce6-4214-8352-b4da338adaa4)

---

### 3. Create Users  

1. **Add Users**:  
   - Navigate to **Manage Jenkins > Manage Users**.  
   - Add the following users:  
     - **user1**: Admin role  
     - **user2**: Read-only role  

![image](https://github.com/user-attachments/assets/a9710a5c-3951-4852-b266-13354fd31ff4)

---

### 4. Assign Roles to Users  

1. **Assign Roles**:  
   - Go to **Manage Jenkins > Manage and Assign Roles > Assign Roles**.  
   - Assign the `admin` role to **user1**.  
   - Assign the `read-only` role to **user2**.  

![image](https://github.com/user-attachments/assets/17c05c66-29b4-48e7-a6da-6d57b75c1e43)

---

### 5. Test User Permissions  

1. **Test user1**:  
   - Log in as **user1**.  
   - Verify full access to all Jenkins functionalities.  

2. **Test user2**:  
   - Log in as **user2**.  
   - Verify restricted access, only to view and read resources. 

![image](https://github.com/user-attachments/assets/f2db2eb1-fd78-4119-9cb7-cf2fb0557fb6)

   - He can't Build just read
---

### Notes  

- Ensure that the `admin` role has full permissions to manage Jenkins.  
- Use descriptive role names for clarity in larger setups.  
- Regularly review roles and permissions for security compliance.  
