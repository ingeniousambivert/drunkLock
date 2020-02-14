import requests

url = "https://www.fast2sms.com/dev/bulk"

number = input("Enter the phone number :")
message = input("Enter the message :")

payload = "sender_id=FSTSMS&message=" + message + \
    "&language=english&route=p&numbers=" + number

headers = {
    'authorization': "NSBuvOiHtwpjZ4oPzIYd3Kl17W20rJLVXEUygf56xACcsQkm8T8Y6aMtEvuWPVBA4cNzjbfpsmLXyTDG",
    'Content-Type': "application/x-www-form-urlencoded",
    'Cache-Control': "no-cache",
}

response = requests.request("POST", url, data=payload, headers=headers)
print(response.text)
