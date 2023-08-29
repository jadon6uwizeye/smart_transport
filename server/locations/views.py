from rest_framework.views import APIView

# api endpoint to get destination and send sms to all phone numbers in Ticket table with that destination
from rest_framework.response import Response
from rest_framework import status
from .models import Destination, Ticket
from .send_sms import send_sms
from rest_framework.decorators import api_view

@api_view(['GET'])
# csrf_exempt
def destination(request, pk):
    destination = Destination.objects.get(id=pk)
    tickets = Ticket.objects.filter(destination=destination)
    phone_numbers = [ticket.phone_number for ticket in tickets]

    # send sms to all phone numbers in phone_numbers using send_sms function
    for phone_number in phone_numbers:
        message_content = f"Hello, \nYou have arrived at your destination {destination.name} . The ticket date of travel was {tickets[0].date} and the time was {tickets[0].time}."
        # if phone number is in the format is +25XXXXXXXXXX as from instance.phone_number if it does not start with +25, add it
        if not phone_number.startswith("+25"):
            phone_number = "+25" + phone_number
            
        send_sms(phone_number, message_content)

    return Response(phone_numbers, status=status.HTTP_200_OK)