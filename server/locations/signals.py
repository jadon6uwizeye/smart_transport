# When a ticket is created, send sms using the send_sms function to the number provided in the ticket.
from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Ticket
from .send_sms import send_sms

@receiver(post_save, sender=Ticket)
def send_sms_on_ticket_creation(sender, instance, created, **kwargs):
    print("Signal Triggered")
    if created:
        # phone number is in the format is +25XXXXXXXXXX as from instance.phone_number if it does not start with +25, add it
        if not instance.phone_number.startswith("+25"):
            instance.phone_number = "+25" + instance.phone_number

        message_content = f"Hello {instance.name}, \nyour ticket to {instance.destination.name} has been booked. The date of travel is {instance.date} and the time is {instance.time}."
        send_sms(instance.phone_number, message_content)