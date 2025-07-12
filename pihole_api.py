import requests
import time

class PiHoleAPI:
    def __init__(self, api_url, api_token, session_ttl_seconds=1500):
        self.api_url = api_url.rstrip("/")
        self.auth_url = f"{self.api_url}/auth"
        self.block_url = f"{self.api_url}/dns/blocking"
        self.api_token = api_token
        self.session_ttl_seconds = session_ttl_seconds

        self._auth_headers = None
        self._auth_expiry = 0

    def _get_auth_headers(self, force_renew=False):
        if not force_renew and self._auth_headers and time.time() < self._auth_expiry:
            return self._auth_headers

        try:
            headers = {
                "Accept": "application/json",
                "Content-Type": "application/json"
            }
            payload = { "password": self.api_token }
            response = requests.post(self.auth_url, json=payload, headers=headers)

            if response.status_code == 200:
                sid = response.json().get("session", {}).get("sid")
                if sid:
                    self._auth_headers = { "sid": sid }
                    self._auth_expiry = time.time() + self.session_ttl_seconds
                    return self._auth_headers
                else:
                    print("❌ Missing SID in auth response.")
            else:
                print(f"❌ Auth failed: {response.status_code} - {response.text}")
        except Exception as e:
            print("❌ Exception during auth:", e)

        self._auth_headers = None
        return None

    def _post(self, payload):
        headers = self._get_auth_headers()
        if not headers:
            return None

        try:
            response = requests.post(self.block_url, json=payload, headers=headers)
            if response.status_code == 200:
                return response
            elif response.status_code in [401, 403]:
                headers = self._get_auth_headers(force_renew=True)
                if headers:
                    return requests.post(self.block_url, json=payload, headers=headers)
        except Exception as e:
            print("❌ Request failed:", e)

        return None

    def pause(self, duration_seconds=None):
        """Disable blocking (pause Pi-hole). Optional timer."""
        payload = {"blocking": False}
        if duration_seconds:
            payload["timer"] = duration_seconds
        return self._post(payload)

    def resume(self):
        """Re-enable blocking (unpause Pi-hole)."""
        return self._post({"blocking": True})
