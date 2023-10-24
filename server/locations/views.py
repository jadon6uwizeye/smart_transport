from rest_framework.views import APIView

# api endpoint to get destination and send sms to all phone numbers in Ticket table with that destination
from rest_framework.response import Response
from rest_framework import status

from .serializers import DestinationSerializer, TicketSerializer
from .models import Destination, Ticket, Trip
from .send_sms import send_sms
from rest_framework.decorators import api_view

@api_view(['GET'])
# csrf_exempt
def destination(request, pk):
    trip = request.query_params.get('trip', None)
    if trip is not None:
        destination = Destination.objects.get(id=pk, trip=trip)
    else:
        destination = Destination.objects.get(id=pk)
    tickets = Ticket.objects.filter(destination=destination, status__in=['O', 'P'])
    phone_numbers = [ticket.phone_number for ticket in tickets]

    # set status of all tickets to completed
    for ticket in tickets:
        ticket.status = 'C'
        ticket.save()

    # send sms to all phone numbers in phone_numbers using send_sms function
    for phone_number in phone_numbers:
        message_content = f"Hello, \nYou have arrived at your destination {destination.name} . The ticket date of travel was {tickets[0].date} and the time was {tickets[0].time}."
        # if phone number is in the format is +25XXXXXXXXXX as from instance.phone_number if it does not start with +25, add it
        if not phone_number.startswith("+25"):
            phone_number = "+25" + phone_number
            
        send_sms(phone_number, message_content)

    return Response(phone_numbers, status=status.HTTP_200_OK)

# send custom message to passengers
@api_view(['POST'])
def send_custom_message(request):
    # get tickets where trip driver is request.user and status is not completed
    tickets = Ticket.objects.filter(trip__driver=request.user, status__in=['O', 'P'])
    # get phone numbers of all tickets
    phone_numbers = [ticket.phone_number for ticket in tickets]
    try:
        message_content = request.data['message_content']
        print(message_content)
    except KeyError:
        return Response({'message': 'Please provide message_content'}, status=status.HTTP_400_BAD_REQUEST)
    # send sms to all phone numbers in phone_numbers using send_sms function
    for phone_number in phone_numbers:
        # if phone number is in the format is +25XXXXXXXXXX as from instance.phone_number if it does not start with +25, add it
        if not phone_number.startswith("+25"):
            phone_number = "+25" + phone_number

            print(phone_number)
            
        send_sms(phone_number, message_content)

    return Response({
        'message': 'Message sent successfully',
    }, status=status.HTTP_200_OK)

# get all tickets for a particular trip
@api_view(['GET'])
def get_tickets(request):
    try:
        trip = Trip.objects.filter(driver=request.user).last()
    except Trip.DoesNotExist:
        return Response({'message': 'You have no trips'}, status=status.HTTP_404_NOT_FOUND)
        
    # get all destinations in trip
    destinations = trip.destinations.all()
    # get all tickets for each destination in destinations
    response = {}
    tickets = []
    for destination in destinations:
        response[destination.name] = TicketSerializer(Ticket.objects.filter(destination=destination, 
                                                                            # and status is not completed
                                                                            # status__in=['O', 'P']
                                                                            ), many=True).data
    # add total number of tickets, those with status C and pending or O from the response
    return Response(response, status=status.HTTP_200_OK)


# get all destinations on trip
@api_view(['GET'])
def get_destinations(request):
    try:
        trip = Trip.objects.filter(driver=request.user).last()
    except TypeError:
        return Response({'message': 'You have no trips'}, status=status.HTTP_404_NOT_FOUND)
    # get all destinations in trip
    destinations = trip.destinations.all()
    DestinationSerializer(destinations, many=True).data
    

    return Response(DestinationSerializer(destinations, many=True).data, status=status.HTTP_200_OK)