from django.contrib import admin

# Register your models here.

from .models import Destination, Ticket, Trip

class TripAdmin(admin.ModelAdmin):
    list_display = ('name', 'driver', 'plate_number', 'date', 'time')

class DestinationAdmin(admin.ModelAdmin):
    list_display = ('name', 'price', 'longitude', 'latitude')

class TicketAdmin(admin.ModelAdmin):
    list_display = ('name', 'destination', 'trip', 'date','time', 'status')
    list_filter = ('destination', 'trip', 'status')
    search_fields = ('destination', 'trip', 'date', 'status')
    list_per_page = 25

admin.site.register(Destination,DestinationAdmin)
admin.site.register(Ticket, TicketAdmin)
admin.site.register(Trip,TripAdmin)

# change page header
admin.site.site_header = "Ticket Tracking App"
