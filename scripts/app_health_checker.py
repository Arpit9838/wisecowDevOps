import sys
import datetime
import requests
import time

def get_service_url():
    # ⚠️ Replace with your known minikube service URL
    return "http://127.0.0.1:59337"

if __name__ == "__main__":
    if len(sys.argv) > 1:
        service_url = sys.argv[1]
    else:
        service_url = get_service_url()

    print("=== Starting Health Checker ===")
    print(f"Monitoring {service_url} every 5s, expecting 200")

    while True:
        try:
            r = requests.get(service_url, timeout=5)
            status = "UP" if r.status_code == 200 else f"DOWN - status {r.status_code}"
        except Exception as e:
            status = f"DOWN - error: {e}"

        ts = datetime.datetime.now(datetime.UTC).isoformat()
        print(f"{ts} - {service_url} - {status}")
        time.sleep(5)
