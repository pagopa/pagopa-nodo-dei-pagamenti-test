#import datetime
#from email import utils
import random
#import time
#import utils

# date = datetime.date.today().strftime("%Y-%m-%d")
# CARRELLO = "CARRELLO" + "-" + str(date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3])

# print(CARRELLO)
def random_s():
    import random
    cont = 5
    strNumRand = ''
    while cont !=0:
        strNumRand += str(random.randint(0,9))
        cont -=1
    return strNumRand 


carrello1 = "311" + "0" + str(random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "77777777777" + "-" + random_s()
print(carrello1)
