import cx_Oracle, os, sys

def before_all(context):

    #PROVA
    sys.path.append(os.path.abspath(os.path.join(os.pardir, 'data')))
    sys.path.append(os.path.abspath(os.path.join(os.pardir, 'framework')))

    lib_dir = os.path.abspath(os.path.join(__file__, os.pardir, os.pardir, os.pardir, os.pardir, os.pardir, 'instantclient_21_6'))
    cx_Oracle.init_oracle_client(lib_dir = lib_dir)

def before_feature(context,feature):
    #print('before feature')
    pass

def after_feature(context,feature):
    #print('after feature')
    pass

def before_scenario(contxt,scenario):
    #print('before scenario')
    pass