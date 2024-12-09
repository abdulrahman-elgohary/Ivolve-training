# Lab 4: DNS and Network Configuration with Hosts File and BIND9  

## Objective  
Demonstrate the differences between using the hosts file and DNS for URL resolution. Modify the hosts file to resolve a URL to a specific IP address, 
then configure BIND9 as a DNS solution to resolve wildcard subdomains and verify resolution using `dig` or `nslookup`.  

### Example:  
- **Domain**: `name-ivolve.com`  
- **IP Address**: `192.168.1.10`  

---

## Steps  

### Part 1: Modifying the Hosts File  

1. Open the hosts file:  
    ```bash
    sudo nano /etc/hosts
    ```  

2. Add the following entry to resolve the domain `name-ivolve.com` to `192.168.1.10`:  
    ```bash
    192.168.1.10 name-ivolve.com
    ```  

3. Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).  

4. Test the resolution:  
    ```bash
    nslookup name-ivolve.com
    ```
    ![image](https://github.com/user-attachments/assets/69030bb1-bab6-4fb1-924d-891fdc53187e)

5. Add the following entry with wild card to the hosts file
  ```
  192.168.1.*    name-nti.com
  ```
    ![image](https://github.com/user-attachments/assets/4e86f8cf-7793-41f5-b010-9649db73913d)

6. Test the new DNS .. It will fail because hosts file can not handle wild cards
    ![image](https://github.com/user-attachments/assets/33785b47-a374-4d25-843d-a09fd97cc0c8)

---
### Part 2: Configuring BIND9 for Wildcard Subdomains on another server 

1. **Install BIND9**:  
    ```bash
    sudo apt update
    sudo apt install bind9
    ```

2. **Edit the BIND9 configuration**:  
    Open the zone configuration file:  
    ```bash
    sudo nano /etc/bind/named.conf.local
    ```  

    Add the following zone definition:  
    ```bash
    zone "name-ivolve.com" {
        type master;
        file "/etc/bind/db.name-ivolve.com";
    };
    ```

3. **Create the Zone File**:  
    ```bash
    sudo cp /etc/bind/db.local /etc/bind/db.name-ivolve.com
    ```  

    Edit the new zone file:  
    ```bash
    sudo nano /etc/bind/db.name-ivolve.com
    ```

    Update the contents as follows:  
    ```bash
    ;
    ; BIND data file for name-ivolve.com
    ;
    $TTL    604800
    @       IN      SOA     name-ivolve.com. root.name-ivolve.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
    ;
    @       IN      NS      ns1.name-ivolve.com.
    @       IN      A       192.168.1.10
    *       IN      A       192.168.1.10
    ```

4. **Restart BIND9**:  
    ```bash
    sudo systemctl restart bind9
    ```
    
5. **Add the IP of this Bind Server to the first Server**:
   This will make the first server able to resolve any subdomain ending with the same domain because it will resolve it from the Bind server
   ```bash
    sudo vim /etc/resolv.conf
   ```
   ```   
   nameserver 192.168.199.135 #IP of Bind Server
   ```
7. **Test DNS Resolution**:  
    Use `dig` or `nslookup` to verify:  
    ```bash
    dig name-ivolve.com
    dig subdomain.name-ivolve.com
    nslookup name-ivolve.com
    nslookup subdomain.name-ivolve.com
    ```
    ![image](https://github.com/user-attachments/assets/2e6ba159-c49d-4018-8e57-f3158710572d)

All the URL that share the same domain name will no be resolved 
---
# I created a script to automate the process, eliminating the need to run each command manually.



