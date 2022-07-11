import os
import json

def load_settings():
    global settings
    with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'settings.json')) as f:
        settings = json.load(f)
    return settings

settings = load_settings()