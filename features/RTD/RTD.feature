Feature:
  Scenario: AddWalletNP
    When Add wallet np
    Then check RTD response

  Scenario: UpdateWalletNP
    When Update wallet np
    Then check RTD response

  #Scenario: MigratetoPM
    #When Migrate to PM
    #Then check RTD response
