import random


def generate_string(n: int):
    s = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    new = ''

    for i in range(n):
        new += s[random.randint(0, len(s) - 1)]
    
    return new

print(generate_string(71))