Feature: Preferred method
    Scenario: Verify presence of box salva metodo e imposta come preferito after payment Altri metodi
        Given Payment generated with mock
        When Browse the payment response url
        And Login as registered user
        And Select add payment method
        Then sleep 1000 s
        #And Select Altri metodi
        #And Payment is made successfully
        #Then box "salva il metodo" is on the page
        #And box "imposta come preferito" is on the page

