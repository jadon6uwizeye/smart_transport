from django.urls import path

from .views import destination,send_custom_message,get_tickets,get_destinations

urlpatterns = [
    path('<int:pk>/', destination, name='destination'),
    path('send_custom_message/', send_custom_message, name='send_custom_message'),
    path('get_tickets/', get_tickets, name='get_tickets'),
    path('get_destinations/', get_destinations, name='get_destinations'),

]