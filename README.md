# The Nixer System

This repository manages the configuration for my entire digital life, unifying my ThinkPad T14 (NixOS) and my Chromebooks (Debian/Home Manager) into a single, synchronized system.

## 🚀 Setup Guide

Choose your path based on the machine you are setting up.

### Option A: NixOS (ThinkPad T14)
*For a fresh install on a dedicated Linux machine.*

1.  **Boot & Install:** Boot the NixOS ISO and perform a standard installation (graphic or minimal). I chose Plasma because it uses wayland and provides things out of the box like WiFi.
2.  **Install Git:**
    *Standard NixOS installs do not come with Git. We install it into the user environment temporarily.*
    ```bash
    nix-env -iA nixos.git
    ```
3.  **Clone the Repo:**
    ```bash
    git clone https://github.com/ChadCapra/nixer.git ~/nixer
    ```
4.  **Bootstrap the System:**
    *Since Flakes are not enabled by default, we must pass a special flag to enable them just for this first run. Your configuration will make it permanent afterwards.*
    ```bash
    cd ~/nixer
    sudo nixos-rebuild switch --flake .#t14 --option experimental-features 'nix-command flakes'
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
