# The Nixer System

This repository manages the configuration for my entire digital life, unifying my ThinkPad T14 (NixOS) and my Chromebooks (Debian/Home Manager) into a single, synchronized system.

## 🚀 Setup Guide

Choose your path based on the machine you are setting up.

# Option A: Fresh NixOS Installation ("Scorched Earth")

This guide outlines the steps for a complete wipe and fresh installation of NixOS, ensuring a clean partition table and human-readable filesystem labels.

### 1. Prepare Boot Media
* Flash a USB drive with the latest NixOS ISO.
* **BIOS Settings:** Ensure "Secure Boot" is disabled in your BIOS/UEFI settings before proceeding.

### 2. Launch Installer
* Boot from the USB drive.
* Connect to Wi-Fi/Ethernet.
* Launch the **NixOS Installer** from the desktop.

### 3. Configure Basics
* Follow the wizard for Language, Region, Keyboard, and User setup.
* **Stop** when you reach the **Partitions** screen.

### 4. Manual Partitioning
Select **Manual Partitioning** and create a **New Partition Table (GPT)**. Create the following two partitions exactly as described:

| Partition | Size | File System | Label | Mount Point | Flags |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Boot** | `1024 MiB` | `FAT32` | `BOOT` | `/boot` | `boot`, `esp` |
| **Root** | (Remainder) | `ext4` | `nixos` | `/` | *(none)* |

> **Note:** Setting the "Label" in the installer saves you from doing it manually in the terminal later.

### 5. Install & Restart
* Complete the wizard and let the installation finish.
* **Remove the USB drive** when prompted.
* Restart the machine.

### 6. Login & Setup
* Log in to your fresh NixOS installation.
* Open a terminal.
* Clone your Nix configuration repository (ensure `git` is installed or use `nix-shell -p git`):
  ```bash
  git clone <your-repo-url> ~/nixer
  ```

### 7. Import Hardware Config
Copy the auto-generated hardware configuration into your repository (replacing the placeholder):

```bash
cp /etc/nixos/hardware-configuration.nix ~/nixer/hosts/t14/hardware.nix
```

### 8. Update to File System Labels
Open your new `hardware.nix` file. You will see hard-to-read UUIDs for your file systems. Replace them with the labels you created in Step 4.

**Find:**
```nix
fileSystems."/boot" = { device = "/dev/disk/by-uuid/XXXX-XXXX"; ... };
fileSystems."/" = { device = "/dev/disk/by-uuid/xxxxxxxx-xxxx..."; ... };
```

**Replace with:**
```nix
fileSystems."/boot" = {
  device = "/dev/disk/by-label/BOOT";
  fsType = "vfat";
};

fileSystems."/" = {
  device = "/dev/disk/by-label/nixos";
  fsType = "ext4";
};
```

### 9. Rebuild System
Apply your flake configuration to finalize the setup:

```bash
# Navigate to your flake directory
cd ~/nixer

# Rebuild (replace 't14' with your actual hostname)
sudo nixos-rebuild switch --flake .#t14
```


### Option B: Chromebook / Non-NixOS
*For setting up the 'penguin' container on ChromeOS.*

#### Step 1: Install Nix
Open the terminal and run the standard installer in Daemon mode.

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

*Close and reopen your terminal after this finishes.*

#### Step 2: Fix SSL Certificates
*ChromeOS containers have SSL paths that the isolated Nix Daemon cannot see. We must manually map Nix's own certificate bundle to the Daemon.*

1.  **Install Certificates:** Download the cert bundle into your user profile.
    ```bash
    nix-env -iA nixpkgs.cacert
    ```
2.  **Get the Path:** Run this to find where the certs live. **Copy the output.**
    ```bash
    readlink -f ~/.nix-profile/etc/ssl/certs/ca-bundle.crt
    ```
3.  **Configure Daemon:** Create the service override file.
    ```bash
    sudo mkdir -p /etc/systemd/system/nix-daemon.service.d/
    sudo nano /etc/systemd/system/nix-daemon.service.d/override.conf
    ```
4.  **Paste & Save:** Paste the following, replacing `YOUR_PATH_HERE` with the path you copied in Step 2.
    ```ini
    [Service]
    Environment="NIX_SSL_CERT_FILE=YOUR_PATH_HERE"
    Environment="CURL_CA_BUNDLE=YOUR_PATH_HERE"
    ```
    *(Save with `Ctrl+O`, Exit with `Ctrl+X`)*
5.  **Apply Fix:**
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl restart nix-daemon
    ```

#### Step 3: Enable Flakes
Turn on the modern Nix command features.

 ```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

#### Step 4: Clone the Repo
*If `git` is missing, we use Nix to install it temporarily.*

1.  **Ensure Git is installed:**
    ```bash
    nix-env -iA nixpkgs.git
    ```
2.  **Clone via HTTPS:** (We use HTTPS so you don't need SSH keys yet).
    ```bash
    git clone https://github.com/ChadCapra/nixer.git ~/nixer
    ```

#### Step 5: Bootstrap the System
This command downloads Home Manager and uses it to install itself and your entire configuration.

```bash
cd ~/nixer
nix run home-manager/master -- switch --flake .#penguin
```

---

## 🔐 Post-Installation: SSH Setup
Now that your system is running, you should set up SSH keys so you can push changes back to GitHub.

1.  **Generate a new key** (if you don't have one):
    ```bash
    ssh-keygen -t ed25519 -C "chadcapra@gmail.com"
    ```
2.  **Add to GitHub:** Copy the key and add it to your GitHub Settings -> SSH Keys.
    ```bash
    cat ~/.ssh/id_ed25519.pub
    ```
3.  **Switch Repo to SSH:**
    ```bash
    cd ~/nixer
    git remote set-url origin git@github.com:ChadCapra/nixer.git
    ```

---

## 🛠 Usage

This system uses a smart alias to handle updates on any machine.

* **Update System:**

```bash
rebuild
```

*On T14: Automatically runs `nixos-rebuild`*

*On Chromebook: Automatically runs `home-manager switch`*
