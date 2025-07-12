from gpiozero import Button, LED
from signal import pause
import os
import threading
import time
from pihole_api import PiHoleAPI

# --- CONFIGURATION ---
PIHOLE_API_URL = os.environ.get("PIHOLE_API_URL", "http://pi.hole/api")
API_TOKEN = os.environ.get("PIHOLE_API_KEY")
PAUSE_DURATION_SECONDS = 60 * 60  # 60 minutes

# --- INIT ---
button = Button(2, bounce_time=0.1)
led = LED(17)
pihole = PiHoleAPI(PIHOLE_API_URL, API_TOKEN)

# --- STATE ---
is_paused = False
pause_timer_thread = None
lock = threading.Lock()

def pause_or_resume():
    global is_paused, pause_timer_thread

    with lock:
        if is_paused:
            print("▶️  Resuming Pi-hole...")
            if pihole.resume():
                led.off()
                is_paused = False
                print("✅ Pi-hole resumed. LED OFF.")
        else:
            print("⏸️  Pausing Pi-hole...")
            if pihole.pause(PAUSE_DURATION_SECONDS):
                led.on()
                is_paused = True
                print(f"✅ Pi-hole paused for {PAUSE_DURATION_SECONDS // 60} minutes. LED ON.")
                pause_timer_thread = threading.Thread(target=resume_after_timer, daemon=True)
                pause_timer_thread.start()

def resume_after_timer():
    global is_paused
    time.sleep(PAUSE_DURATION_SECONDS)
    with lock:
        if is_paused:
            print("⏰ Auto-resuming Pi-hole...")
            if pihole.resume():
                led.off()
                is_paused = False
                print("✅ Pi-hole resumed. LED OFF.")

button.when_pressed = pause_or_resume

print("🚀 Ready. Press the button to toggle Pi-hole pause.")
pause()
