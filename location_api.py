import ipapi

location_data = ipapi.location()

print("City : " + location_data['city'])
print("Latitude : " + str(location_data['latitude']))
print("Longitude : " + str(location_data['longitude']))
