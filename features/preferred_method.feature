Feature: Preferred method
  Scenario: Verify presence of box salva metodo e imposta come preferito after payment CDC
        Given Payment generated with mock
        When Browse the payment response url
        And Login as registered user
        And Select add Payment method
        And Select onus credit card
        And Confirm payment
        Then Boxes save and preferred are on the page