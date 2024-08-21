Feature: syntax checks for checkPosition 961

    Background:
        Given systems up
        And initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "302#iuv#"
                    }
                ]
            }
            """
    @ALL @PRIMITIVE
    # KO tests
    Scenario Outline: KO tests
        Given <elem> with <value> in checkPosition
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 400
        And check outcome is KO of checkPosition response
        And check description is Invalid <elem> of checkPosition response
        Examples:
            | elem          | value               | soapUI test |
            | positionslist | None                | SIN_CPO_01  |
            | positionslist | Empty               | SIN_CPO_02  |
            | fiscalCode    | None                | SIN_CPO_03  |
            | fiscalCode    | Empty               | SIN_CPO_04  |
            | fiscalCode    | 1111111111          | SIN_CPO_05  |
            | fiscalCode    | 111111111111        | SIN_CPO_06  |
            | fiscalCode    | 1111111111a         | SIN_CPO_07  |
            | noticeNumber  | None                | SIN_CPO_08  |
            | noticeNumber  | Empty               | SIN_CPO_09  |
            | noticeNumber  | 11111111111111111   | SIN_CPO_10  |
            | noticeNumber  | 1111111111111111111 | SIN_CPO_11  |
            | noticeNumber  | 11111111111111111a  | SIN_CPO_12  |