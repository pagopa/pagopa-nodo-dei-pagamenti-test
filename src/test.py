import random


def generate_string(n: int):
    s = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    new = ''.join([s[random.randint(0, len(s) - 1)] for i in range(n)])
    return new

print(generate_string(36))