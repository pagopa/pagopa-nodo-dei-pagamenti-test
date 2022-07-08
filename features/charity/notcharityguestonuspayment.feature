Feature: Not Charity Payment with card onus
  Scenario: Not Charity Payment on wisp with card onus as guest user.
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And select onus credit card
    Then psp are displayed
    #And id_psp not in PP_CONFIG.CCPS_CHARITY