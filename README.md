# ASL3 Scripts

![Supermon2 with Embedded Hamclock](https://github.com/hardenedpenguin/asl3_scripts/blob/main/supermon2_mod%2Bhamclock.png)

---
These scripts are designed for use with [ASL3 (AllStarLink)](https://www.allstarlink.org/) and can enhance your setup by integrating with applications such as **Supermon** and **Hamclock**.

## 1. Supermon2 Mod

If you’re a fan of Supermon2 and like how node info is displayed, this script is for you.

### 📥 Download the Script
```
wget https://raw.githubusercontent.com/hardenedpenguin/asl3_scripts/refs/heads/main/supermon2_mod.sh
```

### 🔧 Make It Executable
```
chmod +x supermon2_mod.sh
```

### 🚀 Run the Script
```
sudo ./supermon2_mod.sh
```

This script will:
- Download and apply the patch
- Open `node_info.ini` for editing
- Create the necessary cron job
- Clean up after completion

---

## 2. Embedded Hamclock Support

This script enables Hamclock to be embedded in Supermon (ASL3+). **Note:** It does not install Hamclock—just patches it into Supermon. If you need to install Hamclock first, visit our dedicated [install_hamclock repo](https://github.com/hardenedpenguin/install_hamclock).

### 📥 Download the Script
```
wget https://raw.githubusercontent.com/hardenedpenguin/asl3_scripts/refs/heads/main/embedded_hamclock_supermon.sh
```

### 🔧 Make It Executable
```
chmod +x embedded_hamclock_supermon.sh
```

### 🚀 Run the Script
```
sudo ./embedded_hamclock_supermon.sh
```

### ⚙️ Advanced Configuration (Reverse Proxy for Hamclock)

For users who experience issues accessing the embedded Hamclock dashboard, a reverse proxy can be configured. This is often helpful in more complex network setups.

1.  **Edit your Apache configuration file.** Typically, this is `/etc/apache2/sites-available/000-default.conf`. You'll need `sudo` privileges to edit this file.

    ```
    sudo nano /etc/apache2/sites-available/000-default.conf
    ```

2.  **Add the following proxy configurations within your \`<VirtualHost *:80>\` block:**

    ```
        # Proxy for HamClock content
        <Location /hamclock/>
            ProxyPass http://10.0.0.10:8082/
            ProxyPassReverse http://10.0.0.10:8082/
        </Location>

        # Proxy for WebSocket
        <Location /hamclock/live-ws>
            ProxyPass ws://10.0.0.10:8082/live-ws
            ProxyPassReverse ws://10.0.0.10:8082/live-ws
        </Location>
    ```

    **Note:** Replace `http://10.0.0.10:8082/` with the actual IP address.

3.  **Save the file and exit the editor.**

4.  **Restart the Apache service:**

    ```
    sudo systemctl reload apache2
    ```

After these steps, you should be able to access your embedded Hamclock dashboard through a URL like `http://your_server_ip/hamclock/live.html`.

**Important:** After successfully configuring the reverse proxy, you will need to edit the `/var/www/html/supermon/link.php` file to update the URL that points to your Hamclock interface. Change the URL at the bottom of the page to something like `http://your_server_ip/hamclock/live.html` to ensure it's accessible within Supermon.

---

## 💬 Support

If you wish to disable HamClock on your node and prevent it from running when rebooted, as your normal user:
```
crontab -e
```
You can comment out the line or remove it entirely, depending on your preference.

For issues or suggestions, feel free to open an issue or submit a pull request.
