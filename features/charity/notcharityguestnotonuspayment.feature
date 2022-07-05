Feature: Not Charity Payment with card not onus
  Scenario: Not Charity Payment on wisp with card not onus as guest user.
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select credit card 
    And Insert a not onus card
    Then psp are displayed
    And id_psp not in PP_CONFIG.CCPS_CHARITY