Feature: Search Ragione sociale

  Background:
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail

  Scenario: Search PSP for CDC with Ragione sociale
    When Select onus credit card
    Then check change payment manager
    And look for the psp by entering Ragione sociale
    Then psp found successfully

  Scenario: Search PSP for Conto with Ragione sociale
    When Select conto
    And look for the psp by entering Ragione sociale
    Then psp found successfully

  Scenario: Search PSP for Altri metodi with Ragione sociale
    When Select Altri metodi
    And look for the psp by entering Ragione sociale
    Then psp found successfully