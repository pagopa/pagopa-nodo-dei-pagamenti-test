Feature: Not Charity Payment with card not onus
  Scenario: Not Charity Payment on wisp with card not onus as guest user.
    Given db connection opened
    And Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And select not_onus credit card
    Then psp are displayed
    Then sleep 1000 s
    #And id_psp not in PP_CONFIG.CCPS_CHARITY
    And close db connection

    #Check id_psp in {column} is {value}