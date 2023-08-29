from django.urls import path

from .views import destination

urlpatterns = [
    path('<int:pk>/', destination, name='destination'),
]