from django.contrib import admin

# Register your models here.

from .models import Destination, Ticket, Trip

admin.site.register(Destination)
admin.site.register(Ticket)
admin.site.register(Trip)

# change page header
admin.site.site_header = "Ticket Tracking App"