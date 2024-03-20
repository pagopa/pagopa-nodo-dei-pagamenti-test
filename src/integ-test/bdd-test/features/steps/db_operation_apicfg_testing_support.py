import json

import requests
import os

apicfg_testing_support = {
    "base_path": None,
    "service": "/genericQuery"
}


def set_address(service):
    apicfg_testing_support["base_path"] = service.get("url")
    print("Basepath setted")


def create_connection(db_name, db_user, db_password, db_host, db_port):
    print("Fake connection to DB executed successfully")


def getConnection(host:str, database:str, user:str, password:str, port:str):
    return None


def execute_read_query(connection, query):
    print('execute_sql_query ...')
    print(query)

    try:
        print('executing_sql_query ...')
    except Exception as e:
        print(f"The error '{e}' occurred")


def executeQuery(conn, query:str, as_dict:bool = False) -> list:
    print('execute_sql_query ...')
    print(query)
    try:
        print('executing_sql_query ...')
        headers = {}
        if 'APICFG_SUBSCRIPTION_KEY' in os.environ:
            headers["Ocp-Apim-Subscription-Key"] = os.getenv("APICFG_SUBSCRIPTION_KEY", default="")
        
        url = apicfg_testing_support.get("base_path") + apicfg_testing_support.get("service")
        print(f"#####ROWWWWWWW URLLLLLLLLLLLLLLLLLL {url}")
        response = requests.post(url, data=query, headers=headers)
        print(f"#####RESPONSE URLLLLLLLLLLLLLLLLLL {response.json()}")
        if as_dict:
            return response.json()
        else:
            return [list(d.values()) for d in response.json()]
    except Exception as e:
        print(f"The error '{e}' occurred")


def closeConnection(conn) -> None:
    print('Fake connection closed successfully')