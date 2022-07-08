Feature: Not Charity Payment with card onus
  Scenario: Not Charity Payment on wisp with card onus as registered user.
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And Select onus credit card
    Then psp are displayed
    #And id_psp not in PP_CONFIG.CCPS_CHARITY