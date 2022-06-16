Feature: Languages PM

  Background:
    Given Payment generated with mock

  Scenario Outline: Correct functioning of languages.
    When Browse the payment response url
    And Select the language <lang>
    Then Check the text in <lang>


    Examples:
    |lang|
    |en  |
    |sl  |
    |fr  |
    |de  |
