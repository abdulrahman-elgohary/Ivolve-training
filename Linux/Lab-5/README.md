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

    ```bash
    sudo mount -av
    ```
    
3. Verify swap:  
    ```bash
    sudo swapon --show
    ```

---

### 5. Create a Volume Group and Logical Volume  

1. Initialize the second 5GB partition as a physical volume:  
    ```bash
    sudo pvcreate /dev/sdX2
    ```

2. Create a Volume Group (VG):  
    ```bash
    sudo vgcreate my_vg /dev/sdX2
    ```

3. Create a Logical Volume (LV):  
    ```bash
    sudo lvcreate -L 4G -n my_lv my_vg
    ```

4. Format and mount the LV:  
    ```bash
    sudo mkfs.ext4 /dev/my_vg/my_lv
    sudo mkdir /mnt/my_lv
    sudo mount /dev/my_vg/my_lv /mnt/my_lv
    ```

---

### 6. Extend the Logical Volume  

1. Add the 3GB partition to the VG:  
    ```bash
    sudo pvcreate /dev/sdX3
    sudo vgextend my_vg /dev/sdX3
    ```

2. Extend the LV:  
    ```bash
    sudo lvextend -L+3G /dev/my_vg/my_lv
    ```

3. Resize the file system:  
    ```bash
    sudo resize2fs /dev/my_vg/my_lv
    ```

---

## Notes  
- Replace `/dev/sdX` with the correct device name.  
- Use `lsblk` to visualize the disk structure.  
- Make entries in `/etc/fstab` for persistent mounting after reboot.  

