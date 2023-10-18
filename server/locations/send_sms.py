from twilio.rest import Client
import environ
from pathlib import Path
import requests


def send_sms(phone_number, message_content):
    # Twilio Account SID and Auth Token from .env
    BASE_DIR = Path(__file__).resolve().parent.parent
    env = environ.Env(
        DEBUG=(bool, False)
    )
    environ.Env.read_env(
        env_file=BASE_DIR / '.env'
    )
    token=env('PINDO_API_KEY')
    headers = {'Authorization': 'Bearer ' + token}
    data = {'to' : phone_number, 'text' : message_content, 'sender' : 'Ticket Tracking App'}

    url = 'https://api.pindo.io/v1/sms/'
    response = requests.post(url, json=data, headers=headers)
    print(response)
    print(response.json())

