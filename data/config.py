import os
import json

def load_settings():
    with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'settings.json')) as f:
        settings = json.load(f)
    return settings

def load_cards():
    with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'cards.json')) as f:
        cards = json.load(f)
    return cards

settings = load_settings()
cards = load_cards()