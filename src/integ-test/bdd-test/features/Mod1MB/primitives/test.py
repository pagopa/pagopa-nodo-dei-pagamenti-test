import datetime
import random

# date = datetime.date.today().strftime("%Y-%m-%d")
# CARRELLO = "CARRELLO" + "-" + str(date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3])

# print(CARRELLO)


iuv = '0' + str(random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + '00'
print(iuv)