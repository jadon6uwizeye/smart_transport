from twilio.rest import Client
import environ
from pathlib import Path

def send_sms(phone_number, message_content):
    # Twilio Account SID and Auth Token from .env
    BASE_DIR = Path(__file__).resolve().parent.parent
    env = environ.Env(
        DEBUG=(bool, False)
    )
    environ.Env.read_env(
        env_file=BASE_DIR / '.env'
    )
    account_sid = env('TWILIO_ACCOUNT_SID')
    auth_token = env('TWILIO_AUTH_TOKEN')

    # Create a Twilio client
    client = Client(account_sid, auth_token)

    # Send an SMS
    message = client.messages.create(
        body=message_content,
        from_='+18148854564',
        to=phone_number
    )

    return message.sid
