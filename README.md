# The Nixer System

This repository manages the configuration for my entire digital life, unifying my ThinkPad T14 (NixOS) and my Chromebooks (Debian/Home Manager) into a single, synchronized system.

## 🚀 Setup Guide

Choose your path based on the machine you are setting up.

---

### Option A: Fresh NixOS Installation ("Scorched Earth")

This guide outlines the steps for a complete wipe and fresh installation of NixOS, ensuring a clean partition table and human-readable filesystem labels.

**1. Prepare Boot Media**
* Flash a USB drive with the latest NixOS ISO.
* **BIOS Settings:** Ensure "Secure Boot" is disabled in your BIOS/UEFI settings before proceeding.

**2. Launch Installer**
* Boot from the USB drive.
* Connect to Wi-Fi/Ethernet.
* Launch the **NixOS Installer** from the desktop.

**3. Configure Basics**
* Follow the wizard for Language, Region, Keyboard, and User setup.
* **Stop** when you reach the **Partitions** screen.

**4. Manual Partitioning**
Select **Manual Partitioning** and create a **New Partition Table (GPT)**. Create the following two partitions exactly as described:

| Partition | Size | File System | Label | Mount Point | Flags |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Boot** | `1024 MiB` | `FAT32` | `BOOT` | `/boot` | `boot`, `esp` |
| **Root** | (Remainder) | `ext4` | `nixos` | `/` | *(none)* |

> **Note:** Setting the "Label" in the installer saves you from doing it manually in the terminal later.

**5. Install & Restart**
* Complete the wizard and let the installation finish.
* **Remove the USB drive** when prompted.
* Restart the machine.

**6. Login & Clone**
* Log in to your fresh NixOS installation.
* Open a terminal.
* Clone your Nix configuration repository (NixOS includes `git` in the installation environment):
```bash
git clone https://github.com/ChadCapra/nixer.git ~/nixer
```

**7. Import Hardware Config**
Copy the auto-generated hardware configuration into your repository (replacing the placeholder).
```bash
cp /etc/nixos/hardware-configuration.nix ~/nixer/devices/ACME-LT-HQ-001.nix
```
*(Note: Rename the file to match your actual device's logical ID).*

**8. Update to File System Labels**
Open your new hardware file. Replace the hard-to-read UUIDs for your file systems with the labels you created in Step 4.

**Find:**
```nix
fileSystems."/" = { device = "/dev/disk/by-uuid/xxxxxxxx-xxxx..."; ... };
fileSystems."/boot" = { device = "/dev/disk/by-uuid/XXXX-XXXX"; ... };
```

**Replace with:**
```nix
fileSystems."/" = { device = "/dev/disk/by-label/nixos"; ... };
fileSystems."/boot" = { device = "/dev/disk/by-label/BOOT"; ... };
```

**9. Execute the Nixer Engine**
Run the native setup command to compile your system constraints and activate your profile.
```bash
~/nixer/bin/nixer setup
```

---

### Option B: Chromebook / Non-NixOS (Guest Environments)

Use this method for fresh guest OS environments (ChromeOS Crostini, WSL, Ubuntu) to establish the system without polluting the host package manager.

**1. Install the Nix Package Manager**
```bash
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
```
*(Note: Close and reopen your terminal after this finishes so your shell recognizes the `nix` command).*

**2. Clone the Repository Ephemerally**
Use Nix to temporarily download Git, clone the repository, and vanish without leaving a trace:
```bash
nix shell nixpkgs#git -c git clone https://github.com/ChadCapra/nixer.git ~/nixer
```

**3. Execute the Nixer Engine**
Run the native setup command to compile your system constraints, bridge your environment (GPU, SSL), and activate your profile.
```bash
~/nixer/bin/nixer setup
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

This system uses a unified CLI to manage the entire infrastructure lifecycle. Because the `~/nixer/bin` path is automatically injected into your environment, you can run these commands from anywhere.

```bash
# 1. Apply configuration changes (Runs nixos-rebuild or home-manager dynamically)
nixer rebuild

# 2. Delete old system generations and optimize disk space
nixer sweep

# 3. List all declaratively managed packages currently installed
nixer inventory
```
