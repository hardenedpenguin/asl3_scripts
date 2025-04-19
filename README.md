These scripts can be used in conjunction with asl3 and other applications such as hamclock.

1) Supermon2 Mod
   
   If you have grown fond of the Supermon2 and how node info is displayed, we have you covered
   ```
   wget https://raw.githubusercontent.com/hardenedpenguin/asl3_scripts/refs/heads/main/supermon2_mod.sh
   ```
   Next make script executable so we can run it
   ```
   chmod +x supermon2_mode.sh
   ```
   The script will download the patch, apply it, open up node_info.ini to be edited, create the cron job and finally cleanup the downloaded patch
   ```
   sudo ./supermon2_mod.sh
   ```
2) Embedded Hamclock
   
   The hamclock script will only patch in support for Hamclock being embedded to Supermon on ASL3+ If you want a script to setup hamclock we have that covered in another repository.
   It can be found in the install_hamclock repository https://github.com/hardenedpenguin/install_hamclock, must be installed before we patch the embedded portions in.

   ```
   wget https://raw.githubusercontent.com/hardenedpenguin/asl3_scripts/refs/heads/main/embedded_hamclock_supermon.sh
   ```
   Make script exectuable
   ```
   chmod +x embedded_hamclock_supermon.sh
   ```
   Now run the script
   ```
   sudo ./embedded_hamclock_supermon.sh
   ```
