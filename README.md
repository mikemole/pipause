# 📡 PiPause — Physical Button to Pause Pi-hole

**PiPause** is a simple Raspberry Pi-based hardware button that temporarily **pauses Pi-hole's DNS blocking** for a fixed duration (default: 60 minutes). Pressing the button again **resumes blocking early**. It uses:

- A **GPIO button** for input
- An **LED** to indicate pause status
- The official Pi-hole API with app-password authentication
- A `systemd` service to run automatically on boot
- An isolated Python virtual environment

---

## ✨ Features

- 🛑 One-press DNS blocking pause
- 🔄 Auto-resume after set time
- 🔘 Press again to resume early
- 💡 LED indicator shows pause status
- 🔒 Secure app-password authentication
- 📦 Installed as a service with a virtualenv
- 🔧 Fully configurable and easy to uninstall

---

## 🛠️ Hardware Requirements

- Raspberry Pi (any model with GPIO support)
- Tactile pushbutton (connected to GPIO pin 2)
- LED + resistor (connected to GPIO pin 17)

---

## 📥 Installation

1. **Clone the repo** on your Raspberry Pi:

   ```bash
   git clone https://github.com/yourusername/pipause.git
   cd pipause
   ```

2. Make the install script executable:

   ```bash
   chmod +x install.sh
   ```
   
3. Run the install script:

   ```bash
   ./install.sh
   ```
You'll be prompted to enter your **Pi-hole API key** (see below to generate it).

---

## 🔐 How to Generate Your Pi-hole API Key (App Password)
1. Visit your Pi-hole Admin UI: http://pi.hole/admin
2. Go to **Settings > API / Web interface**
3. Under "**API Token / App password**", click "**Show API token**" or generate a new **app password**
4. Use that value when prompted during installation

📚 Official Pi-hole docs:
👉 https://docs.pi-hole.net/core/api/

❗ This project uses the modern app password system, not the deprecated legacy token (&auth= method).

---

## 🚫 Uninstallation
To fully remove the service and all files:

1. Make the uninstall script executable:
   ```bash
   chmod +x uninstall.sh
   ```

2. Run the script:
   ```bash
   ./uninstall.sh
   ```

This will:

* Stop and disable the service
* Remove /opt/pipause
* Remove the systemd unit

--- 

## ✅ Checking That It’s Working

After installation:
   ```bash
   sudo systemctl status pipause.service
   ```
You should see output like:
```
● pipause.service - Pi-hole Pause Button Service
   Loaded: loaded (/etc/systemd/system/pipause.service; enabled)
   Active: active (running)
```

---
## 📄 View Logs

To monitor logs live:
   ```bash
   journalctl -u pipause.service -f
   ```
To view recent logs:
   ```bash
   journalctl -u pipause.service --since "1 hour ago"
   ```
---

## 🧪 Test the Button

* Press the button ➜ LED turns on ➜ Pi-hole is paused for 60 minutes
* Press again ➜ LED turns off ➜ Blocking resumes early
* After timeout ➜ LED turns off ➜ Blocking resumes automatically

## 🔌 Wiring Instructions

| Component | GPIO Pin | Physical Pin # | Notes |
|----------|----------|----------------|-------|
| **Button** | GPIO2 | Pin **3** | Connect other leg to GND (Pin 6 or 9) |
| **LED** | GPIO17 | Pin **11** | Use a ~220Ω resistor between GPIO and LED anode; cathode to GND |

> 🧠 Pi GPIO numbers ≠ physical pin numbers. See the diagram below.

### 📷 GPIO Pinout Diagram

![Raspberry Pi GPIO Layout](https://miro.medium.com/v2/resize:fit:1400/1*A98FLuYKHzZIFBKPTy6URQ.png)

_Image credit: dropberry

### 🧪 LED Wiring Tips

- Connect **GPIO17 (Pin 11)** to the LED **anode** (long leg) through a 220–330Ω resistor
- Connect the **cathode** (short leg) to **GND** (Pin 6 or 9)

### 🧰 Button Wiring Tips

- Connect one side of the button to **GPIO2 (Pin 3)**
- Connect the other side to **GND** (Pin 6 or 9)

### 📦 Optional Tools

- [https://pinout.xyz](https://pinout.xyz) — Interactive GPIO layout
- [https://fritzing.org/](https://fritzing.org/) — Create breadboard diagrams
