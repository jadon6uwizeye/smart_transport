from django.contrib import admin

# Register your models here.

from .models import Destination, Ticket

admin.site.register(Destination)
admin.site.register(Ticket)

# change page header
admin.site.site_header = "Ticket Tracking App"