from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

class Destination(models.Model):
    name = models.CharField(max_length=100)
    img = models.ImageField(upload_to='pics', null=True, blank=True)
    desc = models.TextField()
    price = models.IntegerField(null=True, blank=True)
    longitude = models.FloatField()
    latitude = models.FloatField()

    def __str__(self):
        return self.name

class Trip(models.Model):
    name = models.CharField(max_length=100, blank=True, null=True)
    driver = models.ForeignKey(User, on_delete=models.CASCADE)
    plate_number = models.CharField(max_length=100, default='RAC 123 A')
    destinations = models.ManyToManyField(Destination)
    date = models.DateField(auto_created=True)
    time = models.TimeField()

    def __str__(self):
        return f'{self.name + " "+ self.plate_number}'

class Ticket(models.Model):
    TICKET_STATUS = (
        ('P', 'Pending'),
        ('O', 'On-going'),
        ('C', 'Completed'),
    )
    name = models.CharField(max_length=100)
    phone_number = models.CharField(max_length=100)
    driver_phone_number = models.CharField(max_length=15)
    email = models.CharField(max_length=100, null=True, blank=True)
    destination = models.ForeignKey(Destination, on_delete=models.CASCADE)
    date = models.DateField(auto_created=True)
    trip = models.ForeignKey(Trip, on_delete=models.CASCADE)
    time = models.TimeField()
    status = models.CharField(max_length=1, choices=TICKET_STATUS, default='P')

    def __str__(self):
        return self.name

