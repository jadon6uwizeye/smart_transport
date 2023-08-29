from django.db import models

# Create your models here.

class Destination(models.Model):
    name = models.CharField(max_length=100)
    img = models.ImageField(upload_to='pics', null=True, blank=True)
    desc = models.TextField()
    price = models.IntegerField(null=True, blank=True)
    longitude = models.FloatField()
    latitude = models.FloatField()

    def __str__(self):
        return self.name

class Ticket(models.Model):
    name = models.CharField(max_length=100)
    phone_number = models.CharField(max_length=100)
    email = models.CharField(max_length=100, null=True, blank=True)
    destination = models.ForeignKey(Destination, on_delete=models.CASCADE)
    date = models.DateField(auto_created=True)
    time = models.TimeField()

    def __str__(self):
        return self.name
