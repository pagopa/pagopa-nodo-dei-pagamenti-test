Feature: Search Nome servizi
    Scenario: Search PSP for CDC with Nome servizi
        Given Payment generated with mock
        When Browse the payment response url
        And Enter with the mail
        And Select credit card
        Then check change payment manager
        And look for the psp by entering Nome servizi
        Then psp found successfully

    Scenario: Search PSP for Conto with Nome servizi
            Given Payment generated with mock
            When Browse the payment response url
            And Enter with the mail
            And Select conto
            And look for the psp by entering Nome servizi
            Then psp found successfully

    Scenario: Search PSP for Altri metodi with Nome servizi
            Given Payment generated with mock
            When Browse the payment response url
            And Enter with the mail
            And Select Altri metodi
            And look for the psp by entering Nome servizi
            Then psp found successfully