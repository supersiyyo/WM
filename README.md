# WM: Raspberry Pi 5 Configuration

This repository tracks the system-level configurations and scripts required to set up the WM environment on a clean Raspberry Pi 5.

## Project Structure

- `autostart/` - Contains `.desktop` files that launch applications automatically on boot.
- `nginx/` - Contains the Nginx web server configuration (`nginx.conf`).
- `scripts/` - Custom shell scripts used by the system (e.g., `start_vnc_scraper.sh`).
- `install.sh` - Automated deployment script.

## Setup Instructions

### Pre-requisites
1. A Raspberry Pi 5 running a compatible OS (e.g., Raspberry Pi OS).
2. `nginx` installed (`sudo apt install nginx`).
3. Any other dependencies required by the autostart applications (like OBS).

### Installation

1. **Clone this repository** to the Raspberry Pi:
   ```bash
   git clone <your-repo-url>
   cd WM
   ```

2. **Run the installation script**:
   ```bash
   ./install.sh
   ```

### What does `install.sh` do?
The installation script automates the deployment by:
1. Copying the `.desktop` files from `autostart/` into `~/.config/autostart/`
2. Copying `start_vnc_scraper.sh` into `~/scripts/` and making it executable.
3. Using `sudo` to copy the `nginx.conf` file into `/etc/nginx/`, testing the config, and restarting the `nginx` service.

## Making Changes
If you update any files on your Raspberry Pi locally (e.g. in `~/.config/autostart/` or `/etc/nginx/`), be sure to copy those changes back to this repository and push them so that others can benefit from the updates!
