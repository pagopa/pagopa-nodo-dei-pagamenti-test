Feature: Not Charity Payment with high amount
    Scenario: Not Charity Payment on wisp with high amount as guest user.
      Given Payment generated with mock high amount
      When Browse the payment response url
      And Enter with the mail
      And Select onus credit card
      #Then sleep 1000 s
      Then the corresponding psp is not displayed
      And the high amount message is displayed


    #Scenario: Not Charity Payment on wisp with high amount as registered user.
     # Given Payment generated with mock high amount
     # When Browse the payment response url
     # And Enter as registered user
     # And Select credit card
     # And Insert a onus card
         # Then the corresponding psp is not displayed
      #And the message "Il tuo pagamento supera l'importo massimo accettato dai gestori su pagoPA per il metodo di pagamento scelto. Ti invitiamo a selezionarne un altro." is displayed
