Feature: Syntax checks for nodoChiediFlussoRendicontazione

   Background:
      Given systems up


   # [CFRSIN0]
   Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediFlussoRendicontazione primitive
      Given initial XML nodoChiediFlussoRendicontazione
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/ciao/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ws:nodoChiediFlussoRendicontazione>ciao</ws:nodoChiediFlussoRendicontazione>
         </soapenv:Header>
         <soapenv:Body>
         <ws:nodoChiediFlussoRendicontazione>
         <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
         <password>pwdpwdpwd</password>
         <identificativoDominio>#codicePA#</identificativoDominio>
         <identificativoPSP>#psp#</identificativoPSP>
         <identificativoFlusso>#identificativoFlusso#</identificativoFlusso>
         </ws:nodoChiediFlussoRendicontazione>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When  EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
      Then  check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediFlussoRendicontazione response


   #[CFRSIN1]
   Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediFlussoRendicontazione primitive
      Given initial XML nodoChiediFlussoRendicontazione
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:ppt="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ppt:nodoChiediFlussoRendicontazione>ciao</ppt:nodoChiediFlussoRendicontazione>
         </soapenv:Header>
         <soapenv:Body>
         <ws:nodoChiediFlussoRendicontazione>
         <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
         <password>pwdpwdpwd</password>
         <identificativoDominio>#codicePA#</identificativoDominio>
         <identificativoPSP>#psp#</identificativoPSP>
         <identificativoFlusso>#identificativoFlusso#</identificativoFlusso>
         </ws:nodoChiediFlussoRendicontazione>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When  EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
      Then  check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediFlussoRendicontazione response


   Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediFlussoRendicontazione primitive
      Given initial XML nodoChiediFlussoRendicontazione
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:nodoChiediFlussoRendicontazione>
         <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
         <password>pwdpwdpwd</password>
         <identificativoDominio>#codicePA#</identificativoDominio>
         <identificativoPSP>#psp#</identificativoPSP>
         <identificativoFlusso>#identificativoFlusso#</identificativoFlusso>
         </ws:nodoChiediFlussoRendicontazione>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And <elem> with <value> in nodoChiediFlussoRendicontazione
      When  EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
      Then  check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediFlussoRendicontazione response
      Examples:
         | elem                               | value | soapUI test |
         | soapenv:Body                       | Empty | CFRSIN2     |
         | ws:nodoChiediFlussoRendicontazione | Empty | CFRSIN4     |
         | soapenv:Body                       | None  | CFRSIN3     |


   # [CFRSIN5]
   #Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediFlussoRendicontazione primitive
   #   Given initial XML nodoChiediFlussoRendicontazione
   #      """
   #      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
   #      <soapenv:Header/>
   #      <soapenv:Body>
   #      <ppt:nodoChiediFlussoRendicontazione>
   #      <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
   #      <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
   #      <password>pwdpwdpwd</password>
   #      <identificativoDominio>#codicePA#</identificativoDominio>
   #      <identificativoPSP>#psp#</identificativoPSP>
   #      <identificativoFlusso>#identificativoFlusso#</identificativoFlusso>
   #      </ppt:nodoChiediFlussoRendicontazione>
   #      </soapenv:Body>
   #      </soapenv:Envelope>
   #      """
   #   When  EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
   #   Then  check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediFlussoRendicontazione response
   #   And   check faultstring is Errore di sintassi extra XSD. of nodoChiediFlussoRendicontazione response


   Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediFlussoRendicontazione primitive
      Given initial XML nodoChiediFlussoRendicontazione
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:nodoChiediFlussoRendicontazione>
         <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
         <password>pwdpwdpwd</password>
         <identificativoDominio>#codicePA#</identificativoDominio>
         <identificativoPSP>#psp#</identificativoPSP>
         <identificativoFlusso>#identificativoFlusso#</identificativoFlusso>
         </ws:nodoChiediFlussoRendicontazione>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And <elem> with <value> in nodoChiediFlussoRendicontazione
      When EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
      Then check faultString is Errore di sintassi extra XSD. of nodoChiediFlussoRendicontazione response
      And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediFlussoRendicontazione response
      Examples:
         | elem                                  | value                                | soapUI test |
         | identificativoIntermediarioPA         | None                                 | CFRSIN6     |
         | identificativoIntermediarioPA         | Empty                                | CFRSIN7     |
         | identificativoIntermediarioPA         | dbcFkSRY15k6mEaIVGoki0OcZKyVboNtjndJ | CFRSIN8     |
         | identificativoStazioneIntermediarioPA | None                                 | CFRSIN9     |
         | identificativoStazioneIntermediarioPA | Empty                                | CFRSIN10    |
         | identificativoStazioneIntermediarioPA | k91JETYVnE7grIIKbzWE6Di7XKM3ymJeawhf | CFRSIN11    |
         | password                              | None                                 | CFRSIN12    |
         | password                              | Empty                                | CFRSIN13    |
         | password                              | Xlve3Jc                              | CFRSIN14    |
         | password                              | xxkV8x4phzRKyiuE                     | CFRSIN15    |
         #| identificativoPSP                     | None                                 | CFRSIN20    |
         | identificativoDominio                 | k91JETYVnE7grIIKbzWE6Di7XKM3ymJeawhf | CFRSIN18    |
         | identificativoPSP                     | k91JETYVnE7grIIKbzWE6Di7XKM3ymJeawhf | CFRSIN21    |
         | identificativoFlusso                  | None                                 | CFRSIN22    |

   Scenario Outline: Check for nodoChiediFlussoRendicontazione response
      Given initial XML nodoChiediFlussoRendicontazione
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:nodoChiediFlussoRendicontazione>
         <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
         <password>pwdpwdpwd</password>
         <identificativoDominio>#codicePA#</identificativoDominio>
         <identificativoPSP>#psp#</identificativoPSP>
         <identificativoFlusso>${#TestSuite#flussoPsp1}</identificativoFlusso>
         </ws:nodoChiediFlussoRendicontazione>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When  EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
      Then check ppt:nodoChiediFlussoRendicontazioneRisposta field exists in nodoChiediFlussoRendicontazione response
      Examples:
      | elem                  | value | soapUI test |
      | identificativoDominio | None  | CFRSIN16    |
      | identificativoPSP     | None  | CFRSIN19    |

   
   # [CFRSIN17]
   Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediFlussoRendicontazione primitive
      Given initial XML nodoChiediFlussoRendicontazione
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:nodoChiediFlussoRendicontazione>
         <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
         <password>pwdpwdpwd</password>
         <identificativoDominio></identificativoDominio>
         <identificativoPSP>#psp#</identificativoPSP>
         <identificativoFlusso>#identificativoFlusso#</identificativoFlusso>
         </ws:nodoChiediFlussoRendicontazione>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When  EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
      Then  check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediFlussoRendicontazione response

   
   # [CFRSIN23]
   Scenario: Check PPT_ID_FLUSSO_SCONOSCIUTO error for nodoChiediFlussoRendicontazione primitive
      Given initial XML nodoChiediFlussoRendicontazione
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:nodoChiediFlussoRendicontazione>
         <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
         <password>pwdpwdpwd</password>
         <identificativoDominio>#codicePA#</identificativoDominio>
         <identificativoPSP>#psp#</identificativoPSP>
         <identificativoFlusso></identificativoFlusso>
         </ws:nodoChiediFlussoRendicontazione>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When  EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
      Then  check faultCode is PPT_ID_FLUSSO_SCONOSCIUTO of nodoChiediFlussoRendicontazione response

  
   # [CFRSIN24]
   Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediFlussoRendicontazione primitive
      Given initial XML nodoChiediFlussoRendicontazione
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:nodoChiediFlussoRendicontazione>
         <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
         <password>pwdpwdpwd</password>
         <identificativoDominio>#codicePA#</identificativoDominio>
         <identificativoPSP>#psp#</identificativoPSP>
         <identificativoFlusso>#identificativoFlusso#</identificativoFlusso>
         <rpt>ciao</rpt>
         </ws:nodoChiediFlussoRendicontazione>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When  EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
      Then  check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediFlussoRendicontazione response
      And check faultString is Errore di sintassi extra XSD. of nodoChiediFlussoRendicontazione response

    
   # [CFRSIN25]
   #Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediFlussoRendicontazione primitive
   #   Given initial XML nodoChiediFlussoRendicontazione
   #      """
   #      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
   #      <soapenv:Header/>
   #      <soapenv:Body>
   #      <ws:nodoChiediFlussoRendicontazione>
   #      <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
   #      <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
   #      <password>pwdpwdpwd
   #      <identificativoDominio>#codicePA#</identificativoDominio>
   #      <identificativoPSP>#psp#</identificativoPSP>
   #      <identificativoFlusso>#identificativoFlusso#</identificativoFlusso>
   #      </ws:nodoChiediFlussoRendicontazione>
   #      </soapenv:Body>
   #      </soapenv:Envelope>
   #      """
   #   When  EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
   #   Then  check faultCode is soap:Client of nodoChiediFlussoRendicontazione response
   #   And   check faultString is XML_STREAM_EXC of nodoChiediFlussoRendicontazione response









