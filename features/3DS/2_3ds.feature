Feature: guest_payment_3DS2.0
  Scenario: Scenario Outline name: check for result KO on 3DS2.0
    Given Payment generated with mock
    When Browse the payment response url
    And enter with the mail
    And Select 3ds_wrong_cc credit card
    Then Check card number is incorrect
    And Close the page
    
