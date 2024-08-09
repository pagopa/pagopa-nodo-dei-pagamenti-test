import sys
from behave.__main__ import main as behave_main

if __name__ == "__main__":
    sys.argv.append('src/integ-test/bdd-test/features/NewMod3/flows_noOptional/paNew/pagamento_OK.feature')  # Modifica questo con il percorso ai tuoi file .feature
    sys.argv.append('--tags=NM3PANEWPAGOK_5')
    sys.argv.append('--no-capture')
    sys.argv.append('--no-capture-stderr')
    sys.argv.append('-D conffile=src/integ-test/bdd-test/resources/config_sit_postgres.json')
    behave_main()