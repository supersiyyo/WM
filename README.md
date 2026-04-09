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

## Camera Streaming Pipeline

This repository configures a lightweight, scalable camera streaming node utilizing a local Nginx RTMP server and FFmpeg.

### Hardware Stack
- **Camera**: Analog 1080p BNC Camera
- **Capture**: USB 3.0 MS2130-based Video Capture Card
- **Processing**: Raspberry Pi 5

### FFmpeg Optimizations
Since the Raspberry Pi 5 lacks a hardware H.264 encoder, the `start_camera_stream.sh` script applies specific best-practice optimizations for software encoding (`libx264`):
- `-input_format mjpeg`: Prevents the USB capture card from throttling framerates.
- `-preset ultrafast` & `-threads 4`: Distributes the encoding workload evenly across the Cortex-A76 cores.
- `-maxrate` & `-bufsize`: Strictly caps bandwidth to prevent CPU spiking.
- `-pix_fmt yuv420p`: Standardizes the color palette so network devices (like VLC) decode the stream flawlessly.

### How to View the Stream Locally
1. Find the Raspberry Pi's local IP address (`hostname -I`).
2. Open VLC Media Player on any computer on the same network.
3. Navigate to **Media** > **Open Network Stream...**
4. Paste the URL: `rtmp://<PI_IP_ADDRESS>:1935/live/camera`
5. Click **Play**!

## Making Changes
If you update any files on your Raspberry Pi locally (e.g. in `~/.config/autostart/` or `/etc/nginx/`), be sure to copy those changes back to this repository and push them so that others can benefit from the updates!
