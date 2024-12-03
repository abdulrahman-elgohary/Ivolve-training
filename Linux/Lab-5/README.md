# Lab 5: Disk Management and Logical Volume Setup  

## Objective  
Attach a 15GB disk to your VM, partition it into 5GB, 5GB, 3GB, and 1.5GB sections. Use the first 5GB partition as a file system, configure the 1.5GB partition as swap, initialize the second 5GB as a Volume Group (VG) with a Logical Volume (LV), then extend the LV by adding the 3GB partition.

---

## Steps  

### 1. Attach a 15GB Disk to the VM  
Attach the disk using your virtualization platform (VirtualBox, VMware, etc.).  
- Go to the setting of the Virtual machine and add a new hard disk with 15 GB.

  ![image](https://github.com/user-attachments/assets/ab831972-dcf0-4709-b646-6b4a0b7a242a)

- Restart your machine if you made the previous step while the machine was on.

  ![image](https://github.com/user-attachments/assets/e2d88c37-102b-4058-bf8b-e1aca74d2955)

---

### 2. Partition the Disk  

1. Partition the disk:  
    ```bash
    sudo fdisk /dev/sdX  # Replace 'X' with the correct disk letter
    ```  

    - Create four primary partitions as follows:  
      - **Partition 1**: 5GB  
      - **Partition 2**: 5GB  
      - **Partition 3**: 3GB  
      - **Partition 4**: 1.5GB  

2. Verify the partitions:  
    ```bash
    sudo fdisk -l /dev/sdX
    ```
    ![image](https://github.com/user-attachments/assets/4a1e7ca9-d184-43b7-855b-260537487f48)

---

### 3. Format the First 5GB Partition  

1. Format the partition with an ext4 file system:  
    ```bash
    sudo mkfs.ext4 /dev/sdX1
    ```
    ![image](https://github.com/user-attachments/assets/d8d0ebf3-3ec6-49d9-8a4d-2fac5f02a598)

2. Mount the partition (Persistence):  
    ```bash
    sudo mkdir /mnt/data1
    ```
    ```bash
    sudo bash -c 'echo "UUID="f869152d-6798-42a1-9cec-5dd8fa9a7c8e"  /mnt/data1   ext4 defaults 0 0" >> /etc/fstab'
    ```
---

### 4. Configure the 1.5GB Partition as Swap  

1. Initialize the swap partition:  
    ```bash
    sudo mkswap /dev/sdX4
    ```
    ![image](https://github.com/user-attachments/assets/3c3161b0-b104-4e12-bb83-37889320e4c1)

2. Enable the swap with persistent mounting:  
    ```bash
    sudo bash -c 'echo "UUID="f17a4733-6535-4e30-9200-994214d1b681"  none      swap  defaults 0 0" >> /etc/fstab'
    ```
    ![image](https://github.com/user-attachments/assets/c8829dff-5d87-4b76-9ea1-e74c6be502ec)
    - Mount the partitions 
    ```bash
    sudo mount -av
    ```
    ![image](https://github.com/user-attachments/assets/eb821433-18fd-4834-beb7-1b1009a754d8)

---

### 5. Create a Volume Group and Logical Volume  

1. Initialize the second 5GB partition as a physical volume:  
    ```bash
    sudo pvcreate /dev/sdX2
    ```
    ![image](https://github.com/user-attachments/assets/9a62d4df-9ca3-419d-8c84-da29819ff948)

2. Create a Volume Group (VG):  
    ```bash
    sudo vgcreate vg_ivolve /dev/sdX2
    ```
    ![image](https://github.com/user-attachments/assets/8b1aae42-66d8-4d52-9a78-c48e5576c66f)

3. Create a Logical Volume (LV):  
    ```bash
    sudo lvcreate -L +100%FREE -n lv_ivolve vg_ivolve
    ```
    ![image](https://github.com/user-attachments/assets/81617729-ad1f-4553-84d8-13f19ac401ce)

4. Format the LV:  
    ```bash
    sudo mkfs.ext4 /dev/vg_ivolve/lv_ivolve
    ```
    ![image](https://github.com/user-attachments/assets/ee38b81b-4fc3-4b00-b3ef-3d70acae9895)

5. Mount the LV (Persistent):
    - Create a directory to be the mount point.
   ```bash
    sudo mkdir /mnt/lv_data
    ```
    - Add the following entry to /etc/fstab to make the mount persistent. 
    ```bash
    sudo bash -c 'echo "UUID="a0e1b070-a9cc-4d3d-ab38-2a60b839a2cd" /mnt/lv_data  ext4 defaults 0 0" >> /etc/fstab'
    ```
    ![image](https://github.com/user-attachments/assets/0e2b9a29-d945-49ae-bb04-656687ac31dd)

    ```bash
    sudo mount -av
    ```
    ![image](https://github.com/user-attachments/assets/e7a112e0-b1be-4e78-9856-2dd271cac6bc)
   
   - Visualize the disk structure.
   ```bash
    lsblk
    ```
    ![image](https://github.com/user-attachments/assets/7c9f71fc-6456-4dda-b5ab-b4fcd9eb1da5)


---

### 6. Extend the Logical Volume  

1. Add the 3GB partition to the VG:  
    ```bash
    sudo pvcreate /dev/sdX3
    sudo vgextend vg_ivolve /dev/sdX3
    ```
    ![image](https://github.com/user-attachments/assets/904daef8-ddd1-4a70-a961-1750860bac99)

2. Extend the LV:  
    ```bash
    sudo lvextend -l +100%FREE /dev/vg_ivolve/lv_ivolve
    ```
    ![image](https://github.com/user-attachments/assets/8be55d5a-1e72-4268-b22c-5c83246c7cb0)

3. Resize the file system:  
    ```bash
    sudo resize2fs /dev/vg_ivolve/lv_ivolve
    ```
    ![image](https://github.com/user-attachments/assets/9d400338-e328-4fdd-bb82-71f25b963008)

---

## Notes  
- Replace `/dev/sdX` with the correct device name.  
- Use `lsblk` to visualize the disk structure.  
- Make entries in `/etc/fstab` for persistent mounting after reboot.  


