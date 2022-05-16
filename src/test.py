import random
import re


def generate_string(n: int):
    s = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    new = ''.join([s[random.randint(0, len(s) - 1)] for i in range(n)])
    return new

def generate_number(n:int):
    return random.randint(10 ** (n-1), 10 ** n)

print(generate_string(256))
#print(generate_number(13))
