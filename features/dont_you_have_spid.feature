Feature: Don't you have spid
  Scenario: Correct working of don't you have spid.
    Given Payment generated with mock
    When Browse the payment response url
    And Select don't you have spid
    Then check mail button
    And check cos button is missing
