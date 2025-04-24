# ASL3 Scripts
![Supermon2 with Embedded Hamclock](https://github.com/hardenedpenguin/asl3_scripts/blob/main/supermon2_mod%2Bhamclock.png)

---
These scripts are designed for use with [ASL3 (AllStarLink)](https://www.allstarlink.org/) and can enhance your setup by integrating with applications such as **Supermon** and **Hamclock**.

## 1. Supermon2 Mod

If you’re a fan of Supermon2 and like how node info is displayed, this script is for you.

### 📥 Download the Script
```bash
wget https://raw.githubusercontent.com/hardenedpenguin/asl3_scripts/refs/heads/main/supermon2_mod.sh
```

### 🔧 Make It Executable
```bash
chmod +x supermon2_mod.sh
```

### 🚀 Run the Script
```bash
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
```bash
wget https://raw.githubusercontent.com/hardenedpenguin/asl3_scripts/refs/heads/main/embedded_hamclock_supermon.sh
```

### 🔧 Make It Executable
```bash
chmod +x embedded_hamclock_supermon.sh
```

### 🚀 Run the Script
```bash
sudo ./embedded_hamclock_supermon.sh
```

---

## 💬 Support
If you wish to disable HamClock on your node and prevent it from running when rebooted, as your normal user
```
crontab -e
```
You can comment out the line and or remove it, this is totally up to you.

For issues or suggestions, feel free to open an issue or submit a pull request.
