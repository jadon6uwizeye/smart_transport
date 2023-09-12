from django.urls import path

from .views import destination,send_custom_message

urlpatterns = [
    path('<int:pk>/', destination, name='destination'),
    path('send_custom_message/', send_custom_message, name='send_custom_message'),
]