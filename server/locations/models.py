from django.db import models

# Create your models here.

class Destination(models.Model):
    name = models.CharField(max_length=100)
    img = models.ImageField(upload_to='pics', null=True, blank=True)
    desc = models.TextField()
    price = models.IntegerField(null=True, blank=True)
    longitude = models.FloatField()
    latitude = models.FloatField()
