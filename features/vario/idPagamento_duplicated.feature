Feature: idPagamento already used

  Scenario: Correct message when idPagamento already used
    Given Payment generated with mock
    When Browse the payment response url
    And Enter with the mail
    And Select onus credit card
    And Confirm payment
    And Payment is made successfully
    And close the page
    And Browse the payment response url
    Then Error message is shown