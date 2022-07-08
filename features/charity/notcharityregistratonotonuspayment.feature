Feature: Not Charity Payment with card not onus
  Scenario: Not Charity Payment on wisp with card not onus as registered user.
    Given Payment generated with mock
    When Browse the payment response url
    And Login as registered user
    And Select add payment method
    And Select not onus credit card
    Then psp are displayed
    #And id_psp not in PP_CONFIG.CCPS_CHARITY