Feature: Label Other method
    Scenario: Check label for Altri metodi
        Given Payment generated with mock
        When Browse the payment response url
        And Enter with the mail
        And Select Altri metodi
        Then check label is not equal to "paga con il tuo conto corrente presso"