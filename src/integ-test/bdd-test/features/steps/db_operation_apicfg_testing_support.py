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


# def execute_read_query(connection, query):
#     print('execute_sql_query ...')
#     print(query)

#     try:
#         print('executing_sql_query ...')
#     except Exception as e:
#         print(f"The error '{e}' occurred")


def executeQuery(context, conn, query:str, as_dict:bool = False) -> list:
    print(f' Executing query [{query}] on genericQuery service...')
    try:
        print('executing_sql_query ...')

        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
            print(f"User Profile: {user_profile} ->>> local run!")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        ####RUN DA LOCALE
        if user_profile != None:
            SUBKEY = os.getenv('SUBKEY')
        ####RUN DA REMOTO   
        else:
            SUBKEY = context.config.userdata.get("env").get("SUBKEY")

        headers = {'Ocp-Apim-Subscription-Key': SUBKEY}

        url = apicfg_testing_support.get("base_path") + apicfg_testing_support.get("service")
        print(f">>>>>>>>>>>>>>db operation apicfg URL {url}")
        response = requests.post(url, data=query, headers=headers)
        assert response.status_code == 200, f"Error status code db operation apicfg RESPONSE is {response.status_code}"

        if 'select * from cache' not in query.lower() and 'from CONFIGURATION_KEYS' not in query:
            print(f">>>>>>>>>>>>>>db operation apicfg RESPONSE {response.json()}")
            
        if as_dict:
            return response.json()
        else:
            return [list(d.values()) for d in response.json()]
    except Exception as e:
        print(f"The error '{e}' occurred")
        # Rilancia l'eccezione per interrompere l'esecuzione del test
        raise e  

def closeConnection(conn) -> None:
    print('Fake connection closed successfully')