Feature: Payment with onus as guest

  Scenario Outline: Payment with onus as guest goes successfully
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select <type_credit_card> credit card
    And Confirm payment
    Then Payment is made successfully
    Examples:
      | type_credit_card |
      | onus             |
      | not_onus         |