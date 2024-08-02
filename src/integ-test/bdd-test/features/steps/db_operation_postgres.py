try:
    import psycopg2
    from psycopg2 import OperationalError
    from psycopg2 import pool
except ModuleNotFoundError:
    print(">>>>>>>>>>>>>>>>>No import db_operation_postgres for Oracle pipeline")

conn_pool = None

def create_connection(db_name, db_user, db_password, db_host, db_port):
    connection = None
    try:
        connection = psycopg2.connect(
            database=db_name,
            user=db_user,
            password=db_password,
            host=db_host,
            port=db_port,
            options=f'-c search_path={db_user}',
        )
        print("Connection to PostgreSQL DB successful")
    except OperationalError as e:
        print(f"The error '{e}' occurred")
    return connection

def create_connection_pool(db_name, db_user, db_password, db_host, db_port):
    global conn_pool
    try:
        # Initialize the connection pool
        conn_pool = pool.SimpleConnectionPool(
            minconn=1,
            maxconn=100,
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_password
        )
    except OperationalError as e:
        print(f"The error '{e}' occurred")
    return conn_pool


# wrapper
def getConnection_old(host:str, database:str, user:str, password:str, port:str):
    return create_connection(database, user, password, host, port) 


# Acquisizione di una connessione dalla pool
def getConnection(host:str, database:str, user:str, password:str, port:str):
    conn_pool = create_connection_pool(database, user, password, host, port) 
    return conn_pool.getconn()



def execute_read_query(connection, query):
    print(f' Executing query [{query}] on PostgresDB instance...')
    cursor = connection.cursor()
    result = None
    try:
        cursor.execute(query)
        connection.commit()
        
        if query.startswith('SELECT'):  
            result = cursor.fetchall()
            print(f' Query executed successfully - [{len(result)}] row/s found')            
            return result
        
        elif query.startswith('UPDATE'): 
            print("Update executed successfully")
            
        elif query.startswith('INSERT'): 
            print("Insert executed successfully")
            
    except OperationalError as e:
        print(f"The error '{e}' occurred")

# wrapper    
def executeQuery(conn, query:str, as_dict:bool = False) -> list:
    return execute_read_query(conn, query)


def closeConnection_old(conn) -> None:
    try:
        if conn is not None:
            print('Closing connection to the PgDb...')
            conn.close()
            print('Connection to PgDb closed successfully')
    except Exception as e:
        print('Error close connection to db')
        print(f"The error '{e}' occurred")


def closeConnection(conn) -> None:
    try:
        if conn is not None:
            print('Closing connection to the PgDb...')
            conn_pool.putconn(conn)
            print('Connection to PgDb closed successfully')
    except Exception as e:
        print('Error close connection to db')
        print(f"The error '{e}' occurred")
