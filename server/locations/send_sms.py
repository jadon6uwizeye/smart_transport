from twilio.rest import Client
import environ  
from pathlib import Path


# Twilio Account SID and Auth Token from .env
BASE_DIR = Path(__file__).resolve().parent.parent
env = environ.Env(
    # set casting, default value
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
    body='\nHello from Ticket Tracking Application! \nyou have arrived at your destination \nThank you for using our service',
    from_='+18148854564',
    to='+250789952243'
)

print('Message SID:', message.sid)
