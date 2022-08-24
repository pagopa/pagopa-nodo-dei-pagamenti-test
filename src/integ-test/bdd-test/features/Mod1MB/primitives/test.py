import datetime

date = datetime.date.today().strftime("%Y-%m-%d")
CARRELLO = "CARRELLO" + "-" + str(date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3])

print(CARRELLO)