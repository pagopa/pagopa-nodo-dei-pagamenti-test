Feature: Flow checks Bollo 7 -12

  Background: 
    Given systems up
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr_old#
    
    Scenario: Check faultCode PPT_SEMANTICA error on Importo diffrent value between MB and RT [Bollo_7]
      Given MB generation
        """
        <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
          <PSP>
              <CodiceFiscale>12345678901</CodiceFiscale>
              <Denominazione>#psp#</Denominazione>
          </PSP>
          <IUBD>#iubd#</IUBD>
          <OraAcquisto>2015-02-06T15:00:44.659+01:00</OraAcquisto>
          <Importo>10.00</Importo>
          <TipoBollo>01</TipoBollo>
          <ImprontaDocumento>
              <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
              <ns2:DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</ns2:DigestValue>
          </ImprontaDocumento>
          <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
              <SignedInfo>
                <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
                <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
                <Reference URI="">
                    <Transforms>
                      <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
                    </Transforms>
                    <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
                    <DigestValue>IzdMHSaGk1GC71oRUrJPXY+5MMgwpEbHQSgRXASVwLM=</DigestValue>
                </Reference>
              </SignedInfo>
              <SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
              <KeyInfo Id="keyinfo">
                <X509Data>
                    <X509Certificate>MIIDjDCCAnSgAwIBAgICBXIwDQYJKoZIhvcNAQEFBQAwNTELMAkGA1UEBhMCSVQxDjAMBgNVBAoT BVNvZ2VpMRYwFAYDVQQDEw1DQSBTb2dlaSBUZXN0MB4XDTE1MDIwMzE2MDc1MFoXDTIxMDIwMzE2 MDYyOFowSTELMAkGA1UEBhMCSVQxDzANBgNVBAoTBmlkUHNwMTEMMAoGA1UECxMDUFNQMRswGQYD VQQDExIxMjM0NTY3ODkwMSBpZFBzcDEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC9 CxOezioe/5q+h3J7ISvBhAKgATU2DGjzocFNGIczcqPNFlaEMi8zMacO4y9Hx3O9I/4dujCytQnE zZoPaXVndJcEVhoZi5jSWkykADdTZqX+lxNfhGJqsasioVN2ri5IZiTFy22tBDPiJ/z1NrbATRtK pFRuEuPEBm61nt1IMdYOp0+WihWFbzVsB/+0Xde7qpcLkKExPB3NigVYAgGgo/z8Z89FtF9sxgRC AEKCADDZLTCujM/MANhYv7tYCoe81NIYYkOInAfGErv+YnH7RIyVwqkbNhMXavsAgv1Ucd9JUUAV Tw6EzIomsUNqBwtyixSKoHqf/OUnR+Gpuk2NAgMBAAGjgZEwgY4wDgYDVR0PAQH/BAQDAgZAMF0G A1UdIwRWMFSAFFfDfM0VomETCms+4cZJ7E5DH8OHoTmkNzA1MQswCQYDVQQGEwJJVDEOMAwGA1UE ChMFU29nZWkxFjAUBgNVBAMTDUNBIFNvZ2VpIFRlc3SCAQEwHQYDVR0OBBYEFDHd+flzQA5NQALK ZMSdqpr6TF7VMA0GCSqGSIb3DQEBBQUAA4IBAQAIZZpADkFaFF7Up2+xuGkC14CqYBPCQlDqqo// u8pJ/77cQ18jquqoQInw0vEpX3ttRjISlrsHHUT/HAB7I3A9VJwbQ2ezZHOndUBKeBJ5kBYCsTAj LKUc3iakteoaTwQUUqOvUaRqoiZg9W7aBdigzFWq7thYSi1zzegqvQTtvzGqU/Duem7ky1SGe/3D NxpeeU3JGqKxpi2LNg6riVXOuu9mjkIzrT0OkGjcdY+8uF8Ik+wCprjXtsYywHaPWV6gVsj+O8UQ x1ylrl3ssRecQotVzhWdBEV7EvX3gOL3Njs2XMSqCV57wxlKls3yoAcPzHDD5z0cZrTBqT4ln9rK</X509Certificate>
                    <X509CRL>MIIwAzCCLusCAQEwDQYJKoZIhvcNAQEFBQAwNTELMAkGA1UEBhMCSVQxDjAMBgNVBAoTBVNvZ2Vp MRYwFAYDVQQDEw1DQSBTb2dlaSBUZXN0Fw0xNTAyMDUyMzAxMDlaFw0xNTAyMDYyMzA1MDlaMIIu TjA6AgEIFw0xMzA1MjgxMjE5MzhaMCYwGAYDVR0YBBEYDzIwMTMwNTI4MTIxOTAwWjAKBgNVHRUE AwoBBDATAgIApBcNMTMwNjEzMTUwMjIxWjATAgIBJxcNMTMwNzI1MTA0NzQwWjATAgIBJhcNMTMw NzI1MTA0NzUyWjA7AgIBJRcNMTMwOTI1MTQ1NjA3WjAmMBgGA1UdGAQRGA8yMDEzMDkyNTE0NTYw MFowCgYDVR0VBAMKAQQwOwICATQXDTEzMDkyNTE0NTYwOVowJjAYBgNVHRgEERgPMjAxMzA5MjUx NDU2MDBaMAoGA1UdFQQDCgEEMDsCAgE1Fw0xMzA5MjYwOTA2MDFaMCYwGAYDVR0YBBEYDzIwMTMw OTI2MDkwNjAwWjAKBgNVHRUEAwoBBDA7AgIBNhcNMTMwOTI2MDkyOTQ1WjAmMBgGA1UdGAQRGA8y MDEzMDkyNjA5MzAwMFowCgYDVR0VBAMKAQQwOwICATcXDTEzMDkyNjA5Mjk0N1owJjAYBgNVHRgE ERgPMjAxMzA5MjYwOTMwMDBaMAoGA1UdFQQDCgEEMDsCAgE4Fw0xMzA5MjYwOTQ1MjFaMCYwGAYD VR0YBBEYDzIwMTMwOTI2MDk0NjAwWjAKBgNVHRUEAwoBBDA7AgIBORcNMTMwOTI2MTIwNjIxWjAm MBgGA1UdGAQRGA8yMDEzMDkyNjEyMDYwMFowCgYDVR0VBAMKAQQwOwICAToXDTEzMDkyNjEzMTkw NVowJjAYBgNVHRgEERgPMjAxMzA5MjYxMzE5MDBaMAoGA1UdFQQDCgEEMDsCAgE7Fw0xMzA5MjYx MzMzNDdaMCYwGAYDVR0YBBEYDzIwMTMwOTI2MTMzNDAwWjAKBgNVHRUEAwoBBDA7AgIBbBcNMTMx MDA3MTIzOTM4WjAmMBgGA1UdGAQRGA8yMDEzMTAwNzEyMzkwMFowCgYDVR0VBAMKAQQwLwICAbMX DTEzMTAzMTEyMjEwMlowGjAYBgNVHRgEERgPMjAxMzEwMzExMjIxMDBaMC8CAgGyFw0xMzEwMzEx MjIxMjJaMBowGAYDVR0YBBEYDzIwMTMxMDMxMTIyMTAwWjATAgIBtBcNMTMxMDMxMTUwMDUxWjAT AgIBtRcNMTMxMDMxMTUwMDU5WjATAgIBthcNMTMxMDMxMTUwMzAxWjA7AgIDaRcNMTQwNTIwMTY0 NTQ5WjAmMBgGA1UdGAQRGA8yMDE0MDUyMDE2NDYwMFowCgYDVR0VBAMKAQQwOwICA1MXDTEzMTIy MzEzNTYwN1owJjAYBgNVHRgEERgPMjAxMzEyMjMxMzU2MDBaMAoGA1UdFQQDCgEEMBMCAgPGFw0x NDA2MDkxMzE2NDZaMDsCAgNqFw0xNDA1MjAxNjQ1NTFaMCYwGAYDVR0YBBEYDzIwMTQwNTIwMTY0 NjAwWjAKBgNVHRUEAwoBBDA7AgIEfhcNMTQxMDEzMTUwMDA3WjAmMBgGA1UdGAQRGA8yMDE0MTAx MzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBH8XDTE0MTAxMzE1MDAyMVowJjAYBgNVHRgEERgPMjAx NDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSBFw0xNDEwMTMxNTAwMjJaMCYwGAYDVR0YBBEY DzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEgBcNMTQxMDEzMTUwMDI1WjAmMBgGA1Ud GAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBIMXDTE0MTAxMzE1MDAyNlowJjAY BgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSCFw0xNDEwMTMxNTAwMjda MCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEhRcNMTQxMDEzMTUw MDI4WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBIQXDTE0MTAx MzE1MDAzMVowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSGFw0x NDEwMTMxNTAwMzJaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIE hxcNMTQxMDEzMTUwMDMzWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQw OwICBIkXDTE0MTAxMzE1MDAzNFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQD CgEEMDsCAgSNFw0xNDEwMTMxNTAwMzdaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNV HRUEAwoBBDA7AgIEixcNMTQxMDEzMTUwMDM4WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDEwMFow CgYDVR0VBAMKAQQwOwICBIoXDTE0MTAxMzE1MDAzOVowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAx MDBaMAoGA1UdFQQDCgEEMDsCAgSIFw0xNDEwMTMxNTAwNDFaMCYwGAYDVR0YBBEYDzIwMTQxMDEz MTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEjBcNMTQxMDEzMTUwMDQzWjAmMBgGA1UdGAQRGA8yMDE0 MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBI4XDTE0MTAxMzE1MDA0NFowJjAYBgNVHRgEERgP MjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSRFw0xNDEwMTMxNTAwNDVaMCYwGAYDVR0Y BBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEjxcNMTQxMDEzMTUwMDQ3WjAmMBgG A1UdGAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBJUXDTE0MTAxMzE1MDA0OFow JjAYBgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSTFw0xNDEwMTMxNTAw NDlaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMjAwWjAKBgNVHRUEAwoBBDA7AgIElBcNMTQxMDEz MTUwMDUxWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDIwMFowCgYDVR0VBAMKAQQwOwICBJAXDTE0 MTAxMzE1MDA1M1owJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAyMDBaMAoGA1UdFQQDCgEEMDsCAgSS Fw0xNDEwMTMxNTAwNTVaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMjAwWjAKBgNVHRUEAwoBBDA7 AgIElhcNMTQxMDEzMTU0MTI1WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMK AQQwOwICBJcXDTE0MTAxMzE1NDEyNlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1Ud FQQDCgEEMDsCAgSYFw0xNDEwMTMxNTQxMjZaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAK BgNVHRUEAwoBBDA7AgIEnBcNMTQxMDEzMTU0MTI3WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIw MFowCgYDVR0VBAMKAQQwOwICBK4XDTE0MTAxMzE1NDEzMFowJjAYBgNVHRgEERgPMjAxNDEwMTMx NTQyMDBaMAoGA1UdFQQDCgEEMDsCAgSvFw0xNDEwMTMxNTQxMzBaMCYwGAYDVR0YBBEYDzIwMTQx MDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEsRcNMTQxMDEzMTU0MTMxWjAmMBgGA1UdGAQRGA8y MDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBLMXDTE0MTAxMzE1NDEzMlowJjAYBgNVHRgE ERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgSbFw0xNDEwMTMxNTQxMzVaMCYwGAYD VR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEmhcNMTQxMDEzMTU0MTM2WjAm MBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBJkXDTE0MTAxMzE1NDEz N1owJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgSdFw0xNDEwMTMx NTQxMzhaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEtBcNMTQx MDEzMTU0MTQwWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBLAX DTE0MTAxMzE1NDE0MFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsC AgSyFw0xNDEwMTMxNTQxNDJaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoB BDA7AgIEtRcNMTQxMDEzMTU0MTQzWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0V BAMKAQQwOwICBJ4XDTE0MTAxMzE1NDE0NFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoG A1UdFQQDCgEEMDsCAgSfFw0xNDEwMTMxNTQxNDRaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAw WjAKBgNVHRUEAwoBBDA7AgIEoBcNMTQxMDEzMTU0MTQ3WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1 NDIwMFowCgYDVR0VBAMKAQQwOwICBKMXDTE0MTAxMzE1NDE0OFowJjAYBgNVHRgEERgPMjAxNDEw MTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgS4Fw0xNDEwMTMxNTQxNTBaMCYwGAYDVR0YBBEYDzIw MTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEthcNMTQxMDEzMTU0MTUwWjAmMBgGA1UdGAQR GA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBLcXDTE0MTAxMzE1NDE1MVowJjAYBgNV HRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgS6Fw0xNDEwMTMxNTQxNTJaMCYw GAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEohcNMTQxMDEzMTU0MTU1 WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBKEXDTE0MTAxMzE1 NDE1NlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgSkFw0xNDEw MTMxNTQxNTZaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIEphcN MTQxMDEzMTU0MTU3WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwIC BLkXDTE0MTAxMzE1NDIwMFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEE MDsCAgS7Fw0xNDEwMTMxNTQyMDBaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUE AwoBBDA7AgIEvRcNMTQxMDEzMTU0MjAxWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYD VR0VBAMKAQQwOwICBLwXDTE0MTAxMzE1NDIwMlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBa MAoGA1UdFQQDCgEEMDsCAgSoFw0xNDEwMTMxNTQyMDRaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0 MzAwWjAKBgNVHRUEAwoBBDA7AgIEqhcNMTQxMDEzMTU0MjA2WjAmMBgGA1UdGAQRGA8yMDE0MTAx MzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBKUXDTE0MTAxMzE1NDIwNlowJjAYBgNVHRgEERgPMjAx NDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgSnFw0xNDEwMTMxNTQyMDhaMCYwGAYDVR0YBBEY DzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIEwRcNMTQxMDEzMTU0MjA4WjAmMBgGA1Ud GAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBL8XDTE0MTAxMzE1NDIxMFowJjAY BgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgS+Fw0xNDEwMTMxNTQyMTFa MCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIEwxcNMTQxMDEzMTU0 MjEyWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBKkXDTE0MTAx MzE1NDIxM1owJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgSrFw0x NDEwMTMxNTQyMTRaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIE wBcNMTQxMDEzMTU0MjE1WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQw OwICBK0XDTE0MTAxMzE1NDIxNlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQD CgEEMDsCAgTCFw0xNDEwMTMxNTQyMThaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNV HRUEAwoBBDA7AgIExRcNMTQxMDEzMTU0MjE4WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFow CgYDVR0VBAMKAQQwOwICBKwXDTE0MTAxMzE1NDIyMFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQz MDBaMAoGA1UdFQQDCgEEMDsCAgTEFw0xNDEwMTMxNTQyMjFaMCYwGAYDVR0YBBEYDzIwMTQxMDEz MTU0MzAwWjAKBgNVHRUEAwoBBDAhAgIEyRcNMTQxMDI5MTMxMDM5WjAMMAoGA1UdFQQDCgEGMBMC AgTMFw0xNDExMDUxNDM3NTlaMBMCAgTNFw0xNDExMDUxNDM4MDZaMBMCAgTOFw0xNDExMDUxNDM4 MTFaMBMCAgTPFw0xNDExMDUxNDM4MTdaMDsCAgGHFw0xNDExMjQxMzI4MTVaMCYwGAYDVR0YBBEY DzIwMTQxMTI0MTMyOTAwWjAKBgNVHRUEAwoBBDA7AgIE5BcNMTQxMTI0MTMyODE3WjAmMBgGA1Ud GAQRGA8yMDE0MTEyNDEzMjkwMFowCgYDVR0VBAMKAQQwOwICBOYXDTE0MTEyNTE2MTM0N1owJjAY BgNVHRgEERgPMjAxNDExMjUxNjE1MDBaMAoGA1UdFQQDCgEEMDsCAgTnFw0xNDExMjUxNjIxMjla MCYwGAYDVR0YBBEYDzIwMTQxMTI1MTYyMjAwWjAKBgNVHRUEAwoBBDA7AgIE6BcNMTQxMTI2MDgy ODUxWjAmMBgGA1UdGAQRGA8yMDE0MTEyNjA4MzAwMFowCgYDVR0VBAMKAQQwOwICBQwXDTE1MDEy NzExMzAyNVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMwMDBaMAoGA1UdFQQDCgEEMDsCAgUNFw0x NTAxMjcxMTMwMjdaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMDAwWjAKBgNVHRUEAwoBBDA7AgIF JBcNMTUwMTI3MTEzMDI5WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzAwMFowCgYDVR0VBAMKAQQw OwICBQ8XDTE1MDEyNzExMzAzMVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMwMDBaMAoGA1UdFQQD CgEEMDsCAgUlFw0xNTAxMjcxMTMwMzVaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMDAwWjAKBgNV HRUEAwoBBDA7AgIFDhcNMTUwMTI3MTEzMDM3WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzAwMFow CgYDVR0VBAMKAQQwOwICBSgXDTE1MDEyNzExMzAzOVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMw MDBaMAoGA1UdFQQDCgEEMDsCAgUQFw0xNTAxMjcxMTMwNDFaMCYwGAYDVR0YBBEYDzIwMTUwMTI3 MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFJxcNMTUwMTI3MTEzMDQzWjAmMBgGA1UdGAQRGA8yMDE1 MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBREXDTE1MDEyNzExMzA0NVowJjAYBgNVHRgEERgP MjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUmFw0xNTAxMjcxMTMwNDdaMCYwGAYDVR0Y BBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFEhcNMTUwMTI3MTEzMDUxWjAmMBgG A1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBSkXDTE1MDEyNzExMzA1M1ow JjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUTFw0xNTAxMjcxMTMw NTVaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFKhcNMTUwMTI3 MTEzMDU3WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBRQXDTE1 MDEyNzExMzA1OVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUr Fw0xNTAxMjcxMTMxMDNaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7 AgIFFRcNMTUwMTI3MTEzMTA1WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMK AQQwOwICBSwXDTE1MDEyNzExMzEwN1owJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1Ud FQQDCgEEMDsCAgUWFw0xNTAxMjcxMTMxMDlaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAK BgNVHRUEAwoBBDA7AgIFLRcNMTUwMTI3MTEzMTExWjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEw MFowCgYDVR0VBAMKAQQwOwICBRcXDTE1MDEyNzExMzExM1owJjAYBgNVHRgEERgPMjAxNTAxMjcx MTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUuFw0xNTAxMjcxMTMxMTVaMCYwGAYDVR0YBBEYDzIwMTUw MTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFGBcNMTUwMTI3MTEzMTE5WjAmMBgGA1UdGAQRGA8y MDE1MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBS8XDTE1MDEyNzExMzEyMVowJjAYBgNVHRgE ERgPMjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUZFw0xNTAxMjcxMTMxMjNaMCYwGAYD VR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFMBcNMTUwMTI3MTEzMTI1WjAm MBgGA1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBR8XDTE1MDEyNzExMzEy N1owJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUxFw0xNTAxMjcx MTMxMzFaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFHRcNMTUw MTI3MTEzMTMzWjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBTIX DTE1MDEyNzExMzEzNVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsC AgUaFw0xNTAxMjcxMTMxMzdaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoB BDA7AgIFMxcNMTUwMTI3MTEzMTM5WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0V BAMKAQQwOwICBRsXDTE1MDEyNzExMzE0MVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMyMDBaMAoG A1UdFQQDCgEEMDsCAgU0Fw0xNTAxMjcxMTMxNDNaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMjAw WjAKBgNVHRUEAwoBBDA7AgIFHBcNMTUwMTI3MTEzMTQ3WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzEx MzIwMFowCgYDVR0VBAMKAQQwOwICBTYXDTE1MDEyNzExMzE0OVowJjAYBgNVHRgEERgPMjAxNTAx MjcxMTMyMDBaMAoGA1UdFQQDCgEEMDsCAgUeFw0xNTAxMjcxMTMxNTFaMCYwGAYDVR0YBBEYDzIw MTUwMTI3MTEzMjAwWjAKBgNVHRUEAwoBBDA7AgIFNRcNMTUwMTI3MTEzMTUzWjAmMBgGA1UdGAQR GA8yMDE1MDEyNzExMzIwMFowCgYDVR0VBAMKAQQwOwICBTcXDTE1MDEyNzExMzE1NVowJjAYBgNV HRgEERgPMjAxNTAxMjcxMTMyMDBaMAoGA1UdFQQDCgEEMDsCAgUgFw0xNTAxMjcxMTMxNTlaMCYw GAYDVR0YBBEYDzIwMTUwMTI3MTEzMjAwWjAKBgNVHRUEAwoBBDA7AgIFOBcNMTUwMTI3MTEzMjAx WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzIwMFowCgYDVR0VBAMKAQQwOwICBSEXDTE1MDEyNzEx MzIwM1owJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMyMDBaMAoGA1UdFQQDCgEEMDsCAgU5Fw0xNTAx MjcxMTMyMDVaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMjAwWjAKBgNVHRUEAwoBBDA7AgIFIhcN MTUwMTI3MTEzMjA3WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzIwMFowCgYDVR0VBAMKAQQwOwIC BToXDTE1MDEyNzExMzIwOVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMyMDBaMAoGA1UdFQQDCgEE MDsCAgUjFw0xNTAxMjcxMTMyMTFaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMjAwWjAKBgNVHRUE AwoBBDA7AgIFOxcNMTUwMTI3MTEzMjEzWjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzIwMFowCgYD VR0VBAMKAQQwOwICBT0XDTE1MDEyNzE3MjgzOVowJjAYBgNVHRgEERgPMjAxNTAxMjcxNzI4MDBa MAoGA1UdFQQDCgEEMDsCAgU8Fw0xNTAxMjcxNzI4MzlaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTcy ODAwWjAKBgNVHRUEAwoBBDA7AgIFQBcNMTUwMTI3MTcyOTAzWjAmMBgGA1UdGAQRGA8yMDE1MDEy NzE3MjkwMFowCgYDVR0VBAMKAQQwOwICBT4XDTE1MDEyNzE3MjkwOVowJjAYBgNVHRgEERgPMjAx NTAxMjcxNzI5MDBaMAoGA1UdFQQDCgEEMDsCAgU/Fw0xNTAxMjcxNzI5MTFaMCYwGAYDVR0YBBEY DzIwMTUwMTI3MTcyOTAwWjAKBgNVHRUEAwoBBDA7AgIFQhcNMTUwMTI3MTcyOTEzWjAmMBgGA1Ud GAQRGA8yMDE1MDEyNzE3MjkwMFowCgYDVR0VBAMKAQQwOwICBUEXDTE1MDEyNzE3MjkxM1owJjAY BgNVHRgEERgPMjAxNTAxMjcxNzI5MDBaMAoGA1UdFQQDCgEEMDsCAgVQFw0xNTAxMjcxNzI5MTVa MCYwGAYDVR0YBBEYDzIwMTUwMTI3MTcyOTAwWjAKBgNVHRUEAwoBBDA7AgIFQxcNMTUwMTI3MTcy OTE3WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzE3MjkwMFowCgYDVR0VBAMKAQQwOwICBUQXDTE1MDEy NzE3MjkxN1owJjAYBgNVHRgEERgPMjAxNTAxMjcxNzI5MDBaMAoGA1UdFQQDCgEEMDsCAgVRFw0x NTAxMjcxNzI5MTlaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTcyOTAwWjAKBgNVHRUEAwoBBDA7AgIF SxcNMTUwMTI3MTcyOTIwWjAmMBgGA1UdGAQRGA8yMDE1MDEyNzE3MjkwMFowCgYDVR0VBAMKAQQw OwICBUoXDTE1MDEyNzE3MjkyMlowJjAYBgNVHRgEERgPMjAxNTAxMjcxNzI5MDBaMAoGA1UdFQQD CgEEMDsCAgVFFw0xNTAxMjcxNzI5MjJaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTcyOTAwWjAKBgNV HRUEAwoBBDA7AgIFTRcNMTUwMTI3MTcyOTIzWjAmMBgGA1UdGAQRGA8yMDE1MDEyNzE3MjkwMFow CgYDVR0VBAMKAQQwOwICBUcXDTE1MDEyNzE3MjkyNFowJjAYBgNVHRgEERgPMjAxNTAxMjcxNzI5 MDBaMAoGA1UdFQQDCgEEMDsCAgVJFw0xNTAxMjcxNzI5MjRaMCYwGAYDVR0YBBEYDzIwMTUwMTI3 MTcyOTAwWjAKBgNVHRUEAwoBBDA7AgIFRhcNMTUwMTI3MTcyOTI1WjAmMBgGA1UdGAQRGA8yMDE1 MDEyNzE3MjkwMFowCgYDVR0VBAMKAQQwOwICBUgXDTE1MDEyNzE3MjkyNlowJjAYBgNVHRgEERgP MjAxNTAxMjcxNzI5MDBaMAoGA1UdFQQDCgEEMDsCAgVSFw0xNTAxMjcxNzI5MjhaMCYwGAYDVR0Y BBEYDzIwMTUwMTI3MTcyOTAwWjAKBgNVHRUEAwoBBDA7AgIFTBcNMTUwMTI3MTcyOTI4WjAmMBgG A1UdGAQRGA8yMDE1MDEyNzE3MjkwMFowCgYDVR0VBAMKAQQwOwICBU4XDTE1MDEyNzE3MjkyOVow JjAYBgNVHRgEERgPMjAxNTAxMjcxNzI5MDBaMAoGA1UdFQQDCgEEMDsCAgVTFw0xNTAxMjcxNzI5 MjlaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTcyOTAwWjAKBgNVHRUEAwoBBDA7AgIFTxcNMTUwMTI3 MTcyOTMwWjAmMBgGA1UdGAQRGA8yMDE1MDEyNzE3MjkwMFowCgYDVR0VBAMKAQQwOwICBVYXDTE1 MDEzMDEwMzYzNVowJjAYBgNVHRgEERgPMjAxNTAxMzAxMDM2MDBaMAoGA1UdFQQDCgEEMDsCAgVX Fw0xNTAxMzAxMDM2MzdaMCYwGAYDVR0YBBEYDzIwMTUwMTMwMTAzNjAwWjAKBgNVHRUEAwoBBDA7 AgIFWBcNMTUwMTMwMTAzNjQxWjAmMBgGA1UdGAQRGA8yMDE1MDEzMDEwMzYwMFowCgYDVR0VBAMK AQQwOwICBVkXDTE1MDEzMDEwMzY0MVowJjAYBgNVHRgEERgPMjAxNTAxMzAxMDM3MDBaMAoGA1Ud FQQDCgEEMDsCAgVaFw0xNTAxMzAxMDM2NDVaMCYwGAYDVR0YBBEYDzIwMTUwMTMwMTAzNzAwWjAK BgNVHRUEAwoBBDA7AgIFWxcNMTUwMTMwMTAzNjQ3WjAmMBgGA1UdGAQRGA8yMDE1MDEzMDEwMzcw MFowCgYDVR0VBAMKAQQwOwICBVwXDTE1MDEzMDEwMzY1MVowJjAYBgNVHRgEERgPMjAxNTAxMzAx MDM3MDBaMAoGA1UdFQQDCgEEMDsCAgVdFw0xNTAxMzAxMDM2NTNaMCYwGAYDVR0YBBEYDzIwMTUw MTMwMTAzNzAwWjAKBgNVHRUEAwoBBDA7AgIFXhcNMTUwMTMwMTAzNjU1WjAmMBgGA1UdGAQRGA8y MDE1MDEzMDEwMzcwMFowCgYDVR0VBAMKAQQwOwICBV8XDTE1MDEzMDEwMzY1N1owJjAYBgNVHRgE ERgPMjAxNTAxMzAxMDM3MDBaMAoGA1UdFQQDCgEEMDsCAgVgFw0xNTAxMzAxMDM3MDFaMCYwGAYD VR0YBBEYDzIwMTUwMTMwMTAzNzAwWjAKBgNVHRUEAwoBBDA7AgIFYRcNMTUwMTMwMTAzNzAzWjAm MBgGA1UdGAQRGA8yMDE1MDEzMDEwMzcwMFowCgYDVR0VBAMKAQQwOwICBWIXDTE1MDEzMDEwMzcw NVowJjAYBgNVHRgEERgPMjAxNTAxMzAxMDM3MDBaMAoGA1UdFQQDCgEEMDsCAgVjFw0xNTAxMzAx MDM3MDlaMCYwGAYDVR0YBBEYDzIwMTUwMTMwMTAzNzAwWjAKBgNVHRUEAwoBBDA7AgIFZBcNMTUw MTMwMTAzNzExWjAmMBgGA1UdGAQRGA8yMDE1MDEzMDEwMzcwMFowCgYDVR0VBAMKAQQwOwICBWUX DTE1MDEzMDEwMzcxM1owJjAYBgNVHRgEERgPMjAxNTAxMzAxMDM3MDBaMAoGA1UdFQQDCgEEMDsC AgVmFw0xNTAxMzAxMDM3MTdaMCYwGAYDVR0YBBEYDzIwMTUwMTMwMTAzNzAwWjAKBgNVHRUEAwoB BDA7AgIFZxcNMTUwMTMwMTAzNzE5WjAmMBgGA1UdGAQRGA8yMDE1MDEzMDEwMzcwMFowCgYDVR0V BAMKAQQwOwICBWgXDTE1MDEzMDEwMzcyMVowJjAYBgNVHRgEERgPMjAxNTAxMzAxMDM3MDBaMAoG A1UdFQQDCgEEMDsCAgVqFw0xNTAxMzAxMDM3MjNaMCYwGAYDVR0YBBEYDzIwMTUwMTMwMTAzNzAw WjAKBgNVHRUEAwoBBDA7AgIFaRcNMTUwMTMwMTAzNzI3WjAmMBgGA1UdGAQRGA8yMDE1MDEzMDEw MzcwMFowCgYDVR0VBAMKAQQwOwICBW0XDTE1MDEzMDEwMzcyOVowJjAYBgNVHRgEERgPMjAxNTAx MzAxMDM3MDBaMAoGA1UdFQQDCgEEMDsCAgVrFw0xNTAxMzAxMDM3MzFaMCYwGAYDVR0YBBEYDzIw MTUwMTMwMTAzNzAwWjAKBgNVHRUEAwoBBDA7AgIFbBcNMTUwMTMwMTAzNzMzWjAmMBgGA1UdGAQR GA8yMDE1MDEzMDEwMzcwMFowCgYDVR0VBAMKAQQwEwICBXEXDTE1MDIwMzE2MzkxMFowEwICBW8X DTE1MDIwMzE2MzkxOVowEwICBXAXDTE1MDIwMzE2NTAyMVowEwICBXMXDTE1MDIwMzE2NTEwMVqg MDAuMAsGA1UdFAQEAgIChDAfBgNVHSMEGDAWgBRXw3zNFaJhEwprPuHGSexOQx/DhzANBgkqhkiG 9w0BAQUFAAOCAQEAfV4HT6Nur8J/bjxI8Bcgzv1bXG/fqhMW5foXQbT4Ue3OxnMr+9nUCoYI4PSK pvelPsXsZYOIehvHclqrAzrs8QUJ8agExKHJYmn7yK5nGF1fZH3CWwGElw1xgXdlUXcwLbVENo4T GZiv/dBKQ7eXju/TcANvY/Zib+HPcnFgjxX0Ca8wn8FE65OZLi4Xq/e20LDqvMhw5j5zSomhSpUU 0VOXxR1bffalGaEZjAAaH4lcc9DQkXeQJQq9gRLhwSw/3NVBpI6etoD1BwVRMsFFtJ/mD63sBjYT 658zI+PSGdwclVVxiJBCD3kCKd41nn2e1s5IVTVSRYhEa6keZIqaeA==</X509CRL>
                </X509Data>
              </KeyInfo>
          </Signature>
        </marcaDaBollo>
        """
      And RPT generation
        """
        <?xml version="1.0" encoding="UTF-8"?>
          <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_2_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>idMsgRichiesta</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
                <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
                <pay_i:importoTotaleDaVersare>15.00</pay_i:importoTotaleDaVersare>
                <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
                <pay_i:ibanAddebito>IT45R0760103200000000001016</pay_i:ibanAddebito>
                <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
                <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
                <pay_i:datiSingoloVersamento>
                  <pay_i:importoSingoloVersamento>15.00</pay_i:importoSingoloVersamento>
                  <pay_i:commissioneCaricoPA>10.00</pay_i:commissioneCaricoPA>
                  <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
                  <pay_i:ibanAppoggio>IT45R0760103200000000001016</pay_i:ibanAppoggio>
                  <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
                  <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:datiMarcaBolloDigitale>
                      <pay_i:tipoBollo>01</pay_i:tipoBollo>
                      <pay_i:hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</pay_i:hashDocumento>
                      <pay_i:provinciaResidenza>MI</pay_i:provinciaResidenza>
                  </pay_i:datiMarcaBolloDigitale>
                </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
          </pay_i:RPT>
        """
      And RT generation
        """
          <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRicevuta>TR0001_20120302-10:37:52.0264-F098</pay_i:identificativoMessaggioRicevuta>
            <pay_i:dataOraMessaggioRicevuta>#timedate#</pay_i:dataOraMessaggioRicevuta>
            <pay_i:riferimentoMessaggioRichiesta>#timedate#</pay_i:riferimentoMessaggioRichiesta>
            <pay_i:riferimentoDataRichiesta>2012-01-26</pay_i:riferimentoDataRichiesta>
            <pay_i:istitutoAttestante>
                <pay_i:identificativoUnivocoAttestante>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>istitutoAttestan</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoAttestante>
                <pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante>
                <pay_i:codiceUnitOperAttestante>CodiceUOA</pay_i:codiceUnitOperAttestante>
                <pay_i:denomUnitOperAttestante>DenomUnitOperAttestante</pay_i:denomUnitOperAttestante>
                <pay_i:indirizzoAttestante>IndirizzoAttestante</pay_i:indirizzoAttestante>
                <pay_i:civicoAttestante>11</pay_i:civicoAttestante>
                <pay_i:capAttestante>11111</pay_i:capAttestante>
                <pay_i:localitaAttestante>LocalitaAttestante</pay_i:localitaAttestante>
                <pay_i:provinciaAttestante>ProvinciaAttestante</pay_i:provinciaAttestante>
                <pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante>
            </pay_i:istitutoAttestante>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501F</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
                <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:datiPagamento>
                <pay_i:codiceEsitoPagamento>0</pay_i:codiceEsitoPagamento>
                <pay_i:importoTotalePagato>15.00</pay_i:importoTotalePagato>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
                <pay_i:datiSingoloPagamento>
                  <pay_i:singoloImportoPagato>15.00</pay_i:singoloImportoPagato>
                  <pay_i:esitoSingoloPagamento>Pagamento effettuato</pay_i:esitoSingoloPagamento>
                  <pay_i:dataEsitoSingoloPagamento>2012-03-02</pay_i:dataEsitoSingoloPagamento>
                  <pay_i:identificativoUnivocoRiscossione>$1iuv</pay_i:identificativoUnivocoRiscossione>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica RT</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:allegatoRicevuta>
                      <pay_i:tipoAllegatoRicevuta>BD</pay_i:tipoAllegatoRicevuta>
                      <pay_i:testoAllegato>$bollo</pay_i:testoAllegato>
                  </pay_i:allegatoRicevuta>
                </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
          </pay_i:RT>
        """
      And initial XML nodoInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header>
              <ppt:intestazionePPT>
                <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
              </ppt:intestazionePPT>
          </soapenv:Header>
          <soapenv:Body>
              <ws:nodoInviaRPT>
                <password>pwdpwdpwd</password>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canaleRtPush#</identificativoCanale>
                <tipoFirma></tipoFirma>
                <rpt>$rptAttachment</rpt>
              </ws:nodoInviaRPT>
          </soapenv:Body>
        </soapenv:Envelope>
        """  
      And initial XML pspInviaRPT
        """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:pspInviaRPTResponse>
                        <pspInviaRPTResponse>
                            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                            <identificativoCarrello>$nodoInviaRPT.identificativoUnivocoVersamento</identificativoCarrello>
                            <parametriPagamentoImmediato>idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento</parametriPagamentoImmediato>
                        </pspInviaRPTResponse>
                    </ws:pspInviaRPTResponse>
                </soapenv:Body>
            </soapenv:Envelope>
        """ 
      And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
      And initial XML nodoInviaRT
        """
          <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:nodoInviaRT>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canaleRtPush#</identificativoCanale>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                  <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                  <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                  <tipoFirma></tipoFirma>
                  <forzaControlloSegno>1</forzaControlloSegno>
                  <rt>$rtAttachment</rt>
              </ws:nodoInviaRT>
          </soapenv:Body>
          </soapenv:Envelope>
        """
      And initial XML paaInviaRT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:paaInviaRTRisposta>
                <paaInviaRTRisposta>
                    <esito>OK</esito>
                </paaInviaRTRisposta>
              </ws:paaInviaRTRisposta>
          </soapenv:Body>
        </soapenv:Envelope>
        """
      And EC replies to nodo-dei-pagamenti with the paaInviaRT
      When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      And psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
      Then check esito is KO of nodoInviaRT response
      And check faultCode is PPT_SEMANTICA of nodoInviaRT response
  

    Scenario: Check faultCode PPT_SEMANTICA error on certificate validity [Bollo_8]
      Given RPT generation
        """
        <?xml version="1.0" encoding="UTF-8"?>
          <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_2_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>idMsgRichiesta</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
                <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
                <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
                <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
                <pay_i:ibanAddebito>IT45R0760103200000000001016</pay_i:ibanAddebito>
                <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
                <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
                <pay_i:datiSingoloVersamento>
                  <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
                  <pay_i:commissioneCaricoPA>10.00</pay_i:commissioneCaricoPA>
                  <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
                  <pay_i:ibanAppoggio>IT45R0760103200000000001016</pay_i:ibanAppoggio>
                  <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
                  <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:datiMarcaBolloDigitale>
                      <pay_i:tipoBollo>01</pay_i:tipoBollo>
                      <pay_i:hashDocumento>WsmwKj7w4LvPn7ao2SuU0Gc37SuV0G9H9kxTeRQU85M=</pay_i:hashDocumento>
                      <pay_i:provinciaResidenza>MI</pay_i:provinciaResidenza>
                  </pay_i:datiMarcaBolloDigitale>
                </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
          </pay_i:RPT>
        """
      And RT generation
        """
          <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRicevuta>TR0001_20120302-10:37:52.0264-F098</pay_i:identificativoMessaggioRicevuta>
            <pay_i:dataOraMessaggioRicevuta>#timedate#</pay_i:dataOraMessaggioRicevuta>
            <pay_i:riferimentoMessaggioRichiesta>#timedate#</pay_i:riferimentoMessaggioRichiesta>
            <pay_i:riferimentoDataRichiesta>2012-01-26</pay_i:riferimentoDataRichiesta>
            <pay_i:istitutoAttestante>
                <pay_i:identificativoUnivocoAttestante>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>istitutoAttestan</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoAttestante>
                <pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante>
                <pay_i:codiceUnitOperAttestante>CodiceUOA</pay_i:codiceUnitOperAttestante>
                <pay_i:denomUnitOperAttestante>DenomUnitOperAttestante</pay_i:denomUnitOperAttestante>
                <pay_i:indirizzoAttestante>IndirizzoAttestante</pay_i:indirizzoAttestante>
                <pay_i:civicoAttestante>11</pay_i:civicoAttestante>
                <pay_i:capAttestante>11111</pay_i:capAttestante>
                <pay_i:localitaAttestante>LocalitaAttestante</pay_i:localitaAttestante>
                <pay_i:provinciaAttestante>ProvinciaAttestante</pay_i:provinciaAttestante>
                <pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante>
            </pay_i:istitutoAttestante>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501F</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
                <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:datiPagamento>
                <pay_i:codiceEsitoPagamento>0</pay_i:codiceEsitoPagamento>
                <pay_i:importoTotalePagato>10.00</pay_i:importoTotalePagato>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
                <pay_i:datiSingoloPagamento>
                  <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
                  <pay_i:esitoSingoloPagamento>Pagamento effettuato</pay_i:esitoSingoloPagamento>
                  <pay_i:dataEsitoSingoloPagamento>2012-03-02</pay_i:dataEsitoSingoloPagamento>
                  <pay_i:identificativoUnivocoRiscossione>$1iuv</pay_i:identificativoUnivocoRiscossione>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica RT</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:allegatoRicevuta>
                      <pay_i:tipoAllegatoRicevuta>BD</pay_i:tipoAllegatoRicevuta>
                      <pay_i:testoAllegato>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PG1hcmNhRGFCb2xsbyB4bWxucz0iaHR0cDovL3d3dy5hZ2VuemlhZW50cmF0ZS5nb3YuaXQvMjAxNC9NYXJjYURhQm9sbG8iIHhtbG5zOm5zMj0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PFBTUD48Q29kaWNlRmlzY2FsZT4xMjM0NTY3ODkwMTwvQ29kaWNlRmlzY2FsZT48RGVub21pbmF6aW9uZT5pZFBzcDE8L0Rlbm9taW5hemlvbmU+PC9QU1A+PElVQkQ+OTk5OTAwMDAwMDAzMDE8L0lVQkQ+PE9yYUFjcXVpc3RvPjIwMTUtMDItMDlUMTc6MDM6MDIuMzcwKzAxOjAwPC9PcmFBY3F1aXN0bz48SW1wb3J0bz4xMC4wMDwvSW1wb3J0bz48VGlwb0JvbGxvPjAxPC9UaXBvQm9sbG8+PEltcHJvbnRhRG9jdW1lbnRvPjxEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNzaGEyNTYiLz48bnMyOkRpZ2VzdFZhbHVlPmdlZllaYWFCdlZleHlsZXQ5cW9jZFRGN1dybDFnZnB5TVNNLzI4SWZDQlU9PC9uczI6RGlnZXN0VmFsdWU+PC9JbXByb250YURvY3VtZW50bz48U2lnbmF0dXJlIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj48U2lnbmVkSW5mbz48Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1Ii8+PFNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZHNpZy1tb3JlI3JzYS1zaGEyNTYiLz48UmVmZXJlbmNlIFVSST0iIj48VHJhbnNmb3Jtcz48VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiLz48L1RyYW5zZm9ybXM+PERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIvPjxEaWdlc3RWYWx1ZT5WN1Zrc3grN09SUG43TUxJUFBadHl2d1RTQ0JYQ3pWeFMycnZoWk1WMjkwPTwvRGlnZXN0VmFsdWU+PC9SZWZlcmVuY2U+PC9TaWduZWRJbmZvPjxTaWduYXR1cmVWYWx1ZT5zdmdaYXRZR2hYSVF1UnVaTmp4ZkdhY0FHSXZxM1VabHpmOXJWeUN1WHhvM0Z1dnFxN1htY09RN3BwVWx6SXNUSnJGUmEzM2NlN0UxDQpxN0ZqaUQ2Tm55RnZQVHI4UFpIc1JIVHFXUEphUDFjaGpkazlrYkQ0U2ZwSk53R1JqMUtVdThCVHltbGhsb09ySGZBbmRZQWtMRVREDQptYnZQZTFzdEU1dUMraWNjVG1Rc3VhVW55elA5OVF1bkN2cEFZMUUwdUcyM1kyNEFLQXhvTS9xWjFSbFc3bnJaMGRpOGhwaWxHeVJVDQp1S2FESEZ4Rk04U1FNczN5RUtOYTBqQTUrN0xmRTBwMWxyL2FCM2VOSldBNFFuZHJvRDl5QUxNOHl6RERXSEY3UGl6Qi90NXJORzZyDQo5N1pBaEFSMU9qVG1PdUI1K09PVFVkYkhSWTRTTzJhclNCM3p3Zz09PC9TaWduYXR1cmVWYWx1ZT48S2V5SW5mbyBJZD0ia2V5aW5mbyI+PFg1MDlEYXRhPjxYNTA5Q2VydGlmaWNhdGU+TUlJRGpEQ0NBblNnQXdJQkFnSUNCWEl3RFFZSktvWklodmNOQVFFRkJRQXdOVEVMTUFrR0ExVUVCaE1DU1ZReERqQU1CZ05WQkFvVA0KQlZOdloyVnBNUll3RkFZRFZRUURFdzFEUVNCVGIyZGxhU0JVWlhOME1CNFhEVEUxTURJd016RTJNRGMxTUZvWERUSXhNREl3TXpFMg0KTURZeU9Gb3dTVEVMTUFrR0ExVUVCaE1DU1ZReER6QU5CZ05WQkFvVEJtbGtVSE53TVRFTU1Bb0dBMVVFQ3hNRFVGTlFNUnN3R1FZRA0KVlFRREV4SXhNak0wTlRZM09Ea3dNU0JwWkZCemNERXdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFDOQ0KQ3hPZXppb2UvNXEraDNKN0lTdkJoQUtnQVRVMkRHanpvY0ZOR0ljemNxUE5GbGFFTWk4ek1hY080eTlIeDNPOUkvNGR1akN5dFFuRQ0KelpvUGFYVm5kSmNFVmhvWmk1alNXa3lrQURkVFpxWCtseE5maEdKcXNhc2lvVk4ycmk1SVppVEZ5MjJ0QkRQaUovejFOcmJBVFJ0Sw0KcEZSdUV1UEVCbTYxbnQxSU1kWU9wMCtXaWhXRmJ6VnNCLyswWGRlN3FwY0xrS0V4UEIzTmlnVllBZ0dnby96OFo4OUZ0RjlzeGdSQw0KQUVLQ0FERFpMVEN1ak0vTUFOaFl2N3RZQ29lODFOSVlZa09JbkFmR0VyditZbkg3Ukl5Vndxa2JOaE1YYXZzQWd2MVVjZDlKVVVBVg0KVHc2RXpJb21zVU5xQnd0eWl4U0tvSHFmL09VblIrR3B1azJOQWdNQkFBR2pnWkV3Z1k0d0RnWURWUjBQQVFIL0JBUURBZ1pBTUYwRw0KQTFVZEl3UldNRlNBRkZmRGZNMFZvbUVUQ21zKzRjWko3RTVESDhPSG9UbWtOekExTVFzd0NRWURWUVFHRXdKSlZERU9NQXdHQTFVRQ0KQ2hNRlUyOW5aV2t4RmpBVUJnTlZCQU1URFVOQklGTnZaMlZwSUZSbGMzU0NBUUV3SFFZRFZSME9CQllFRkRIZCtmbHpRQTVOUUFMSw0KWk1TZHFwcjZURjdWTUEwR0NTcUdTSWIzRFFFQkJRVUFBNElCQVFBSVpacEFEa0ZhRkY3VXAyK3h1R2tDMTRDcVlCUENRbERxcW8vLw0KdThwSi83N2NRMThqcXVxb1FJbncwdkVwWDN0dFJqSVNscnNISFVUL0hBQjdJM0E5Vkp3YlEyZXpaSE9uZFVCS2VCSjVrQllDc1RBag0KTEtVYzNpYWt0ZW9hVHdRVVVxT3ZVYVJxb2laZzlXN2FCZGlnekZXcTd0aFlTaTF6emVncXZRVHR2ekdxVS9EdWVtN2t5MVNHZS8zRA0KTnhwZWVVM0pHcUt4cGkyTE5nNnJpVlhPdXU5bWprSXpyVDBPa0dqY2RZKzh1RjhJayt3Q3Byalh0c1l5d0hhUFdWNmdWc2orTzhVUQ0KeDF5bHJsM3NzUmVjUW90VnpoV2RCRVY3RXZYM2dPTDNOanMyWE1TcUNWNTd3eGxLbHMzeW9BY1B6SERENXowY1pyVEJxVDRsbjlySzwvWDUwOUNlcnRpZmljYXRlPjxYNTA5Q1JMPk1JSXdBekNDTHVzQ0FRRXdEUVlKS29aSWh2Y05BUUVGQlFBd05URUxNQWtHQTFVRUJoTUNTVlF4RGpBTUJnTlZCQW9UQlZOdloyVnANCk1SWXdGQVlEVlFRREV3MURRU0JUYjJkbGFTQlVaWE4wRncweE5UQXlNRFV5TXpBeE1EbGFGdzB4TlRBeU1EWXlNekExTURsYU1JSXUNClRqQTZBZ0VJRncweE16QTFNamd4TWpFNU16aGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UTXdOVEk0TVRJeE9UQXdXakFLQmdOVkhSVUUNCkF3b0JCREFUQWdJQXBCY05NVE13TmpFek1UVXdNakl4V2pBVEFnSUJKeGNOTVRNd056STFNVEEwTnpRd1dqQVRBZ0lCSmhjTk1UTXcNCk56STFNVEEwTnpVeVdqQTdBZ0lCSlJjTk1UTXdPVEkxTVRRMU5qQTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERXpNRGt5TlRFME5UWXcNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0FUUVhEVEV6TURreU5URTBOVFl3T1Zvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TXpBNU1qVXgNCk5EVTJNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ0UxRncweE16QTVNall3T1RBMk1ERmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UTXcNCk9USTJNRGt3TmpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJQk5oY05NVE13T1RJMk1Ea3lPVFExV2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERXpNRGt5TmpBNU16QXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNBVGNYRFRFek1Ea3lOakE1TWprME4xb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TXpBNU1qWXdPVE13TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdFNEZ3MHhNekE1TWpZd09UUTFNakZhTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UTXdPVEkyTURrME5qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUJPUmNOTVRNd09USTJNVEl3TmpJeFdqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREV6TURreU5qRXlNRFl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQVRvWERURXpNRGt5TmpFek1Ua3cNCk5Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE16QTVNall4TXpFNU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnRTdGdzB4TXpBNU1qWXgNCk16TXpORGRhTUNZd0dBWURWUjBZQkJFWUR6SXdNVE13T1RJMk1UTXpOREF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lCYkJjTk1UTXgNCk1EQTNNVEl6T1RNNFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFek1UQXdOekV5TXprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3THdJQ0FiTVgNCkRURXpNVEF6TVRFeU1qRXdNbG93R2pBWUJnTlZIUmdFRVJnUE1qQXhNekV3TXpFeE1qSXhNREJhTUM4Q0FnR3lGdzB4TXpFd016RXgNCk1qSXhNakphTUJvd0dBWURWUjBZQkJFWUR6SXdNVE14TURNeE1USXlNVEF3V2pBVEFnSUJ0QmNOTVRNeE1ETXhNVFV3TURVeFdqQVQNCkFnSUJ0UmNOTVRNeE1ETXhNVFV3TURVNVdqQVRBZ0lCdGhjTk1UTXhNRE14TVRVd016QXhXakE3QWdJRGFSY05NVFF3TlRJd01UWTANCk5UUTVXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNRFV5TURFMk5EWXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNBMU1YRFRFek1USXkNCk16RXpOVFl3TjFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TXpFeU1qTXhNelUyTURCYU1Bb0dBMVVkRlFRRENnRUVNQk1DQWdQR0Z3MHgNCk5EQTJNRGt4TXpFMk5EWmFNRHNDQWdOcUZ3MHhOREExTWpBeE5qUTFOVEZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF3TlRJd01UWTANCk5qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVmaGNOTVRReE1ERXpNVFV3TURBM1dqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXgNCk16RTFNREV3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkg4WERURTBNVEF4TXpFMU1EQXlNVm93SmpBWUJnTlZIUmdFRVJnUE1qQXgNCk5ERXdNVE14TlRBeE1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU0JGdzB4TkRFd01UTXhOVEF3TWpKYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFF4TURFek1UVXdNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFZ0JjTk1UUXhNREV6TVRVd01ESTFXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFME1UQXhNekUxTURFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JJTVhEVEUwTVRBeE16RTFNREF5Tmxvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UQXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1NDRncweE5ERXdNVE14TlRBd01qZGENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFV3TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRWhSY05NVFF4TURFek1UVXcNCk1ESTRXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU1ERXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCSVFYRFRFME1UQXgNCk16RTFNREF6TVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVEF4TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTR0Z3MHgNCk5ERXdNVE14TlRBd016SmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVd01UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUUNCmh4Y05NVFF4TURFek1UVXdNRE16V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFNREV3TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCSWtYRFRFME1UQXhNekUxTURBek5Gb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRBeE1EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdTTkZ3MHhOREV3TVRNeE5UQXdNemRhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVXdNVEF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUVpeGNOTVRReE1ERXpNVFV3TURNNFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTURFd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQklvWERURTBNVEF4TXpFMU1EQXpPVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UQXgNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU0lGdzB4TkRFd01UTXhOVEF3TkRGYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXoNCk1UVXdNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFakJjTk1UUXhNREV6TVRVd01EUXpXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTANCk1UQXhNekUxTURFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JJNFhEVEUwTVRBeE16RTFNREEwTkZvd0pqQVlCZ05WSFJnRUVSZ1ANCk1qQXhOREV3TVRNeE5UQXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1NSRncweE5ERXdNVE14TlRBd05EVmFNQ1l3R0FZRFZSMFkNCkJCRVlEekl3TVRReE1ERXpNVFV3TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRWp4Y05NVFF4TURFek1UVXdNRFEzV2pBbU1CZ0cNCkExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU1ERXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCSlVYRFRFME1UQXhNekUxTURBME9Gb3cNCkpqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVEF4TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTVEZ3MHhOREV3TVRNeE5UQXcNCk5EbGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVd01qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVsQmNOTVRReE1ERXoNCk1UVXdNRFV4V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFNREl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkpBWERURTANCk1UQXhNekUxTURBMU0xb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRBeU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU1MNCkZ3MHhOREV3TVRNeE5UQXdOVFZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVXdNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTcNCkFnSUVsaGNOTVRReE1ERXpNVFUwTVRJMVdqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRJd01Gb3dDZ1lEVlIwVkJBTUsNCkFRUXdPd0lDQkpjWERURTBNVEF4TXpFMU5ERXlObG93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXlNREJhTUFvR0ExVWQNCkZRUURDZ0VFTURzQ0FnU1lGdzB4TkRFd01UTXhOVFF4TWpaYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTWpBd1dqQUsNCkJnTlZIUlVFQXdvQkJEQTdBZ0lFbkJjTk1UUXhNREV6TVRVME1USTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ESXcNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JLNFhEVEUwTVRBeE16RTFOREV6TUZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXgNCk5UUXlNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1N2RncweE5ERXdNVE14TlRReE16QmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXgNCk1ERXpNVFUwTWpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRXNSY05NVFF4TURFek1UVTBNVE14V2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERTBNVEF4TXpFMU5ESXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCTE1YRFRFME1UQXhNekUxTkRFek1sb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TkRFd01UTXhOVFF5TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTYkZ3MHhOREV3TVRNeE5UUXhNelZhTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UUXhNREV6TVRVME1qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVtaGNOTVRReE1ERXpNVFUwTVRNMldqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFOREl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkprWERURTBNVEF4TXpFMU5ERXoNCk4xb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRReU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU2RGdzB4TkRFd01UTXgNCk5UUXhNemhhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTBNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFdEJjTk1UUXgNCk1ERXpNVFUwTVRRd1dqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRJd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JMQVgNCkRURTBNVEF4TXpFMU5ERTBNRm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXlNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0MNCkFnU3lGdzB4TkRFd01UTXhOVFF4TkRKYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTWpBd1dqQUtCZ05WSFJVRUF3b0INCkJEQTdBZ0lFdFJjTk1UUXhNREV6TVRVME1UUXpXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ESXdNRm93Q2dZRFZSMFYNCkJBTUtBUVF3T3dJQ0JKNFhEVEUwTVRBeE16RTFOREUwTkZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVFF5TURCYU1Bb0cNCkExVWRGUVFEQ2dFRU1Ec0NBZ1NmRncweE5ERXdNVE14TlRReE5EUmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVME1qQXcNCldqQUtCZ05WSFJVRUF3b0JCREE3QWdJRW9CY05NVFF4TURFek1UVTBNVFEzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTENCk5ESXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCS01YRFRFME1UQXhNekUxTkRFME9Gb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXcNCk1UTXhOVFF5TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTNEZ3MHhOREV3TVRNeE5UUXhOVEJhTUNZd0dBWURWUjBZQkJFWUR6SXcNCk1UUXhNREV6TVRVME1qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUV0aGNOTVRReE1ERXpNVFUwTVRVd1dqQW1NQmdHQTFVZEdBUVINCkdBOHlNREUwTVRBeE16RTFOREl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkxjWERURTBNVEF4TXpFMU5ERTFNVm93SmpBWUJnTlYNCkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRReU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnUzZGdzB4TkRFd01UTXhOVFF4TlRKYU1DWXcNCkdBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTBNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFb2hjTk1UUXhNREV6TVRVME1UVTENCldqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRNd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JLRVhEVEUwTVRBeE16RTENCk5ERTFObG93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXpNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1NrRncweE5ERXcNCk1UTXhOVFF4TlRaYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTXpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRXBoY04NCk1UUXhNREV6TVRVME1UVTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ETXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUMNCkJMa1hEVEUwTVRBeE16RTFOREl3TUZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVFF6TURCYU1Bb0dBMVVkRlFRRENnRUUNCk1Ec0NBZ1M3RncweE5ERXdNVE14TlRReU1EQmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVME16QXdXakFLQmdOVkhSVUUNCkF3b0JCREE3QWdJRXZSY05NVFF4TURFek1UVTBNakF4V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFORE13TUZvd0NnWUQNClZSMFZCQU1LQVFRd093SUNCTHdYRFRFME1UQXhNekUxTkRJd01sb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRRek1EQmENCk1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTb0Z3MHhOREV3TVRNeE5UUXlNRFJhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTANCk16QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVxaGNOTVRReE1ERXpNVFUwTWpBMldqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXgNCk16RTFORE13TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQktVWERURTBNVEF4TXpFMU5ESXdObG93SmpBWUJnTlZIUmdFRVJnUE1qQXgNCk5ERXdNVE14TlRRek1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU25GdzB4TkRFd01UTXhOVFF5TURoYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFF4TURFek1UVTBNekF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFd1JjTk1UUXhNREV6TVRVME1qQTRXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFME1UQXhNekUxTkRNd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JMOFhEVEUwTVRBeE16RTFOREl4TUZvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXpNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1MrRncweE5ERXdNVE14TlRReU1URmENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTXpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRXd4Y05NVFF4TURFek1UVTANCk1qRXlXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ETXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCS2tYRFRFME1UQXgNCk16RTFOREl4TTFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVFF6TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTckZ3MHgNCk5ERXdNVE14TlRReU1UUmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVME16QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUUNCndCY05NVFF4TURFek1UVTBNakUxV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFORE13TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCSzBYRFRFME1UQXhNekUxTkRJeE5sb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRRek1EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdUQ0Z3MHhOREV3TVRNeE5UUXlNVGhhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTBNekF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUV4UmNOTVRReE1ERXpNVFUwTWpFNFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRNd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQkt3WERURTBNVEF4TXpFMU5ESXlNRm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXoNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVEVGdzB4TkRFd01UTXhOVFF5TWpGYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXoNCk1UVTBNekF3V2pBS0JnTlZIUlVFQXdvQkJEQWhBZ0lFeVJjTk1UUXhNREk1TVRNeE1ETTVXakFNTUFvR0ExVWRGUVFEQ2dFR01CTUMNCkFnVE1GdzB4TkRFeE1EVXhORE0zTlRsYU1CTUNBZ1RORncweE5ERXhNRFV4TkRNNE1EWmFNQk1DQWdUT0Z3MHhOREV4TURVeE5ETTQNCk1URmFNQk1DQWdUUEZ3MHhOREV4TURVeE5ETTRNVGRhTURzQ0FnR0hGdzB4TkRFeE1qUXhNekk0TVRWYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFF4TVRJME1UTXlPVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFNUJjTk1UUXhNVEkwTVRNeU9ERTNXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFME1URXlOREV6TWprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JPWVhEVEUwTVRFeU5URTJNVE0wTjFvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOREV4TWpVeE5qRTFNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1RuRncweE5ERXhNalV4TmpJeE1qbGENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1USTFNVFl5TWpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRTZCY05NVFF4TVRJMk1EZ3kNCk9EVXhXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEV5TmpBNE16QXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCUXdYRFRFMU1ERXkNCk56RXhNekF5TlZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE13TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVTkZ3MHgNCk5UQXhNamN4TVRNd01qZGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1EQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUYNCkpCY05NVFV3TVRJM01URXpNREk1V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekF3TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCUThYRFRFMU1ERXlOekV4TXpBek1Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNd01EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdVbEZ3MHhOVEF4TWpjeE1UTXdNelZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNREF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUZEaGNOTVRVd01USTNNVEV6TURNM1dqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpBd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQlNnWERURTFNREV5TnpFeE16QXpPVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXcNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVVFGdzB4TlRBeE1qY3hNVE13TkRGYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTMNCk1URXpNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGSnhjTk1UVXdNVEkzTVRFek1EUXpXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTENCk1ERXlOekV4TXpFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JSRVhEVEUxTURFeU56RXhNekEwTlZvd0pqQVlCZ05WSFJnRUVSZ1ANCk1qQXhOVEF4TWpjeE1UTXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1VtRncweE5UQXhNamN4TVRNd05EZGFNQ1l3R0FZRFZSMFkNCkJCRVlEekl3TVRVd01USTNNVEV6TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkVoY05NVFV3TVRJM01URXpNRFV4V2pBbU1CZ0cNCkExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16RXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCU2tYRFRFMU1ERXlOekV4TXpBMU0xb3cNCkpqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE14TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVVEZ3MHhOVEF4TWpjeE1UTXcNCk5UVmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZLaGNOTVRVd01USTMNCk1URXpNRFUzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekV3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlJRWERURTENCk1ERXlOekV4TXpBMU9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNeE1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVXINCkZ3MHhOVEF4TWpjeE1UTXhNRE5hTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTcNCkFnSUZGUmNOTVRVd01USTNNVEV6TVRBMVdqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpFd01Gb3dDZ1lEVlIwVkJBTUsNCkFRUXdPd0lDQlN3WERURTFNREV5TnpFeE16RXdOMW93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXhNREJhTUFvR0ExVWQNCkZRUURDZ0VFTURzQ0FnVVdGdzB4TlRBeE1qY3hNVE14TURsYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVEV6TVRBd1dqQUsNCkJnTlZIUlVFQXdvQkJEQTdBZ0lGTFJjTk1UVXdNVEkzTVRFek1URXhXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16RXcNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JSY1hEVEUxTURFeU56RXhNekV4TTFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3gNCk1UTXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1V1RncweE5UQXhNamN4TVRNeE1UVmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXcNCk1USTNNVEV6TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkdCY05NVFV3TVRJM01URXpNVEU1V2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERTFNREV5TnpFeE16RXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCUzhYRFRFMU1ERXlOekV4TXpFeU1Wb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TlRBeE1qY3hNVE14TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVWkZ3MHhOVEF4TWpjeE1UTXhNak5hTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZNQmNOTVRVd01USTNNVEV6TVRJMVdqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekV3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlI4WERURTFNREV5TnpFeE16RXkNCk4xb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNeE1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVXhGdzB4TlRBeE1qY3gNCk1UTXhNekZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGSFJjTk1UVXcNCk1USTNNVEV6TVRNeldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JUSVgNCkRURTFNREV5TnpFeE16RXpOVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0MNCkFnVWFGdzB4TlRBeE1qY3hNVE14TXpkYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVEV6TVRBd1dqQUtCZ05WSFJVRUF3b0INCkJEQTdBZ0lGTXhjTk1UVXdNVEkzTVRFek1UTTVXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16RXdNRm93Q2dZRFZSMFYNCkJBTUtBUVF3T3dJQ0JSc1hEVEUxTURFeU56RXhNekUwTVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE15TURCYU1Bb0cNCkExVWRGUVFEQ2dFRU1Ec0NBZ1UwRncweE5UQXhNamN4TVRNeE5ETmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1qQXcNCldqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkhCY05NVFV3TVRJM01URXpNVFEzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXgNCk16SXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVFlYRFRFMU1ERXlOekV4TXpFME9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXgNCk1qY3hNVE15TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVZUZ3MHhOVEF4TWpjeE1UTXhOVEZhTUNZd0dBWURWUjBZQkJFWUR6SXcNCk1UVXdNVEkzTVRFek1qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZOUmNOTVRVd01USTNNVEV6TVRVeldqQW1NQmdHQTFVZEdBUVINCkdBOHlNREUxTURFeU56RXhNekl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlRjWERURTFNREV5TnpFeE16RTFOVm93SmpBWUJnTlYNCkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNeU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVWdGdzB4TlRBeE1qY3hNVE14TlRsYU1DWXcNCkdBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGT0JjTk1UVXdNVEkzTVRFek1qQXgNCldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpJd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JTRVhEVEUxTURFeU56RXgNCk16SXdNMW93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXlNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1U1RncweE5UQXgNCk1qY3hNVE15TURWYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVEV6TWpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkloY04NCk1UVXdNVEkzTVRFek1qQTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16SXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUMNCkJUb1hEVEUxTURFeU56RXhNekl3T1Zvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE15TURCYU1Bb0dBMVVkRlFRRENnRUUNCk1Ec0NBZ1VqRncweE5UQXhNamN4TVRNeU1URmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1qQXdXakFLQmdOVkhSVUUNCkF3b0JCREE3QWdJRk94Y05NVFV3TVRJM01URXpNakV6V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekl3TUZvd0NnWUQNClZSMFZCQU1LQVFRd093SUNCVDBYRFRFMU1ERXlOekUzTWpnek9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TnpJNE1EQmENCk1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVOEZ3MHhOVEF4TWpjeE56STRNemxhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01UY3kNCk9EQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZRQmNOTVRVd01USTNNVGN5T1RBeldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXkNCk56RTNNamt3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlQ0WERURTFNREV5TnpFM01qa3dPVm93SmpBWUJnTlZIUmdFRVJnUE1qQXgNCk5UQXhNamN4TnpJNU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVS9GdzB4TlRBeE1qY3hOekk1TVRGYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFV3TVRJM01UY3lPVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGUWhjTk1UVXdNVEkzTVRjeU9URXpXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFMU1ERXlOekUzTWprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JVRVhEVEUxTURFeU56RTNNamt4TTFvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE56STVNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1ZRRncweE5UQXhNamN4TnpJNU1UVmENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVGN5T1RBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRlF4Y05NVFV3TVRJM01UY3kNCk9URTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFM01qa3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVVFYRFRFMU1ERXkNCk56RTNNamt4TjFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hOekk1TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWUkZ3MHgNCk5UQXhNamN4TnpJNU1UbGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRjeU9UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUYNClN4Y05NVFV3TVRJM01UY3lPVEl3V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RTNNamt3TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCVW9YRFRFMU1ERXlOekUzTWpreU1sb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TnpJNU1EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdWRkZ3MHhOVEF4TWpjeE56STVNakphTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01UY3lPVEF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUZUUmNOTVRVd01USTNNVGN5T1RJeldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekUzTWprd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQlVjWERURTFNREV5TnpFM01qa3lORm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE56STUNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVkpGdzB4TlRBeE1qY3hOekk1TWpSYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTMNCk1UY3lPVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGUmhjTk1UVXdNVEkzTVRjeU9USTFXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTENCk1ERXlOekUzTWprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JVZ1hEVEUxTURFeU56RTNNamt5Tmxvd0pqQVlCZ05WSFJnRUVSZ1ANCk1qQXhOVEF4TWpjeE56STVNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1ZTRncweE5UQXhNamN4TnpJNU1qaGFNQ1l3R0FZRFZSMFkNCkJCRVlEekl3TVRVd01USTNNVGN5T1RBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRlRCY05NVFV3TVRJM01UY3lPVEk0V2pBbU1CZ0cNCkExVWRHQVFSR0E4eU1ERTFNREV5TnpFM01qa3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVTRYRFRFMU1ERXlOekUzTWpreU9Wb3cNCkpqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hOekk1TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWVEZ3MHhOVEF4TWpjeE56STUNCk1qbGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRjeU9UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZUeGNOTVRVd01USTMNCk1UY3lPVE13V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RTNNamt3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlZZWERURTENCk1ERXpNREV3TXpZek5Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNekF4TURNMk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVlgNCkZ3MHhOVEF4TXpBeE1ETTJNemRhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRNd01UQXpOakF3V2pBS0JnTlZIUlVFQXdvQkJEQTcNCkFnSUZXQmNOTVRVd01UTXdNVEF6TmpReFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXpNREV3TXpZd01Gb3dDZ1lEVlIwVkJBTUsNCkFRUXdPd0lDQlZrWERURTFNREV6TURFd016WTBNVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TXpBeE1ETTNNREJhTUFvR0ExVWQNCkZRUURDZ0VFTURzQ0FnVmFGdzB4TlRBeE16QXhNRE0yTkRWYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01UTXdNVEF6TnpBd1dqQUsNCkJnTlZIUlVFQXdvQkJEQTdBZ0lGV3hjTk1UVXdNVE13TVRBek5qUTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV6TURFd016Y3cNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JWd1hEVEUxTURFek1ERXdNelkxTVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE16QXgNCk1ETTNNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1ZkRncweE5UQXhNekF4TURNMk5UTmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXcNCk1UTXdNVEF6TnpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRlhoY05NVFV3TVRNd01UQXpOalUxV2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERTFNREV6TURFd016Y3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVjhYRFRFMU1ERXpNREV3TXpZMU4xb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TlRBeE16QXhNRE0zTURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWZ0Z3MHhOVEF4TXpBeE1ETTNNREZhTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UVXdNVE13TVRBek56QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZZUmNOTVRVd01UTXdNVEF6TnpBeldqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREUxTURFek1ERXdNemN3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQldJWERURTFNREV6TURFd016Y3cNCk5Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNekF4TURNM01EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVmpGdzB4TlRBeE16QXgNCk1ETTNNRGxhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRNd01UQXpOekF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGWkJjTk1UVXcNCk1UTXdNVEF6TnpFeFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXpNREV3TXpjd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JXVVgNCkRURTFNREV6TURFd016Y3hNMW93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TXpBeE1ETTNNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0MNCkFnVm1GdzB4TlRBeE16QXhNRE0zTVRkYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01UTXdNVEF6TnpBd1dqQUtCZ05WSFJVRUF3b0INCkJEQTdBZ0lGWnhjTk1UVXdNVE13TVRBek56RTVXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV6TURFd016Y3dNRm93Q2dZRFZSMFYNCkJBTUtBUVF3T3dJQ0JXZ1hEVEUxTURFek1ERXdNemN5TVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE16QXhNRE0zTURCYU1Bb0cNCkExVWRGUVFEQ2dFRU1Ec0NBZ1ZxRncweE5UQXhNekF4TURNM01qTmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVE13TVRBek56QXcNCldqQUtCZ05WSFJVRUF3b0JCREE3QWdJRmFSY05NVFV3TVRNd01UQXpOekkzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFek1ERXcNCk16Y3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVzBYRFRFMU1ERXpNREV3TXpjeU9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXgNCk16QXhNRE0zTURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWckZ3MHhOVEF4TXpBeE1ETTNNekZhTUNZd0dBWURWUjBZQkJFWUR6SXcNCk1UVXdNVE13TVRBek56QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZiQmNOTVRVd01UTXdNVEF6TnpNeldqQW1NQmdHQTFVZEdBUVINCkdBOHlNREUxTURFek1ERXdNemN3TUZvd0NnWURWUjBWQkFNS0FRUXdFd0lDQlhFWERURTFNREl3TXpFMk16a3hNRm93RXdJQ0JXOFgNCkRURTFNREl3TXpFMk16a3hPVm93RXdJQ0JYQVhEVEUxTURJd016RTJOVEF5TVZvd0V3SUNCWE1YRFRFMU1ESXdNekUyTlRFd01WcWcNCk1EQXVNQXNHQTFVZEZBUUVBZ0lDaERBZkJnTlZIU01FR0RBV2dCUlh3M3pORmFKaEV3cHJQdUhHU2V4T1F4L0RoekFOQmdrcWhraUcNCjl3MEJBUVVGQUFPQ0FRRUFmVjRIVDZOdXI4Si9ianhJOEJjZ3p2MWJYRy9mcWhNVzVmb1hRYlQ0VWUzT3huTXIrOW5VQ29ZSTRQU0sNCnB2ZWxQc1hzWllPSWVodkhjbHFyQXpyczhRVUo4YWdFeEtISlltbjd5SzVuR0YxZlpIM0NXd0dFbHcxeGdYZGxVWGN3TGJWRU5vNFQNCkdaaXYvZEJLUTdlWGp1L1RjQU52WS9aaWIrSFBjbkZnanhYMENhOHduOEZFNjVPWkxpNFhxL2UyMExEcXZNaHc1ajV6U29taFNwVVUNCjBWT1h4UjFiZmZhbEdhRVpqQUFhSDRsY2M5RFFrWGVRSlFxOWdSTGh3U3cvM05WQnBJNmV0b0QxQndWUk1zRkZ0Si9tRDYzc0JqWVQNCjY1OHpJK1BTR2R3Y2xWVnhpSkJDRDNrQ0tkNDFubjJlMXM1SVZUVlNSWWhFYTZrZVpJcWFlQT09PC9YNTA5Q1JMPjwvWDUwOURhdGE+PC9LZXlJbmZvPjwvU2lnbmF0dXJlPjwvbWFyY2FEYUJvbGxvPg==</pay_i:testoAllegato>
                  </pay_i:allegatoRicevuta>
                </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
          </pay_i:RT>
        """
      And initial XML nodoInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header>
              <ppt:intestazionePPT>
                <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
              </ppt:intestazionePPT>
          </soapenv:Header>
          <soapenv:Body>
              <ws:nodoInviaRPT>
                <password>pwdpwdpwd</password>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canaleRtPush#</identificativoCanale>
                <tipoFirma></tipoFirma>
                <rpt>$rptAttachment</rpt>
              </ws:nodoInviaRPT>
          </soapenv:Body>
        </soapenv:Envelope>
        """  
      And initial XML pspInviaRPT
        """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:pspInviaRPTResponse>
                        <pspInviaRPTResponse>
                            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                            <identificativoCarrello>$nodoInviaRPT.identificativoUnivocoVersamento</identificativoCarrello>
                            <parametriPagamentoImmediato>idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento</parametriPagamentoImmediato>
                        </pspInviaRPTResponse>
                    </ws:pspInviaRPTResponse>
                </soapenv:Body>
            </soapenv:Envelope>
        """ 
      And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
      And initial XML nodoInviaRT
        """
          <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:nodoInviaRT>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canaleRtPush#</identificativoCanale>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                  <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                  <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                  <tipoFirma></tipoFirma>
                  <forzaControlloSegno>1</forzaControlloSegno>
                  <rt>$rtAttachment</rt>
              </ws:nodoInviaRT>
          </soapenv:Body>
          </soapenv:Envelope>
        """
      And initial XML paaInviaRT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:paaInviaRTRisposta>
                <paaInviaRTRisposta>
                    <esito>OK</esito>
                </paaInviaRTRisposta>
              </ws:paaInviaRTRisposta>
          </soapenv:Body>
        </soapenv:Envelope>
        """
      And EC replies to nodo-dei-pagamenti with the paaInviaRT
      When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      And psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
      Then check esito is KO of nodoInviaRT response
      And check faultCode is PPT_SEMANTICA of nodoInviaRT response

    Scenario: Check faultCode PPT_SEMANTICA error on fake certificate [Bollo_9]
      Given RPT generation
        """
        <?xml version="1.0" encoding="UTF-8"?>
          <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_2_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>idMsgRichiesta</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
                <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
                <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
                <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
                <pay_i:ibanAddebito>IT45R0760103200000000001016</pay_i:ibanAddebito>
                <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
                <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
                <pay_i:datiSingoloVersamento>
                  <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
                  <pay_i:commissioneCaricoPA>10.00</pay_i:commissioneCaricoPA>
                  <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
                  <pay_i:ibanAppoggio>IT45R0760103200000000001016</pay_i:ibanAppoggio>
                  <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
                  <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:datiMarcaBolloDigitale>
                      <pay_i:tipoBollo>01</pay_i:tipoBollo>
                      <pay_i:hashDocumento>8FqHpTji9pboxWmx7p1WoMiKh8MOMujHv1+zg+M3LSo=</pay_i:hashDocumento>
                      <pay_i:provinciaResidenza>MI</pay_i:provinciaResidenza>
                  </pay_i:datiMarcaBolloDigitale>
                </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
          </pay_i:RPT>
        """
      And RT generation
        """
          <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRicevuta>TR0001_20120302-10:37:52.0264-F098</pay_i:identificativoMessaggioRicevuta>
            <pay_i:dataOraMessaggioRicevuta>#timedate#</pay_i:dataOraMessaggioRicevuta>
            <pay_i:riferimentoMessaggioRichiesta>#timedate#</pay_i:riferimentoMessaggioRichiesta>
            <pay_i:riferimentoDataRichiesta>2012-01-26</pay_i:riferimentoDataRichiesta>
            <pay_i:istitutoAttestante>
                <pay_i:identificativoUnivocoAttestante>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>istitutoAttestan</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoAttestante>
                <pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante>
                <pay_i:codiceUnitOperAttestante>CodiceUOA</pay_i:codiceUnitOperAttestante>
                <pay_i:denomUnitOperAttestante>DenomUnitOperAttestante</pay_i:denomUnitOperAttestante>
                <pay_i:indirizzoAttestante>IndirizzoAttestante</pay_i:indirizzoAttestante>
                <pay_i:civicoAttestante>11</pay_i:civicoAttestante>
                <pay_i:capAttestante>11111</pay_i:capAttestante>
                <pay_i:localitaAttestante>LocalitaAttestante</pay_i:localitaAttestante>
                <pay_i:provinciaAttestante>ProvinciaAttestante</pay_i:provinciaAttestante>
                <pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante>
            </pay_i:istitutoAttestante>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501F</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
                <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:datiPagamento>
                <pay_i:codiceEsitoPagamento>0</pay_i:codiceEsitoPagamento>
                <pay_i:importoTotalePagato>10.00</pay_i:importoTotalePagato>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
                <pay_i:datiSingoloPagamento>
                  <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
                  <pay_i:esitoSingoloPagamento>Pagamento effettuato</pay_i:esitoSingoloPagamento>
                  <pay_i:dataEsitoSingoloPagamento>2012-03-02</pay_i:dataEsitoSingoloPagamento>
                  <pay_i:identificativoUnivocoRiscossione>$1iuv</pay_i:identificativoUnivocoRiscossione>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica RT</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:allegatoRicevuta>
                      <pay_i:tipoAllegatoRicevuta>BD</pay_i:tipoAllegatoRicevuta>
                      <pay_i:testoAllegato>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PG1hcmNhRGFCb2xsbyB4bWxucz0iaHR0cDovL3d3dy5hZ2VuemlhZW50cmF0ZS5nb3YuaXQvMjAxNC9NYXJjYURhQm9sbG8iIHhtbG5zOm5zMj0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PFBTUD48Q29kaWNlRmlzY2FsZT4xMjM0NTY3ODkwMTwvQ29kaWNlRmlzY2FsZT48RGVub21pbmF6aW9uZT5pZFBzcDE8L0Rlbm9taW5hemlvbmU+PC9QU1A+PElVQkQ+OTk5OTAwMDAwMDAxMDE8L0lVQkQ+PE9yYUFjcXVpc3RvPjIwMTUtMDItMDlUMTY6NTE6MTkuNDYyKzAxOjAwPC9PcmFBY3F1aXN0bz48SW1wb3J0bz4xMC4wMDwvSW1wb3J0bz48VGlwb0JvbGxvPjAxPC9UaXBvQm9sbG8+PEltcHJvbnRhRG9jdW1lbnRvPjxEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNzaGEyNTYiLz48bnMyOkRpZ2VzdFZhbHVlPjhGcUhwVGppOXBib3hXbXg3cDFXb01pS2g4TU9NdWpIdjEremcrTTNMU289PC9uczI6RGlnZXN0VmFsdWU+PC9JbXByb250YURvY3VtZW50bz48U2lnbmF0dXJlIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj48U2lnbmVkSW5mbz48Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1Ii8+PFNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZHNpZy1tb3JlI3JzYS1zaGEyNTYiLz48UmVmZXJlbmNlIFVSST0iIj48VHJhbnNmb3Jtcz48VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiLz48L1RyYW5zZm9ybXM+PERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIvPjxEaWdlc3RWYWx1ZT5QZVE1MlN3Q3Y1bG5kcHhiY1kycWowdS9ydWRCenZmQS9mbnBqSzBuKytVPTwvRGlnZXN0VmFsdWU+PC9SZWZlcmVuY2U+PC9TaWduZWRJbmZvPjxTaWduYXR1cmVWYWx1ZT5XY04xYzBqalhKQ21YcVJCN0pob3NWQ2dyTll0Q25HaEtjc3dneVIwck8rdmNqVHlBRTRsdGJOM3ArdGFkL0V5K0hpRTB5WFlwRU5oDQpMMG5NZDRXUVd1SnI0WjAyQTF0b0plNEJvSVRWYnhTZE5USERqa1pHVWE3YU12cm80dHdQMEhBQ2hIRzNCbVFiMjQ4V3FOc2xDUVdXDQo1K2dnc1JzN3BGVFB1NDVoL2k2Y3Znak9MWnd5ZHFjdjFkRVNDemI4OHVwMVRaamd6UzV2c3Rsa0swQlhSUitsMDRmRTBGaHZrc1diDQpjNHpQWEtxMGh2K0M4bHZVeHphcFVieXU0RjRHd0ZPU3pPL2o1QzJlaUorMGFqU0w4MGptRXFIZE1zZGtTSmd1TkhnUDZ0ajRLZWxTDQphTUUzaTRIb0tQU0tDdVcveWc1cllPc1MrbXExK1h1YytGTEZYZz09PC9TaWduYXR1cmVWYWx1ZT48S2V5SW5mbyBJZD0ia2V5aW5mbyI+PFg1MDlEYXRhPjxYNTA5Q2VydGlmaWNhdGU+TUlJRFB6Q0NBaWVnQXdJQkFnSUliSlpkVTNkcFJvWXdEUVlKS29aSWh2Y05BUUVMQlFBd0ZERVNNQkFHQTFVRUF3d0pRMEVnVkdWeg0KZENBeE1CNFhEVEUxTURJd016RTJNVGswT0ZvWERURTNNREl3TWpFMk1UazBPRm93U1RFYk1Ca0dBMVVFQXd3U01USXpORFUyTnpnNQ0KTURFZ2FXUlFjM0F4TVF3d0NnWURWUVFMREFOUVUxQXhEekFOQmdOVkJBb01CbWxrVUhOd01URUxNQWtHQTFVRUJoTUNTVlF3Z2dFaQ0KTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFDUjdpVVBidllKS1RFbFRaelF5NHl0ZnUxSlBndDdzT3I2ekhVMA0KTURRdUx6Z1FMaVpUcXdQVmtRTHdGb3Q4NUtsOFVIRG82NlJVVTlUaHR3QkFzSWxlREpTN0lTam5jWktHYkdqRXpRZGR1VUU2Rm5wdw0KLzNEZzBwQlY2RGNsMWFxK2dWa2dOeVhPNlZ0UkhTTHhaLzdaRlJXWDZkeVNackhBdGFOVFBGS2RacU9mWlk2VEZSbUVhTWlzK3F4eg0KaGJSck1xZ0pSZ2t4MXpxcmR1eHN4MDZaNDNCVSs5VTZjMGl4QmJ3SDJpQmdITGI3U0tSZ2ZveUhWc3UxbzRMOFZ1MmpVcVVnNDBYSg0KcEVkUlA1WWszOFc0emtSeGxxQ0JWMTlQV1FYSXN0VEZmVUZWOFlzRWMwTHVRdHR0amV2ZTNaSmIyNkxGcExwVHpkN0RiOHBnZUZ6ZA0KQWdNQkFBR2pZREJlTUIwR0ExVWREZ1FXQkJTT0c3UFpQRy9tMU9YemVvTGFhRkZQMkpkNExqQU1CZ05WSFJNQkFmOEVBakFBTUI4Rw0KQTFVZEl3UVlNQmFBRkZnTk1pbm5zNlo1bE5pRUJER1NDcmQvankwV01BNEdBMVVkRHdFQi93UUVBd0lHUURBTkJna3Foa2lHOXcwQg0KQVFzRkFBT0NBUUVBcWlKWHJVZmtHZGhoOGJtWVhWVXorWG9HRS9vOE9Yb013Z2FBR3RDbHlWc1ZuY1c3ZWFRNmc5Vm5QMWwwbDczdw0KZmxWcUM1MkhRMzFMeHQvUFJSRXZ2VUI0M1lXTmV2L1Yyb1N4UXY5ZzlWdVBIK095RUIvN014eWVkNytyejBTaWd1M3lwRVE2YmdhbA0KNjNjODBTNUFYdGI0RDI1bjcvU2R6K01zaXhqSHAxQ05lbS9JaVkyZEJoZE5KZExoM3NhdTNnZ2QwdDREOWpwcytoejQ4Wm1GTmUyYg0KUHVmZTAxNWdlUVhUUjJGWEJyS2ZJTy9DeEd0eHEzSm1RR1hON2pQd1JzT0lSS2hIM3RzM04zdDVuN0JlWHJWWUVtSVhXeWR6eDZuUQ0KK25zRlhUbGlhb09XNFB1RC95WU8rajBzelFYakx5cWU1UUhxN1ZoK3daUGhYdVdlanc9PTwvWDUwOUNlcnRpZmljYXRlPjxYNTA5Q1JMPk1JSUo2RENDQ05BQ0FRRXdEUVlKS29aSWh2Y05BUUVMQlFBd0ZERVNNQkFHQTFVRUF3d0pRMEVnVkdWemRDQXhGdzB4TlRBeU1Ea3gNCk16RTBNVGRhRncweE5UQXlNVEF4TXpFME1UZGFNSUlJVkRBbkFnZzhQV0FtSXF4QWdSY05NVFF3TmpFd01USTFOVFExV2pBTU1Bb0cNCkExVWRGUVFEQ2dFRU1DY0NDQzRVL1BVWnBvL3hGdzB4TkRBMk1UQXhNalUyTURCYU1Bd3dDZ1lEVlIwVkJBTUtBUVF3SndJSVQ2ZUwNCjl4dEZselVYRFRFME1EWXhNREV5TlRZME5Gb3dEREFLQmdOVkhSVUVBd29CQkRBbkFnaGZuZENxS3huM1FCY05NVFF3TmpFd01UTXcNCk1URTBXakFNTUFvR0ExVWRGUVFEQ2dFRU1DY0NDRUh5MFBSS09vSVJGdzB4TkRBMk1UQXhNekF4TlRoYU1Bd3dDZ1lEVlIwVkJBTUsNCkFRUXdKd0lJQjdXSk5BVnE0bHdYRFRFME1EWXhNREV6TURJd00xb3dEREFLQmdOVkhSVUVBd29CQkRBbkFnZzFabWJpaFUwNEtSY04NCk1UUXdOakV3TVRNd01qRTNXakFNTUFvR0ExVWRGUVFEQ2dFRU1DY0NDRUREbVlTZlVkYjRGdzB4TkRBMk1UQXhNekF6TURGYU1Bd3cNCkNnWURWUjBWQkFNS0FRUXdKd0lJRWFac0k4T0M2QThYRFRFME1EWXhNREV6TURZd09Wb3dEREFLQmdOVkhSVUVBd29CQkRBbkFnaGMNCnM3UExITmRsemhjTk1UUXdOakV3TVRNd05qRTFXakFNTUFvR0ExVWRGUVFEQ2dFRU1DY0NDQ2VtaWFtWUtOZXpGdzB4TkRBMk1UQXgNCk16QTJNamhhTUF3d0NnWURWUjBWQkFNS0FRUXdKd0lJQ2p1NUUxZEhjbGtYRFRFME1EWXhNREV6TURjeE1sb3dEREFLQmdOVkhSVUUNCkF3b0JCREFuQWdoeGMza0RQWlZMUFJjTk1UUXdOakV3TVRNd056RTNXakFNTUFvR0ExVWRGUVFEQ2dFRU1DY0NDREFNYVRKZ290MFENCkZ3MHhOREEyTVRBeE16QTNNekZhTUF3d0NnWURWUjBWQkFNS0FRUXdKd0lJTFVjWm15dy9wSklYRFRFME1EWXhNREV6TURVd04xb3cNCkREQUtCZ05WSFJVRUF3b0JCREFuQWdobFgrN3k1MUJ6MFJjTk1UUXdOakV3TVRNd05URXlXakFNTUFvR0ExVWRGUVFEQ2dFRU1DY0MNCkNCL2JXTThFdnBpbkZ3MHhOREEyTVRBeE16QTFNalZhTUF3d0NnWURWUjBWQkFNS0FRUXdKd0lJV3gvN0VxU3UyN1FYRFRFME1EWXgNCk1ERXpNRGd4TlZvd0REQUtCZ05WSFJVRUF3b0JCREFuQWdnTER3ZE84MFBwMVJjTk1UUXdOakV3TVRNd09ESXhXakFNTUFvR0ExVWQNCkZRUURDZ0VFTUNjQ0NDNVdBVThKREdnTkZ3MHhOREEyTVRBeE16QTRNelJhTUF3d0NnWURWUjBWQkFNS0FRUXdKd0lJQWFCYVd1OXYNCktCMFhEVEUwTURZeE1ERXlOVEEwTmxvd0REQUtCZ05WSFJVRUF3b0JCREFuQWdnSXZ4M3NrbUxnT2hjTk1UUXdOakV3TVRJMU1UTXgNCldqQU1NQW9HQTFVZEZRUURDZ0VFTUNjQ0NISWJQanJmZkJiTUZ3MHhOREEyTVRBeE1qVTJORGhhTUF3d0NnWURWUjBWQkFNS0FRUXcNCkp3SUlQb0s0ejlNWFVVb1hEVEUwTURZeE1ERXlOVGN3TTFvd0REQUtCZ05WSFJVRUF3b0JCREFuQWdndFU3OGtDcm44aXhjTk1UUXcNCk5qRXdNVEkxTnpRM1dqQU1NQW9HQTFVZEZRUURDZ0VFTUNjQ0NGTVB6QWpEbUVzdUZ3MHhOREEyTVRBeE1qVXhNelJhTUF3d0NnWUQNClZSMFZCQU1LQVFRd0p3SUllN3B0OTcvNktXTVhEVEUwTURZeE1ERXlOVEUwT1Zvd0REQUtCZ05WSFJVRUF3b0JCREFuQWdoampmcmENCkRWOGlBUmNOTVRRd05qRXdNVEkxTWpNeldqQU1NQW9HQTFVZEZRUURDZ0VFTUNjQ0NCTW9qRFpOWlF5TEZ3MHhOREEyTVRBeE1qVTMNCk5URmFNQXd3Q2dZRFZSMFZCQU1LQVFRd0p3SUlKa29pcnBoUkZsVVhEVEUwTURZeE1ERXlOVGd3TlZvd0REQUtCZ05WSFJVRUF3b0INCkJEQW5BZ2d5WGFtMDdaWXpSeGNOTVRRd05qRXdNVEkxT0RVd1dqQU1NQW9HQTFVZEZRUURDZ0VFTUNjQ0NCV3RSVDFxR2dsdUZ3MHgNCk5EQTJNVEF4TWpVeU16ZGFNQXd3Q2dZRFZSMFZCQU1LQVFRd0p3SUlDOXVlZ2UvdkpJUVhEVEUwTURZeE1ERXlOVEkxTWxvd0REQUsNCkJnTlZIUlVFQXdvQkJEQW5BZ2hKSmtrWUwwYkg4QmNOTVRRd05qRXdNVEkxTXpNMldqQU1NQW9HQTFVZEZRUURDZ0VFTUNjQ0NIUlQNCmxKZXduUUZZRncweE5EQTJNVEF4TWpVNE5UVmFNQXd3Q2dZRFZSMFZCQU1LQVFRd0p3SUlLZ0l5allaRlE2NFhEVEUwTURZeE1ERXkNCk5Ua3dPRm93RERBS0JnTlZIUlVFQXdvQkJEQW5BZ2craiswQ005SG5hUmNOTVRRd05qRXdNVEkxT1RVeldqQU1NQW9HQTFVZEZRUUQNCkNnRUVNQ2NDQ0RVdHBqWGZRZEQ1RncweE5EQTJNVEF4TXpBd01URmFNQXd3Q2dZRFZSMFZCQU1LQVFRd0p3SUlSN0RvbGdiN2diWVgNCkRURTBNRFl4TURFek1EQTFObG93RERBS0JnTlZIUlVFQXdvQkJEQW5BZ2hXWnJRZGNtVEg2QmNOTVRRd05qRXdNVE13TVRBeFdqQU0NCk1Bb0dBMVVkRlFRRENnRUVNQ2NDQ0N3OXdVRW9RSjQ2RncweE5EQTJNVEF4TWpVek5EQmFNQXd3Q2dZRFZSMFZCQU1LQVFRd0p3SUkNClFya1ZJWXBudzRnWERURTBNRFl4TURFeU5UTTFORm93RERBS0JnTlZIUlVFQXdvQkJEQW5BZ2hiU2paeW5EeTd5eGNOTVRRd05qRXcNCk1USTFORE01V2pBTU1Bb0dBMVVkRlFRRENnRUVNQ2NDQ0Q2aktzOTRJdGl6RncweE5EQTJNVEF4TWpVNU5UaGFNQXd3Q2dZRFZSMFYNCkJBTUtBUVF3SndJSVk2S0Vua0k1MEY4WERURTBNRFl4TURFek1ETXdObG93RERBS0JnTlZIUlVFQXdvQkJEQW5BZ2doODBUU251WTYNCkZoY05NVFF3TmpFd01UTXdNekl3V2pBTU1Bb0dBMVVkRlFRRENnRUVNQ2NDQ0c1SkRPRXhXWlo3RncweE5EQTJNVEF4TWpVME5ESmENCk1Bd3dDZ1lEVlIwVkJBTUtBUVF3SndJSU82VmhkVWF3d0FrWERURTBNRFl4TURFeU5UUTFOMW93RERBS0JnTlZIUlVFQXdvQkJEQW4NCkFnZzdyU1oyeHVieHF4Y05NVFF3TmpFd01USTFOVFF4V2pBTU1Bb0dBMVVkRlFRRENnRUVNQ2NDQ0dCTTFTWG1WcHY2RncweE5EQTINCk1UQXhNekEwTURSYU1Bd3dDZ1lEVlIwVkJBTUtBUVF3SndJSVphQXdmbjVWcXRBWERURTBNRFl4TURFek1EUXdPVm93RERBS0JnTlYNCkhSVUVBd29CQkRBbkFnaDVxQk1MNnpTUGd4Y05NVFF3TmpFd01UTXdOREl5V2pBTU1Bb0dBMVVkRlFRRENnRUVvREF3TGpBZkJnTlYNCkhTTUVHREFXZ0JSWURUSXA1N09tZVpUWWhBUXhrZ3EzZjQ4dEZqQUxCZ05WSFJRRUJBSUNBTlV3RFFZSktvWklodmNOQVFFTEJRQUQNCmdnRUJBSVBHWlh3M3NGNHRmZDRocG5zd2Q0UTNqUFhsQ0xMT3Fvek9DZXN3MlhnWG1LZjZFdWJsMW9pbmtBUTh5Y2lKL09XSzhvOW0NClF2Q0VXQzJHZkZqQWwxdXV2UTVoNkxSUFFJNVZYNjZoOVpZaWNTcmpIQVZBYVdDK1IzVnZTVlVOQ2MvMmFoakhlenEycnFMT2FSenkNClhkNGhHVlVvSlVWR1NMbEtWWUUwajVQMytjNDRUdmlncWhXdzB6OE1udGZtcFNpRHJZNW1HTU9wb1A5Ym1hNW4wYzVPSXh4WkpFcGkNCmhjWEwrNlUvR2NXcFpRaXZRY2M3bnBRWW0yK25mVUJmSGpqTyttVEZjS0J1M3NXVmhXRTAydVRod3lvMUExa0xKUzlGZG5OZDltd1YNCmpFVEloaXM5WUZrRUxZa1dtc1pLaUcrOEhNREVYa2RrWUVUMWJJaEpMQ3M9PC9YNTA5Q1JMPjwvWDUwOURhdGE+PC9LZXlJbmZvPjwvU2lnbmF0dXJlPjwvbWFyY2FEYUJvbGxvPg==</pay_i:testoAllegato>
                  </pay_i:allegatoRicevuta>
                </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
          </pay_i:RT>
        """
      And initial XML nodoInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header>
              <ppt:intestazionePPT>
                <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
              </ppt:intestazionePPT>
          </soapenv:Header>
          <soapenv:Body>
              <ws:nodoInviaRPT>
                <password>pwdpwdpwd</password>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canaleRtPush#</identificativoCanale>
                <tipoFirma></tipoFirma>
                <rpt>$rptAttachment</rpt>
              </ws:nodoInviaRPT>
          </soapenv:Body>
        </soapenv:Envelope>
        """  
      And initial XML pspInviaRPT
        """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:pspInviaRPTResponse>
                        <pspInviaRPTResponse>
                            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                            <identificativoCarrello>$nodoInviaRPT.identificativoUnivocoVersamento</identificativoCarrello>
                            <parametriPagamentoImmediato>idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento</parametriPagamentoImmediato>
                        </pspInviaRPTResponse>
                    </ws:pspInviaRPTResponse>
                </soapenv:Body>
            </soapenv:Envelope>
        """ 
      And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
      And initial XML nodoInviaRT
        """
          <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:nodoInviaRT>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canaleRtPush#</identificativoCanale>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                  <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                  <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                  <tipoFirma></tipoFirma>
                  <forzaControlloSegno>1</forzaControlloSegno>
                  <rt>$rtAttachment</rt>
              </ws:nodoInviaRT>
          </soapenv:Body>
          </soapenv:Envelope>
        """
      And initial XML paaInviaRT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:paaInviaRTRisposta>
                <paaInviaRTRisposta>
                    <esito>OK</esito>
                </paaInviaRTRisposta>
              </ws:paaInviaRTRisposta>
          </soapenv:Body>
        </soapenv:Envelope>
        """
      And EC replies to nodo-dei-pagamenti with the paaInviaRT
      When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      And psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
      Then check esito is KO of nodoInviaRT response
      And check faultCode is PPT_SEMANTICA of nodoInviaRT response


    Scenario: Check faultCode PPT_SEMANTICA error on expired CRL [Bollo_10]
      Given RPT generation
        """
        <?xml version="1.0" encoding="UTF-8"?>
          <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_2_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>idMsgRichiesta</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
                <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
                <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
                <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
                <pay_i:ibanAddebito>IT45R0760103200000000001016</pay_i:ibanAddebito>
                <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
                <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
                <pay_i:datiSingoloVersamento>
                  <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
                  <pay_i:commissioneCaricoPA>10.00</pay_i:commissioneCaricoPA>
                  <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
                  <pay_i:ibanAppoggio>IT45R0760103200000000001016</pay_i:ibanAppoggio>
                  <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
                  <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:datiMarcaBolloDigitale>
                      <pay_i:tipoBollo>01</pay_i:tipoBollo>
                      <pay_i:hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</pay_i:hashDocumento>
                      <pay_i:provinciaResidenza>MI</pay_i:provinciaResidenza>
                  </pay_i:datiMarcaBolloDigitale>
                </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
          </pay_i:RPT>
        """
      And RT generation
        """
          <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRicevuta>TR0001_20120302-10:37:52.0264-F098</pay_i:identificativoMessaggioRicevuta>
            <pay_i:dataOraMessaggioRicevuta>#timedate#</pay_i:dataOraMessaggioRicevuta>
            <pay_i:riferimentoMessaggioRichiesta>#timedate#</pay_i:riferimentoMessaggioRichiesta>
            <pay_i:riferimentoDataRichiesta>2012-01-26</pay_i:riferimentoDataRichiesta>
            <pay_i:istitutoAttestante>
                <pay_i:identificativoUnivocoAttestante>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>istitutoAttestan</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoAttestante>
                <pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante>
                <pay_i:codiceUnitOperAttestante>CodiceUOA</pay_i:codiceUnitOperAttestante>
                <pay_i:denomUnitOperAttestante>DenomUnitOperAttestante</pay_i:denomUnitOperAttestante>
                <pay_i:indirizzoAttestante>IndirizzoAttestante</pay_i:indirizzoAttestante>
                <pay_i:civicoAttestante>11</pay_i:civicoAttestante>
                <pay_i:capAttestante>11111</pay_i:capAttestante>
                <pay_i:localitaAttestante>LocalitaAttestante</pay_i:localitaAttestante>
                <pay_i:provinciaAttestante>ProvinciaAttestante</pay_i:provinciaAttestante>
                <pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante>
            </pay_i:istitutoAttestante>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501F</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
                <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:datiPagamento>
                <pay_i:codiceEsitoPagamento>0</pay_i:codiceEsitoPagamento>
                <pay_i:importoTotalePagato>10.00</pay_i:importoTotalePagato>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
                <pay_i:datiSingoloPagamento>
                  <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
                  <pay_i:esitoSingoloPagamento>Pagamento effettuato</pay_i:esitoSingoloPagamento>
                  <pay_i:dataEsitoSingoloPagamento>2012-03-02</pay_i:dataEsitoSingoloPagamento>
                  <pay_i:identificativoUnivocoRiscossione>$1iuv</pay_i:identificativoUnivocoRiscossione>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica RT</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:allegatoRicevuta>
                      <pay_i:tipoAllegatoRicevuta>BD</pay_i:tipoAllegatoRicevuta>
                      <pay_i:testoAllegato>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PG1hcmNhRGFCb2xsbyB4bWxucz0iaHR0cDovL3d3dy5hZ2VuemlhZW50cmF0ZS5nb3YuaXQvMjAxNC9NYXJjYURhQm9sbG8iIHhtbG5zOm5zMj0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PFBTUD48Q29kaWNlRmlzY2FsZT4xMjM0NTY3ODkwMTwvQ29kaWNlRmlzY2FsZT48RGVub21pbmF6aW9uZT5pZFBzcDE8L0Rlbm9taW5hemlvbmU+PC9QU1A+PElVQkQ+OTk5OTAwMDAwMDAzMDE8L0lVQkQ+PE9yYUFjcXVpc3RvPjIwMTUtMDItMDlUMTc6MDM6MDIuMzcwKzAxOjAwPC9PcmFBY3F1aXN0bz48SW1wb3J0bz4xMC4wMDwvSW1wb3J0bz48VGlwb0JvbGxvPjAxPC9UaXBvQm9sbG8+PEltcHJvbnRhRG9jdW1lbnRvPjxEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNzaGEyNTYiLz48bnMyOkRpZ2VzdFZhbHVlPmdlZllaYWFCdlZleHlsZXQ5cW9jZFRGN1dybDFnZnB5TVNNLzI4SWZDQlU9PC9uczI6RGlnZXN0VmFsdWU+PC9JbXByb250YURvY3VtZW50bz48U2lnbmF0dXJlIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj48U2lnbmVkSW5mbz48Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1Ii8+PFNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZHNpZy1tb3JlI3JzYS1zaGEyNTYiLz48UmVmZXJlbmNlIFVSST0iIj48VHJhbnNmb3Jtcz48VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiLz48L1RyYW5zZm9ybXM+PERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIvPjxEaWdlc3RWYWx1ZT5WN1Zrc3grN09SUG43TUxJUFBadHl2d1RTQ0JYQ3pWeFMycnZoWk1WMjkwPTwvRGlnZXN0VmFsdWU+PC9SZWZlcmVuY2U+PC9TaWduZWRJbmZvPjxTaWduYXR1cmVWYWx1ZT5zdmdaYXRZR2hYSVF1UnVaTmp4ZkdhY0FHSXZxM1VabHpmOXJWeUN1WHhvM0Z1dnFxN1htY09RN3BwVWx6SXNUSnJGUmEzM2NlN0UxDQpxN0ZqaUQ2Tm55RnZQVHI4UFpIc1JIVHFXUEphUDFjaGpkazlrYkQ0U2ZwSk53R1JqMUtVdThCVHltbGhsb09ySGZBbmRZQWtMRVREDQptYnZQZTFzdEU1dUMraWNjVG1Rc3VhVW55elA5OVF1bkN2cEFZMUUwdUcyM1kyNEFLQXhvTS9xWjFSbFc3bnJaMGRpOGhwaWxHeVJVDQp1S2FESEZ4Rk04U1FNczN5RUtOYTBqQTUrN0xmRTBwMWxyL2FCM2VOSldBNFFuZHJvRDl5QUxNOHl6RERXSEY3UGl6Qi90NXJORzZyDQo5N1pBaEFSMU9qVG1PdUI1K09PVFVkYkhSWTRTTzJhclNCM3p3Zz09PC9TaWduYXR1cmVWYWx1ZT48S2V5SW5mbyBJZD0ia2V5aW5mbyI+PFg1MDlEYXRhPjxYNTA5Q2VydGlmaWNhdGU+TUlJRGpEQ0NBblNnQXdJQkFnSUNCWEl3RFFZSktvWklodmNOQVFFRkJRQXdOVEVMTUFrR0ExVUVCaE1DU1ZReERqQU1CZ05WQkFvVA0KQlZOdloyVnBNUll3RkFZRFZRUURFdzFEUVNCVGIyZGxhU0JVWlhOME1CNFhEVEUxTURJd016RTJNRGMxTUZvWERUSXhNREl3TXpFMg0KTURZeU9Gb3dTVEVMTUFrR0ExVUVCaE1DU1ZReER6QU5CZ05WQkFvVEJtbGtVSE53TVRFTU1Bb0dBMVVFQ3hNRFVGTlFNUnN3R1FZRA0KVlFRREV4SXhNak0wTlRZM09Ea3dNU0JwWkZCemNERXdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFDOQ0KQ3hPZXppb2UvNXEraDNKN0lTdkJoQUtnQVRVMkRHanpvY0ZOR0ljemNxUE5GbGFFTWk4ek1hY080eTlIeDNPOUkvNGR1akN5dFFuRQ0KelpvUGFYVm5kSmNFVmhvWmk1alNXa3lrQURkVFpxWCtseE5maEdKcXNhc2lvVk4ycmk1SVppVEZ5MjJ0QkRQaUovejFOcmJBVFJ0Sw0KcEZSdUV1UEVCbTYxbnQxSU1kWU9wMCtXaWhXRmJ6VnNCLyswWGRlN3FwY0xrS0V4UEIzTmlnVllBZ0dnby96OFo4OUZ0RjlzeGdSQw0KQUVLQ0FERFpMVEN1ak0vTUFOaFl2N3RZQ29lODFOSVlZa09JbkFmR0VyditZbkg3Ukl5Vndxa2JOaE1YYXZzQWd2MVVjZDlKVVVBVg0KVHc2RXpJb21zVU5xQnd0eWl4U0tvSHFmL09VblIrR3B1azJOQWdNQkFBR2pnWkV3Z1k0d0RnWURWUjBQQVFIL0JBUURBZ1pBTUYwRw0KQTFVZEl3UldNRlNBRkZmRGZNMFZvbUVUQ21zKzRjWko3RTVESDhPSG9UbWtOekExTVFzd0NRWURWUVFHRXdKSlZERU9NQXdHQTFVRQ0KQ2hNRlUyOW5aV2t4RmpBVUJnTlZCQU1URFVOQklGTnZaMlZwSUZSbGMzU0NBUUV3SFFZRFZSME9CQllFRkRIZCtmbHpRQTVOUUFMSw0KWk1TZHFwcjZURjdWTUEwR0NTcUdTSWIzRFFFQkJRVUFBNElCQVFBSVpacEFEa0ZhRkY3VXAyK3h1R2tDMTRDcVlCUENRbERxcW8vLw0KdThwSi83N2NRMThqcXVxb1FJbncwdkVwWDN0dFJqSVNscnNISFVUL0hBQjdJM0E5Vkp3YlEyZXpaSE9uZFVCS2VCSjVrQllDc1RBag0KTEtVYzNpYWt0ZW9hVHdRVVVxT3ZVYVJxb2laZzlXN2FCZGlnekZXcTd0aFlTaTF6emVncXZRVHR2ekdxVS9EdWVtN2t5MVNHZS8zRA0KTnhwZWVVM0pHcUt4cGkyTE5nNnJpVlhPdXU5bWprSXpyVDBPa0dqY2RZKzh1RjhJayt3Q3Byalh0c1l5d0hhUFdWNmdWc2orTzhVUQ0KeDF5bHJsM3NzUmVjUW90VnpoV2RCRVY3RXZYM2dPTDNOanMyWE1TcUNWNTd3eGxLbHMzeW9BY1B6SERENXowY1pyVEJxVDRsbjlySzwvWDUwOUNlcnRpZmljYXRlPjxYNTA5Q1JMPk1JSXdBekNDTHVzQ0FRRXdEUVlKS29aSWh2Y05BUUVGQlFBd05URUxNQWtHQTFVRUJoTUNTVlF4RGpBTUJnTlZCQW9UQlZOdloyVnANCk1SWXdGQVlEVlFRREV3MURRU0JUYjJkbGFTQlVaWE4wRncweE5UQXlNRFV5TXpBeE1EbGFGdzB4TlRBeU1EWXlNekExTURsYU1JSXUNClRqQTZBZ0VJRncweE16QTFNamd4TWpFNU16aGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UTXdOVEk0TVRJeE9UQXdXakFLQmdOVkhSVUUNCkF3b0JCREFUQWdJQXBCY05NVE13TmpFek1UVXdNakl4V2pBVEFnSUJKeGNOTVRNd056STFNVEEwTnpRd1dqQVRBZ0lCSmhjTk1UTXcNCk56STFNVEEwTnpVeVdqQTdBZ0lCSlJjTk1UTXdPVEkxTVRRMU5qQTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERXpNRGt5TlRFME5UWXcNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0FUUVhEVEV6TURreU5URTBOVFl3T1Zvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TXpBNU1qVXgNCk5EVTJNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ0UxRncweE16QTVNall3T1RBMk1ERmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UTXcNCk9USTJNRGt3TmpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJQk5oY05NVE13T1RJMk1Ea3lPVFExV2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERXpNRGt5TmpBNU16QXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNBVGNYRFRFek1Ea3lOakE1TWprME4xb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TXpBNU1qWXdPVE13TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdFNEZ3MHhNekE1TWpZd09UUTFNakZhTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UTXdPVEkyTURrME5qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUJPUmNOTVRNd09USTJNVEl3TmpJeFdqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREV6TURreU5qRXlNRFl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQVRvWERURXpNRGt5TmpFek1Ua3cNCk5Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE16QTVNall4TXpFNU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnRTdGdzB4TXpBNU1qWXgNCk16TXpORGRhTUNZd0dBWURWUjBZQkJFWUR6SXdNVE13T1RJMk1UTXpOREF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lCYkJjTk1UTXgNCk1EQTNNVEl6T1RNNFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFek1UQXdOekV5TXprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3THdJQ0FiTVgNCkRURXpNVEF6TVRFeU1qRXdNbG93R2pBWUJnTlZIUmdFRVJnUE1qQXhNekV3TXpFeE1qSXhNREJhTUM4Q0FnR3lGdzB4TXpFd016RXgNCk1qSXhNakphTUJvd0dBWURWUjBZQkJFWUR6SXdNVE14TURNeE1USXlNVEF3V2pBVEFnSUJ0QmNOTVRNeE1ETXhNVFV3TURVeFdqQVQNCkFnSUJ0UmNOTVRNeE1ETXhNVFV3TURVNVdqQVRBZ0lCdGhjTk1UTXhNRE14TVRVd016QXhXakE3QWdJRGFSY05NVFF3TlRJd01UWTANCk5UUTVXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNRFV5TURFMk5EWXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNBMU1YRFRFek1USXkNCk16RXpOVFl3TjFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TXpFeU1qTXhNelUyTURCYU1Bb0dBMVVkRlFRRENnRUVNQk1DQWdQR0Z3MHgNCk5EQTJNRGt4TXpFMk5EWmFNRHNDQWdOcUZ3MHhOREExTWpBeE5qUTFOVEZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF3TlRJd01UWTANCk5qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVmaGNOTVRReE1ERXpNVFV3TURBM1dqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXgNCk16RTFNREV3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkg4WERURTBNVEF4TXpFMU1EQXlNVm93SmpBWUJnTlZIUmdFRVJnUE1qQXgNCk5ERXdNVE14TlRBeE1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU0JGdzB4TkRFd01UTXhOVEF3TWpKYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFF4TURFek1UVXdNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFZ0JjTk1UUXhNREV6TVRVd01ESTFXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFME1UQXhNekUxTURFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JJTVhEVEUwTVRBeE16RTFNREF5Tmxvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UQXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1NDRncweE5ERXdNVE14TlRBd01qZGENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFV3TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRWhSY05NVFF4TURFek1UVXcNCk1ESTRXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU1ERXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCSVFYRFRFME1UQXgNCk16RTFNREF6TVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVEF4TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTR0Z3MHgNCk5ERXdNVE14TlRBd016SmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVd01UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUUNCmh4Y05NVFF4TURFek1UVXdNRE16V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFNREV3TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCSWtYRFRFME1UQXhNekUxTURBek5Gb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRBeE1EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdTTkZ3MHhOREV3TVRNeE5UQXdNemRhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVXdNVEF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUVpeGNOTVRReE1ERXpNVFV3TURNNFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTURFd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQklvWERURTBNVEF4TXpFMU1EQXpPVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UQXgNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU0lGdzB4TkRFd01UTXhOVEF3TkRGYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXoNCk1UVXdNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFakJjTk1UUXhNREV6TVRVd01EUXpXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTANCk1UQXhNekUxTURFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JJNFhEVEUwTVRBeE16RTFNREEwTkZvd0pqQVlCZ05WSFJnRUVSZ1ANCk1qQXhOREV3TVRNeE5UQXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1NSRncweE5ERXdNVE14TlRBd05EVmFNQ1l3R0FZRFZSMFkNCkJCRVlEekl3TVRReE1ERXpNVFV3TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRWp4Y05NVFF4TURFek1UVXdNRFEzV2pBbU1CZ0cNCkExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU1ERXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCSlVYRFRFME1UQXhNekUxTURBME9Gb3cNCkpqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVEF4TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTVEZ3MHhOREV3TVRNeE5UQXcNCk5EbGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVd01qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVsQmNOTVRReE1ERXoNCk1UVXdNRFV4V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFNREl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkpBWERURTANCk1UQXhNekUxTURBMU0xb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRBeU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU1MNCkZ3MHhOREV3TVRNeE5UQXdOVFZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVXdNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTcNCkFnSUVsaGNOTVRReE1ERXpNVFUwTVRJMVdqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRJd01Gb3dDZ1lEVlIwVkJBTUsNCkFRUXdPd0lDQkpjWERURTBNVEF4TXpFMU5ERXlObG93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXlNREJhTUFvR0ExVWQNCkZRUURDZ0VFTURzQ0FnU1lGdzB4TkRFd01UTXhOVFF4TWpaYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTWpBd1dqQUsNCkJnTlZIUlVFQXdvQkJEQTdBZ0lFbkJjTk1UUXhNREV6TVRVME1USTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ESXcNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JLNFhEVEUwTVRBeE16RTFOREV6TUZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXgNCk5UUXlNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1N2RncweE5ERXdNVE14TlRReE16QmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXgNCk1ERXpNVFUwTWpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRXNSY05NVFF4TURFek1UVTBNVE14V2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERTBNVEF4TXpFMU5ESXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCTE1YRFRFME1UQXhNekUxTkRFek1sb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TkRFd01UTXhOVFF5TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTYkZ3MHhOREV3TVRNeE5UUXhNelZhTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UUXhNREV6TVRVME1qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVtaGNOTVRReE1ERXpNVFUwTVRNMldqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFOREl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkprWERURTBNVEF4TXpFMU5ERXoNCk4xb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRReU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU2RGdzB4TkRFd01UTXgNCk5UUXhNemhhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTBNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFdEJjTk1UUXgNCk1ERXpNVFUwTVRRd1dqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRJd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JMQVgNCkRURTBNVEF4TXpFMU5ERTBNRm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXlNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0MNCkFnU3lGdzB4TkRFd01UTXhOVFF4TkRKYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTWpBd1dqQUtCZ05WSFJVRUF3b0INCkJEQTdBZ0lFdFJjTk1UUXhNREV6TVRVME1UUXpXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ESXdNRm93Q2dZRFZSMFYNCkJBTUtBUVF3T3dJQ0JKNFhEVEUwTVRBeE16RTFOREUwTkZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVFF5TURCYU1Bb0cNCkExVWRGUVFEQ2dFRU1Ec0NBZ1NmRncweE5ERXdNVE14TlRReE5EUmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVME1qQXcNCldqQUtCZ05WSFJVRUF3b0JCREE3QWdJRW9CY05NVFF4TURFek1UVTBNVFEzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTENCk5ESXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCS01YRFRFME1UQXhNekUxTkRFME9Gb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXcNCk1UTXhOVFF5TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTNEZ3MHhOREV3TVRNeE5UUXhOVEJhTUNZd0dBWURWUjBZQkJFWUR6SXcNCk1UUXhNREV6TVRVME1qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUV0aGNOTVRReE1ERXpNVFUwTVRVd1dqQW1NQmdHQTFVZEdBUVINCkdBOHlNREUwTVRBeE16RTFOREl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkxjWERURTBNVEF4TXpFMU5ERTFNVm93SmpBWUJnTlYNCkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRReU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnUzZGdzB4TkRFd01UTXhOVFF4TlRKYU1DWXcNCkdBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTBNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFb2hjTk1UUXhNREV6TVRVME1UVTENCldqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRNd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JLRVhEVEUwTVRBeE16RTENCk5ERTFObG93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXpNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1NrRncweE5ERXcNCk1UTXhOVFF4TlRaYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTXpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRXBoY04NCk1UUXhNREV6TVRVME1UVTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ETXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUMNCkJMa1hEVEUwTVRBeE16RTFOREl3TUZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVFF6TURCYU1Bb0dBMVVkRlFRRENnRUUNCk1Ec0NBZ1M3RncweE5ERXdNVE14TlRReU1EQmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVME16QXdXakFLQmdOVkhSVUUNCkF3b0JCREE3QWdJRXZSY05NVFF4TURFek1UVTBNakF4V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFORE13TUZvd0NnWUQNClZSMFZCQU1LQVFRd093SUNCTHdYRFRFME1UQXhNekUxTkRJd01sb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRRek1EQmENCk1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTb0Z3MHhOREV3TVRNeE5UUXlNRFJhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTANCk16QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVxaGNOTVRReE1ERXpNVFUwTWpBMldqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXgNCk16RTFORE13TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQktVWERURTBNVEF4TXpFMU5ESXdObG93SmpBWUJnTlZIUmdFRVJnUE1qQXgNCk5ERXdNVE14TlRRek1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU25GdzB4TkRFd01UTXhOVFF5TURoYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFF4TURFek1UVTBNekF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFd1JjTk1UUXhNREV6TVRVME1qQTRXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFME1UQXhNekUxTkRNd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JMOFhEVEUwTVRBeE16RTFOREl4TUZvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXpNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1MrRncweE5ERXdNVE14TlRReU1URmENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTXpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRXd4Y05NVFF4TURFek1UVTANCk1qRXlXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ETXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCS2tYRFRFME1UQXgNCk16RTFOREl4TTFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVFF6TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTckZ3MHgNCk5ERXdNVE14TlRReU1UUmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVME16QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUUNCndCY05NVFF4TURFek1UVTBNakUxV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFORE13TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCSzBYRFRFME1UQXhNekUxTkRJeE5sb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRRek1EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdUQ0Z3MHhOREV3TVRNeE5UUXlNVGhhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTBNekF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUV4UmNOTVRReE1ERXpNVFUwTWpFNFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRNd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQkt3WERURTBNVEF4TXpFMU5ESXlNRm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXoNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVEVGdzB4TkRFd01UTXhOVFF5TWpGYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXoNCk1UVTBNekF3V2pBS0JnTlZIUlVFQXdvQkJEQWhBZ0lFeVJjTk1UUXhNREk1TVRNeE1ETTVXakFNTUFvR0ExVWRGUVFEQ2dFR01CTUMNCkFnVE1GdzB4TkRFeE1EVXhORE0zTlRsYU1CTUNBZ1RORncweE5ERXhNRFV4TkRNNE1EWmFNQk1DQWdUT0Z3MHhOREV4TURVeE5ETTQNCk1URmFNQk1DQWdUUEZ3MHhOREV4TURVeE5ETTRNVGRhTURzQ0FnR0hGdzB4TkRFeE1qUXhNekk0TVRWYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFF4TVRJME1UTXlPVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFNUJjTk1UUXhNVEkwTVRNeU9ERTNXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFME1URXlOREV6TWprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JPWVhEVEUwTVRFeU5URTJNVE0wTjFvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOREV4TWpVeE5qRTFNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1RuRncweE5ERXhNalV4TmpJeE1qbGENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1USTFNVFl5TWpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRTZCY05NVFF4TVRJMk1EZ3kNCk9EVXhXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEV5TmpBNE16QXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCUXdYRFRFMU1ERXkNCk56RXhNekF5TlZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE13TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVTkZ3MHgNCk5UQXhNamN4TVRNd01qZGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1EQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUYNCkpCY05NVFV3TVRJM01URXpNREk1V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekF3TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCUThYRFRFMU1ERXlOekV4TXpBek1Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNd01EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdVbEZ3MHhOVEF4TWpjeE1UTXdNelZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNREF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUZEaGNOTVRVd01USTNNVEV6TURNM1dqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpBd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQlNnWERURTFNREV5TnpFeE16QXpPVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXcNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVVFGdzB4TlRBeE1qY3hNVE13TkRGYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTMNCk1URXpNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGSnhjTk1UVXdNVEkzTVRFek1EUXpXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTENCk1ERXlOekV4TXpFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JSRVhEVEUxTURFeU56RXhNekEwTlZvd0pqQVlCZ05WSFJnRUVSZ1ANCk1qQXhOVEF4TWpjeE1UTXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1VtRncweE5UQXhNamN4TVRNd05EZGFNQ1l3R0FZRFZSMFkNCkJCRVlEekl3TVRVd01USTNNVEV6TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkVoY05NVFV3TVRJM01URXpNRFV4V2pBbU1CZ0cNCkExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16RXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCU2tYRFRFMU1ERXlOekV4TXpBMU0xb3cNCkpqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE14TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVVEZ3MHhOVEF4TWpjeE1UTXcNCk5UVmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZLaGNOTVRVd01USTMNCk1URXpNRFUzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekV3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlJRWERURTENCk1ERXlOekV4TXpBMU9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNeE1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVXINCkZ3MHhOVEF4TWpjeE1UTXhNRE5hTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTcNCkFnSUZGUmNOTVRVd01USTNNVEV6TVRBMVdqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpFd01Gb3dDZ1lEVlIwVkJBTUsNCkFRUXdPd0lDQlN3WERURTFNREV5TnpFeE16RXdOMW93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXhNREJhTUFvR0ExVWQNCkZRUURDZ0VFTURzQ0FnVVdGdzB4TlRBeE1qY3hNVE14TURsYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVEV6TVRBd1dqQUsNCkJnTlZIUlVFQXdvQkJEQTdBZ0lGTFJjTk1UVXdNVEkzTVRFek1URXhXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16RXcNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JSY1hEVEUxTURFeU56RXhNekV4TTFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3gNCk1UTXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1V1RncweE5UQXhNamN4TVRNeE1UVmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXcNCk1USTNNVEV6TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkdCY05NVFV3TVRJM01URXpNVEU1V2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERTFNREV5TnpFeE16RXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCUzhYRFRFMU1ERXlOekV4TXpFeU1Wb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TlRBeE1qY3hNVE14TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVWkZ3MHhOVEF4TWpjeE1UTXhNak5hTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZNQmNOTVRVd01USTNNVEV6TVRJMVdqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekV3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlI4WERURTFNREV5TnpFeE16RXkNCk4xb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNeE1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVXhGdzB4TlRBeE1qY3gNCk1UTXhNekZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGSFJjTk1UVXcNCk1USTNNVEV6TVRNeldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JUSVgNCkRURTFNREV5TnpFeE16RXpOVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0MNCkFnVWFGdzB4TlRBeE1qY3hNVE14TXpkYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVEV6TVRBd1dqQUtCZ05WSFJVRUF3b0INCkJEQTdBZ0lGTXhjTk1UVXdNVEkzTVRFek1UTTVXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16RXdNRm93Q2dZRFZSMFYNCkJBTUtBUVF3T3dJQ0JSc1hEVEUxTURFeU56RXhNekUwTVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE15TURCYU1Bb0cNCkExVWRGUVFEQ2dFRU1Ec0NBZ1UwRncweE5UQXhNamN4TVRNeE5ETmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1qQXcNCldqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkhCY05NVFV3TVRJM01URXpNVFEzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXgNCk16SXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVFlYRFRFMU1ERXlOekV4TXpFME9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXgNCk1qY3hNVE15TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVZUZ3MHhOVEF4TWpjeE1UTXhOVEZhTUNZd0dBWURWUjBZQkJFWUR6SXcNCk1UVXdNVEkzTVRFek1qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZOUmNOTVRVd01USTNNVEV6TVRVeldqQW1NQmdHQTFVZEdBUVINCkdBOHlNREUxTURFeU56RXhNekl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlRjWERURTFNREV5TnpFeE16RTFOVm93SmpBWUJnTlYNCkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNeU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVWdGdzB4TlRBeE1qY3hNVE14TlRsYU1DWXcNCkdBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGT0JjTk1UVXdNVEkzTVRFek1qQXgNCldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpJd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JTRVhEVEUxTURFeU56RXgNCk16SXdNMW93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXlNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1U1RncweE5UQXgNCk1qY3hNVE15TURWYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVEV6TWpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkloY04NCk1UVXdNVEkzTVRFek1qQTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16SXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUMNCkJUb1hEVEUxTURFeU56RXhNekl3T1Zvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE15TURCYU1Bb0dBMVVkRlFRRENnRUUNCk1Ec0NBZ1VqRncweE5UQXhNamN4TVRNeU1URmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1qQXdXakFLQmdOVkhSVUUNCkF3b0JCREE3QWdJRk94Y05NVFV3TVRJM01URXpNakV6V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekl3TUZvd0NnWUQNClZSMFZCQU1LQVFRd093SUNCVDBYRFRFMU1ERXlOekUzTWpnek9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TnpJNE1EQmENCk1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVOEZ3MHhOVEF4TWpjeE56STRNemxhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01UY3kNCk9EQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZRQmNOTVRVd01USTNNVGN5T1RBeldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXkNCk56RTNNamt3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlQ0WERURTFNREV5TnpFM01qa3dPVm93SmpBWUJnTlZIUmdFRVJnUE1qQXgNCk5UQXhNamN4TnpJNU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVS9GdzB4TlRBeE1qY3hOekk1TVRGYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFV3TVRJM01UY3lPVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGUWhjTk1UVXdNVEkzTVRjeU9URXpXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFMU1ERXlOekUzTWprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JVRVhEVEUxTURFeU56RTNNamt4TTFvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE56STVNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1ZRRncweE5UQXhNamN4TnpJNU1UVmENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVGN5T1RBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRlF4Y05NVFV3TVRJM01UY3kNCk9URTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFM01qa3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVVFYRFRFMU1ERXkNCk56RTNNamt4TjFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hOekk1TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWUkZ3MHgNCk5UQXhNamN4TnpJNU1UbGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRjeU9UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUYNClN4Y05NVFV3TVRJM01UY3lPVEl3V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RTNNamt3TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCVW9YRFRFMU1ERXlOekUzTWpreU1sb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TnpJNU1EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdWRkZ3MHhOVEF4TWpjeE56STVNakphTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01UY3lPVEF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUZUUmNOTVRVd01USTNNVGN5T1RJeldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekUzTWprd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQlVjWERURTFNREV5TnpFM01qa3lORm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE56STUNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVkpGdzB4TlRBeE1qY3hOekk1TWpSYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTMNCk1UY3lPVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGUmhjTk1UVXdNVEkzTVRjeU9USTFXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTENCk1ERXlOekUzTWprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JVZ1hEVEUxTURFeU56RTNNamt5Tmxvd0pqQVlCZ05WSFJnRUVSZ1ANCk1qQXhOVEF4TWpjeE56STVNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1ZTRncweE5UQXhNamN4TnpJNU1qaGFNQ1l3R0FZRFZSMFkNCkJCRVlEekl3TVRVd01USTNNVGN5T1RBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRlRCY05NVFV3TVRJM01UY3lPVEk0V2pBbU1CZ0cNCkExVWRHQVFSR0E4eU1ERTFNREV5TnpFM01qa3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVTRYRFRFMU1ERXlOekUzTWpreU9Wb3cNCkpqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hOekk1TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWVEZ3MHhOVEF4TWpjeE56STUNCk1qbGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRjeU9UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZUeGNOTVRVd01USTMNCk1UY3lPVE13V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RTNNamt3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlZZWERURTENCk1ERXpNREV3TXpZek5Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNekF4TURNMk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVlgNCkZ3MHhOVEF4TXpBeE1ETTJNemRhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRNd01UQXpOakF3V2pBS0JnTlZIUlVFQXdvQkJEQTcNCkFnSUZXQmNOTVRVd01UTXdNVEF6TmpReFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXpNREV3TXpZd01Gb3dDZ1lEVlIwVkJBTUsNCkFRUXdPd0lDQlZrWERURTFNREV6TURFd016WTBNVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TXpBeE1ETTNNREJhTUFvR0ExVWQNCkZRUURDZ0VFTURzQ0FnVmFGdzB4TlRBeE16QXhNRE0yTkRWYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01UTXdNVEF6TnpBd1dqQUsNCkJnTlZIUlVFQXdvQkJEQTdBZ0lGV3hjTk1UVXdNVE13TVRBek5qUTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV6TURFd016Y3cNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JWd1hEVEUxTURFek1ERXdNelkxTVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE16QXgNCk1ETTNNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1ZkRncweE5UQXhNekF4TURNMk5UTmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXcNCk1UTXdNVEF6TnpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRlhoY05NVFV3TVRNd01UQXpOalUxV2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERTFNREV6TURFd016Y3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVjhYRFRFMU1ERXpNREV3TXpZMU4xb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TlRBeE16QXhNRE0zTURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWZ0Z3MHhOVEF4TXpBeE1ETTNNREZhTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UVXdNVE13TVRBek56QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZZUmNOTVRVd01UTXdNVEF6TnpBeldqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREUxTURFek1ERXdNemN3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQldJWERURTFNREV6TURFd016Y3cNCk5Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNekF4TURNM01EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVmpGdzB4TlRBeE16QXgNCk1ETTNNRGxhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRNd01UQXpOekF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGWkJjTk1UVXcNCk1UTXdNVEF6TnpFeFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXpNREV3TXpjd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JXVVgNCkRURTFNREV6TURFd016Y3hNMW93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TXpBeE1ETTNNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0MNCkFnVm1GdzB4TlRBeE16QXhNRE0zTVRkYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01UTXdNVEF6TnpBd1dqQUtCZ05WSFJVRUF3b0INCkJEQTdBZ0lGWnhjTk1UVXdNVE13TVRBek56RTVXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV6TURFd016Y3dNRm93Q2dZRFZSMFYNCkJBTUtBUVF3T3dJQ0JXZ1hEVEUxTURFek1ERXdNemN5TVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE16QXhNRE0zTURCYU1Bb0cNCkExVWRGUVFEQ2dFRU1Ec0NBZ1ZxRncweE5UQXhNekF4TURNM01qTmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVE13TVRBek56QXcNCldqQUtCZ05WSFJVRUF3b0JCREE3QWdJRmFSY05NVFV3TVRNd01UQXpOekkzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFek1ERXcNCk16Y3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVzBYRFRFMU1ERXpNREV3TXpjeU9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXgNCk16QXhNRE0zTURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWckZ3MHhOVEF4TXpBeE1ETTNNekZhTUNZd0dBWURWUjBZQkJFWUR6SXcNCk1UVXdNVE13TVRBek56QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZiQmNOTVRVd01UTXdNVEF6TnpNeldqQW1NQmdHQTFVZEdBUVINCkdBOHlNREUxTURFek1ERXdNemN3TUZvd0NnWURWUjBWQkFNS0FRUXdFd0lDQlhFWERURTFNREl3TXpFMk16a3hNRm93RXdJQ0JXOFgNCkRURTFNREl3TXpFMk16a3hPVm93RXdJQ0JYQVhEVEUxTURJd016RTJOVEF5TVZvd0V3SUNCWE1YRFRFMU1ESXdNekUyTlRFd01WcWcNCk1EQXVNQXNHQTFVZEZBUUVBZ0lDaERBZkJnTlZIU01FR0RBV2dCUlh3M3pORmFKaEV3cHJQdUhHU2V4T1F4L0RoekFOQmdrcWhraUcNCjl3MEJBUVVGQUFPQ0FRRUFmVjRIVDZOdXI4Si9ianhJOEJjZ3p2MWJYRy9mcWhNVzVmb1hRYlQ0VWUzT3huTXIrOW5VQ29ZSTRQU0sNCnB2ZWxQc1hzWllPSWVodkhjbHFyQXpyczhRVUo4YWdFeEtISlltbjd5SzVuR0YxZlpIM0NXd0dFbHcxeGdYZGxVWGN3TGJWRU5vNFQNCkdaaXYvZEJLUTdlWGp1L1RjQU52WS9aaWIrSFBjbkZnanhYMENhOHduOEZFNjVPWkxpNFhxL2UyMExEcXZNaHc1ajV6U29taFNwVVUNCjBWT1h4UjFiZmZhbEdhRVpqQUFhSDRsY2M5RFFrWGVRSlFxOWdSTGh3U3cvM05WQnBJNmV0b0QxQndWUk1zRkZ0Si9tRDYzc0JqWVQNCjY1OHpJK1BTR2R3Y2xWVnhpSkJDRDNrQ0tkNDFubjJlMXM1SVZUVlNSWWhFYTZrZVpJcWFlQT09PC9YNTA5Q1JMPjwvWDUwOURhdGE+PC9LZXlJbmZvPjwvU2lnbmF0dXJlPjwvbWFyY2FEYUJvbGxvPg==</pay_i:testoAllegato>
                  </pay_i:allegatoRicevuta>
                </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
          </pay_i:RT>
        """
      And initial XML nodoInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header>
              <ppt:intestazionePPT>
                <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
              </ppt:intestazionePPT>
          </soapenv:Header>
          <soapenv:Body>
              <ws:nodoInviaRPT>
                <password>pwdpwdpwd</password>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canaleRtPush#</identificativoCanale>
                <tipoFirma></tipoFirma>
                <rpt>$rptAttachment</rpt>
              </ws:nodoInviaRPT>
          </soapenv:Body>
        </soapenv:Envelope>
        """  
      And initial XML pspInviaRPT
        """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:pspInviaRPTResponse>
                        <pspInviaRPTResponse>
                            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                            <identificativoCarrello>$nodoInviaRPT.identificativoUnivocoVersamento</identificativoCarrello>
                            <parametriPagamentoImmediato>idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento</parametriPagamentoImmediato>
                        </pspInviaRPTResponse>
                    </ws:pspInviaRPTResponse>
                </soapenv:Body>
            </soapenv:Envelope>
        """ 
      And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
      And initial XML nodoInviaRT
        """
          <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:nodoInviaRT>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canaleRtPush#</identificativoCanale>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                  <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                  <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                  <tipoFirma></tipoFirma>
                  <forzaControlloSegno>1</forzaControlloSegno>
                  <rt>$rtAttachment</rt>
              </ws:nodoInviaRT>
          </soapenv:Body>
          </soapenv:Envelope>
        """
      And initial XML paaInviaRT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:paaInviaRTRisposta>
                <paaInviaRTRisposta>
                    <esito>OK</esito>
                </paaInviaRTRisposta>
              </ws:paaInviaRTRisposta>
          </soapenv:Body>
        </soapenv:Envelope>
        """
      And EC replies to nodo-dei-pagamenti with the paaInviaRT
      When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      And psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
      Then check esito is KO of nodoInviaRT response
      And check faultCode is PPT_SEMANTICA of nodoInviaRT response      

    Scenario: Check faultCode PPT_SEMANTICA error on wrong impronta [Bollo_11]
      Given RPT generation
        """
        <?xml version="1.0" encoding="UTF-8"?>
          <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_2_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>idMsgRichiesta</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
                <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
                <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
                <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
                <pay_i:ibanAddebito>IT45R0760103200000000001016</pay_i:ibanAddebito>
                <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
                <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
                <pay_i:datiSingoloVersamento>
                  <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
                  <pay_i:commissioneCaricoPA>10.00</pay_i:commissioneCaricoPA>
                  <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
                  <pay_i:ibanAppoggio>IT45R0760103200000000001016</pay_i:ibanAppoggio>
                  <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
                  <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:datiMarcaBolloDigitale>
                      <pay_i:tipoBollo>01</pay_i:tipoBollo>
                      <pay_i:hashDocumento>LdfszF/ejk/qQ2X0zYnwNgXa4vIMwzHQkDwDDlHRD24=</pay_i:hashDocumento>
                      <pay_i:provinciaResidenza>MI</pay_i:provinciaResidenza>
                  </pay_i:datiMarcaBolloDigitale>
                </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
          </pay_i:RPT>
        """
      And RT generation
        """
          <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRicevuta>TR0001_20120302-10:37:52.0264-F098</pay_i:identificativoMessaggioRicevuta>
            <pay_i:dataOraMessaggioRicevuta>#timedate#</pay_i:dataOraMessaggioRicevuta>
            <pay_i:riferimentoMessaggioRichiesta>#timedate#</pay_i:riferimentoMessaggioRichiesta>
            <pay_i:riferimentoDataRichiesta>2012-01-26</pay_i:riferimentoDataRichiesta>
            <pay_i:istitutoAttestante>
                <pay_i:identificativoUnivocoAttestante>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>istitutoAttestan</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoAttestante>
                <pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante>
                <pay_i:codiceUnitOperAttestante>CodiceUOA</pay_i:codiceUnitOperAttestante>
                <pay_i:denomUnitOperAttestante>DenomUnitOperAttestante</pay_i:denomUnitOperAttestante>
                <pay_i:indirizzoAttestante>IndirizzoAttestante</pay_i:indirizzoAttestante>
                <pay_i:civicoAttestante>11</pay_i:civicoAttestante>
                <pay_i:capAttestante>11111</pay_i:capAttestante>
                <pay_i:localitaAttestante>LocalitaAttestante</pay_i:localitaAttestante>
                <pay_i:provinciaAttestante>ProvinciaAttestante</pay_i:provinciaAttestante>
                <pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante>
            </pay_i:istitutoAttestante>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501F</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
                <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:datiPagamento>
                <pay_i:codiceEsitoPagamento>0</pay_i:codiceEsitoPagamento>
                <pay_i:importoTotalePagato>10.00</pay_i:importoTotalePagato>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
                <pay_i:datiSingoloPagamento>
                  <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
                  <pay_i:esitoSingoloPagamento>Pagamento effettuato</pay_i:esitoSingoloPagamento>
                  <pay_i:dataEsitoSingoloPagamento>2012-03-02</pay_i:dataEsitoSingoloPagamento>
                  <pay_i:identificativoUnivocoRiscossione>$1iuv</pay_i:identificativoUnivocoRiscossione>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica RT</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:allegatoRicevuta>
                      <pay_i:tipoAllegatoRicevuta>BD</pay_i:tipoAllegatoRicevuta>
                      <pay_i:testoAllegato>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PG1hcmNhRGFCb2xsbyB4bWxucz0iaHR0cDovL3d3dy5hZ2VuemlhZW50cmF0ZS5nb3YuaXQvMjAxNC9NYXJjYURhQm9sbG8iIHhtbG5zOm5zMj0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PFBTUD48Q29kaWNlRmlzY2FsZT4xMjM0NTY3ODkwMTwvQ29kaWNlRmlzY2FsZT48RGVub21pbmF6aW9uZT5pZFBzcDE8L0Rlbm9taW5hemlvbmU+PC9QU1A+PElVQkQ+OTk5OTAwMDAwMDAwMDE8L0lVQkQ+PE9yYUFjcXVpc3RvPjIwMTUtMDItMDZUMTU6MDA6MDMuMzIyKzAxOjAwPC9PcmFBY3F1aXN0bz48SW1wb3J0bz4xMC4wMDwvSW1wb3J0bz48VGlwb0JvbGxvPjAxPC9UaXBvQm9sbG8+PEltcHJvbnRhRG9jdW1lbnRvPjxEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNzaGEyNTYiLz48bnMyOkRpZ2VzdFZhbHVlPkR3RER6Ri9lamsvcVEyWDB6WW53TmdYYTR2SU13ekhRa0R3RERsSFJEMjQ9PC9uczI6RGlnZXN0VmFsdWU+PC9JbXByb250YURvY3VtZW50bz4gPGRzOlNpZ25hdHVyZSB4bWxuczpkcz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+DQo8ZHM6U2lnbmVkSW5mbz4NCjxkczpDYW5vbmljYWxpemF0aW9uTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8xMC94bWwtZXhjLWMxNG4jIi8+DQo8ZHM6U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxkc2lnLW1vcmUjcnNhLXNoYTI1NiIvPg0KPGRzOlJlZmVyZW5jZSBVUkk9IiI+DQo8ZHM6VHJhbnNmb3Jtcz4NCjxkczpUcmFuc2Zvcm0gQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjZW52ZWxvcGVkLXNpZ25hdHVyZSIvPg0KPGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyIvPg0KPC9kczpUcmFuc2Zvcm1zPg0KPGRzOkRpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIvPg0KPGRzOkRpZ2VzdFZhbHVlPlp0RjNORTJFZXBaMUtvenlyWExPNXNzT01zK3RXU3VYOHEzdkZPMmFrZHM9PC9kczpEaWdlc3RWYWx1ZT4NCjwvZHM6UmVmZXJlbmNlPg0KPGRzOlJlZmVyZW5jZSBVUkk9IiNfZTZiZmZiNTctZmIzZS00ZjgyLTkxNmQtYjZkODc1NDNjMjRiIj4NCjxkczpUcmFuc2Zvcm1zPg0KPGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyIvPg0KPC9kczpUcmFuc2Zvcm1zPg0KPGRzOkRpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIvPg0KPGRzOkRpZ2VzdFZhbHVlPkE0VnV0NWN1ekp4eEN4OFhWSmg2Y0UrMDNlbmthMTVWUTZxTW9IZUhOYmM9PC9kczpEaWdlc3RWYWx1ZT4NCjwvZHM6UmVmZXJlbmNlPg0KPGRzOlJlZmVyZW5jZT4NCjxkczpUcmFuc2Zvcm1zPg0KPGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyIvPg0KPC9kczpUcmFuc2Zvcm1zPg0KPGRzOkRpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIvPg0KPGRzOkRpZ2VzdFZhbHVlPlExTDd1eTJQKzl6QXBxMUU2L1cyKzFTNlBwUTk5OHlYYUJXNkdmQlg5eTg9PC9kczpEaWdlc3RWYWx1ZT4NCjwvZHM6UmVmZXJlbmNlPg0KPC9kczpTaWduZWRJbmZvPg0KPGRzOlNpZ25hdHVyZVZhbHVlPg0KUlBxTitORk44SXRoQVVEUm5ZazhsTGhXVk93Z294cGF0M0tnK0xLTDVsTzR2bG1OMHl6Q2hnVkFvS0pDekhSU2xlSkRTMXVyU3E4NQ0KNjd5cUVRSDJBVGM5cU5yTVhNb0FnQVY4M1dNL1RHZi9GNHg5bVJBaHN4NU14S01DSzFnbE9lUHhodW1iaG5PSy9Hd0hKVXo1RjhrUw0KVldSek41d3dObGNiTU5VTjBZN1RKeXdpdnVwQ29HUktiT3dXaTdnRUg4N1dDSU9OSFcrcFJBcEVxQjdEdVErK2ljNk80NjdndzNFMg0KUkh0NU4zeThobEx1elJaQldkUTh0akdkc3J0TmZzcGtXQzZqUThMZzc4ZU5abnovQ29nbUFoSmlBN0dsRXdOMUZrU2p3RXlqNDg3dA0KWWhYN1cyTi85WEswdUg1WHdITjNnNTlLbjV1U2N3NEFlb3FEa0E9PQ0KPC9kczpTaWduYXR1cmVWYWx1ZT4NCjxkczpLZXlJbmZvIElkPSJfZTZiZmZiNTctZmIzZS00ZjgyLTkxNmQtYjZkODc1NDNjMjRiIj4NCjxkczpYNTA5RGF0YT4NCjxkczpYNTA5Q2VydGlmaWNhdGU+DQpNSUlHYlRDQ0JGV2dBd0lCQWdJS0dlTldWZ0FBQUFBQkZUQU5CZ2txaGtpRzl3MEJBUXNGQURBWE1SVXdFd1lEVlFRREV3eFRWVUpEDQpRUzFNUVVJdE1ERXdIaGNOTVRVeE1USTFNVFl5TXpRNVdoY05NVGN4TVRJMU1UWXpNelE1V2pCUk1Rc3dDUVlEVlFRR0V3SkpWREVQDQpNQTBHQTFVRUNCTUdTVlJCVEVsQk1ROHdEUVlEVlFRSEV3Wk5TVXhCVGs4eEREQUtCZ05WQkFvVEExTkpRVEVTTUJBR0ExVUVBeE1KDQpSRVZRVTFaSlREQXhNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQW5MK1F3bHdvaGZ1aG5YcVlHVUJLDQpVRWEvWXFtdEVnR3JLSkNRNFJaYkpSVlhtM2dPQUlxWTlIU3hZNmV2ZFN6dzJndEVvQVhINnBtMkNNWEZTZjB3VDh0c1pIbStnVEF3DQo0bHZNdVFRc1NqN3FaMFlOaFYxdmo5a0tyNjdmYjNwRjJHWk50WlZBSVdtZzFTZ3hQcnRGUkp1a0o0ZmorM1RlbXd3SHJEaFA3TjAyDQpUOWIwM0xCdWVPWVl2NFpnNkFaWUI5c1RWc3pWcytrUS9OYys0ZGNpeWhWNzlVQnZwL0w0Q3NYMlFyRnZwd0IwVEQvejJobkhnNDNrDQpPVzZtMTB4Q2lZaDNnd2Z5YjdEUG8zUFNLYnVQeWVCOVp4SjB4c2JSb1N0T2hQeDRBZGNjV1BYU0pxcjd2d3hEZGJHOXpESjFaazFmDQpNU3IvV1JqbkhITTBGZWVaYXdJREFRQUJvNElDZnpDQ0Fuc3dIUVlEVlIwT0JCWUVGS01qME9FakJIeGZFemZiZWhkR1hkNmVNeU9uDQpNQjhHQTFVZEl3UVlNQmFBRkRiclJ3OEoyRGNOOThPbnNzYnNiZ0RGaTMvdE1JR1VCZ05WSFI4RWdZd3dnWWt3Z1lhZ2dZT2dnWUNHDQpQbWgwZEhBNkx5OXdiWE5pWTJ0c1lXSnpNUzVtWlcxekxXeGhZaTV6YVdFdWFYUXZRMlZ5ZEVWdWNtOXNiQzlUVlVKRFFTMU1RVUl0DQpNREV1WTNKc2hqNW9kSFJ3T2k4dmNHMXpjSEpwYkdGaWN6RXVabVZ0Y3kxc1lXSXVjMmxoTG1sMEwwTmxjblJGYm5KdmJHd3ZVMVZDDQpRMEV0VEVGQ0xUQXhMbU55YkRDQ0FaSUdDQ3NHQVFVRkJ3RUJCSUlCaERDQ0FZQXdaZ1lJS3dZQkJRVUhNQUtHV21oMGRIQTZMeTl3DQpiWE53Y21sc1lXSnpNUzVtWlcxekxXeGhZaTV6YVdFdWFYUXZRMlZ5ZEVWdWNtOXNiQzlRVFZOUVVrbE1RVUpUTVM1bVpXMXpMV3hoDQpZaTV6YVdFdWFYUmZVMVZDUTBFdFRFRkNMVEF4TG1OeWREQm1CZ2dyQmdFRkJRY3dBb1phYUhSMGNEb3ZMM0J0YzJKamEyeGhZbk14DQpMbVpsYlhNdGJHRmlMbk5wWVM1cGRDOURaWEowUlc1eWIyeHNMMUJOVTFCU1NVeEJRbE14TG1abGJYTXRiR0ZpTG5OcFlTNXBkRjlUDQpWVUpEUVMxTVFVSXRNREV1WTNKME1GWUdDQ3NHQVFVRkJ6QUNoa3BtYVd4bE9pOHZjRzF6Y0hKcGJHRmljekV2UTJWeWRFVnVjbTlzDQpiQzlRVFZOUVVrbE1RVUpUTVM1bVpXMXpMV3hoWWk1emFXRXVhWFJmVTFWQ1EwRXRURUZDTFRBeExtTnlkREJXQmdnckJnRUZCUWN3DQpBb1pLWm1sc1pUb3ZMM0J0YzJKamEyeGhZbk14TDBObGNuUkZibkp2Ykd3dlVFMVRVRkpKVEVGQ1V6RXVabVZ0Y3kxc1lXSXVjMmxoDQpMbWwwWDFOVlFrTkJMVXhCUWkwd01TNWpjblF3REFZRFZSMFRBUUgvQkFJd0FEQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FnRUFDM2FqDQovVFlTb1NRbFlEUjRIeGF2SW54cjFDeldObkhJS0FSTkNrNWN5ZndRSTkwaVpPTmIxSVcxd2ExbEdmY2hCcXl4cHFsek8xT1BQc3lvDQovTDJ6UDNmQUFNRXRXOFRGd0pOZEh5eUoyQWpzYWYxbk5ETEVDK0lIWVFVekxEdzVXVkV4VFo3SHJXSHBTWVBLWkxlZFIvRjdnSFo3DQpOdWFTRmozNnYxMzBDS0pMdUdtb0QyT0lJZ2JWYW11bmwwa1p5M291dW5kdmNwMDJISGN3U2ZxcU5ZZFlKWXhFWVpqQlFacUhialNsDQpkZTBkT0RiLzFFL0c3N3lvSEJzdzlOcEkrdGloRTk0U2xsRm0xSmpUcytNcXJpdzg2TE9TTXpYdEdmYmdSbkhkTGhUdFFwU1NkaVVmDQp2Zm90QW9yb0xMV2E2SHhreFV6UE5CWEEzV003d0ZNRVVsQ1U4SUxRcWtkTFV6Tnl1N3pkNElwS1RFWmU1c1p0c0U2Y3I4ODV5OUNBDQpUcHJJU2EwVnBscWdwMXJTejJsN0psR3lFVUtXcHpvK2xuZ05LZS82Uk1mSFpQdkVzSXJ6djFZSHNqSXhNVHRQRW1FUnE3RGFXUC90DQpIQTdoRllaV2M0cVVjZlRYRkRXclluMGlwSERieFB2TUt5ZTRvZkZLMGRGWWxnN1p3VXVHejdFU3grcHQ5WjRZQTZ4VUJ6amd6Ti9rDQp3Rkxaa3pyMlk4ZEpteDJIeWoxclJLTFQyRGdxbE5yTndZR2JwMTcrVlllWGd1MnJ4eTVYOGZvOHVMc2RYSEZROGV5cDV3S0lDZHZSDQpsb2dkbTN4bi9ObEkrTFYwMnJnOVVac01udlRVY1k4VHRPN04wQVNPajRuNmlUTXlYTmVmQXJZalRqZjhlR3lhblh4WU9MYz0NCjwvZHM6WDUwOUNlcnRpZmljYXRlPjwvZHM6WDUwOURhdGE+PC9kczpLZXlJbmZvPjwvZHM6U2lnbmF0dXJlPjwvbWFyY2FEYUJvbGxvPg==</pay_i:testoAllegato>
                  </pay_i:allegatoRicevuta>
                </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
          </pay_i:RT>
        """
      And initial XML nodoInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header>
              <ppt:intestazionePPT>
                <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
              </ppt:intestazionePPT>
          </soapenv:Header>
          <soapenv:Body>
              <ws:nodoInviaRPT>
                <password>pwdpwdpwd</password>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canaleRtPush#</identificativoCanale>
                <tipoFirma></tipoFirma>
                <rpt>$rptAttachment</rpt>
              </ws:nodoInviaRPT>
          </soapenv:Body>
        </soapenv:Envelope>
        """  
      And initial XML pspInviaRPT
        """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:pspInviaRPTResponse>
                        <pspInviaRPTResponse>
                            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                            <identificativoCarrello>$nodoInviaRPT.identificativoUnivocoVersamento</identificativoCarrello>
                            <parametriPagamentoImmediato>idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento</parametriPagamentoImmediato>
                        </pspInviaRPTResponse>
                    </ws:pspInviaRPTResponse>
                </soapenv:Body>
            </soapenv:Envelope>
        """ 
      And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
      And initial XML nodoInviaRT
        """
          <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:nodoInviaRT>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canaleRtPush#</identificativoCanale>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                  <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                  <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                  <tipoFirma></tipoFirma>
                  <forzaControlloSegno>1</forzaControlloSegno>
                  <rt>$rtAttachment</rt>
              </ws:nodoInviaRT>
          </soapenv:Body>
          </soapenv:Envelope>
        """
      And initial XML paaInviaRT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:paaInviaRTRisposta>
                <paaInviaRTRisposta>
                    <esito>OK</esito>
                </paaInviaRTRisposta>
              </ws:paaInviaRTRisposta>
          </soapenv:Body>
        </soapenv:Envelope>
        """
      And EC replies to nodo-dei-pagamenti with the paaInviaRT
      When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      And psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
      Then check esito is KO of nodoInviaRT response
      And check faultCode is PPT_SEMANTICA of nodoInviaRT response 

        @prova2
    Scenario: Check faultCode PPT_SEMANTICA error on PSP [Bollo_12]
      Given RPT generation
        """
        <?xml version="1.0" encoding="UTF-8"?>
          <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_2_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>idMsgRichiesta</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
                <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
                <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
                <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
                <pay_i:ibanAddebito>IT45R0760103200000000001016</pay_i:ibanAddebito>
                <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
                <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
                <pay_i:datiSingoloVersamento>
                  <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
                  <pay_i:commissioneCaricoPA>10.00</pay_i:commissioneCaricoPA>
                  <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
                  <pay_i:ibanAppoggio>IT45R0760103200000000001016</pay_i:ibanAppoggio>
                  <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
                  <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:datiMarcaBolloDigitale>
                      <pay_i:tipoBollo>01</pay_i:tipoBollo>
                      <pay_i:hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</pay_i:hashDocumento>
                      <pay_i:provinciaResidenza>MI</pay_i:provinciaResidenza>
                  </pay_i:datiMarcaBolloDigitale>
                </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
          </pay_i:RPT>
        """
      And RT generation
        """
          <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRicevuta>TR0001_20120302-10:37:52.0264-F098</pay_i:identificativoMessaggioRicevuta>
            <pay_i:dataOraMessaggioRicevuta>#timedate#</pay_i:dataOraMessaggioRicevuta>
            <pay_i:riferimentoMessaggioRichiesta>#timedate#</pay_i:riferimentoMessaggioRichiesta>
            <pay_i:riferimentoDataRichiesta>2012-01-26</pay_i:riferimentoDataRichiesta>
            <pay_i:istitutoAttestante>
                <pay_i:identificativoUnivocoAttestante>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>istitutoAttestan</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoAttestante>
                <pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante>
                <pay_i:codiceUnitOperAttestante>CodiceUOA</pay_i:codiceUnitOperAttestante>
                <pay_i:denomUnitOperAttestante>DenomUnitOperAttestante</pay_i:denomUnitOperAttestante>
                <pay_i:indirizzoAttestante>IndirizzoAttestante</pay_i:indirizzoAttestante>
                <pay_i:civicoAttestante>11</pay_i:civicoAttestante>
                <pay_i:capAttestante>11111</pay_i:capAttestante>
                <pay_i:localitaAttestante>LocalitaAttestante</pay_i:localitaAttestante>
                <pay_i:provinciaAttestante>ProvinciaAttestante</pay_i:provinciaAttestante>
                <pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante>
            </pay_i:istitutoAttestante>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                  <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501F</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                  <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                  <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
                <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:datiPagamento>
                <pay_i:codiceEsitoPagamento>0</pay_i:codiceEsitoPagamento>
                <pay_i:importoTotalePagato>10.00</pay_i:importoTotalePagato>
                <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
                <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
                <pay_i:datiSingoloPagamento>
                  <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
                  <pay_i:esitoSingoloPagamento>Pagamento effettuato</pay_i:esitoSingoloPagamento>
                  <pay_i:dataEsitoSingoloPagamento>2012-03-02</pay_i:dataEsitoSingoloPagamento>
                  <pay_i:identificativoUnivocoRiscossione>$1iuv</pay_i:identificativoUnivocoRiscossione>
                  <pay_i:causaleVersamento>pagamento fotocopie pratica RT</pay_i:causaleVersamento>
                  <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                  <pay_i:allegatoRicevuta>
                      <pay_i:tipoAllegatoRicevuta>BD</pay_i:tipoAllegatoRicevuta>
                      <pay_i:testoAllegato>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PG1hcmNhRGFCb2xsbyB4bWxucz0iaHR0cDovL3d3dy5hZ2VuemlhZW50cmF0ZS5nb3YuaXQvMjAxNC9NYXJjYURhQm9sbG8iIHhtbG5zOm5zMj0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PFBTUD48Q29kaWNlRmlzY2FsZT4xMjM0NTY3ODkwMTwvQ29kaWNlRmlzY2FsZT48RGVub21pbmF6aW9uZT5pZFBzcDE8L0Rlbm9taW5hemlvbmU+PC9QU1A+PElVQkQ+OTk5OTAwMDAwMDAwMDQ8L0lVQkQ+PE9yYUFjcXVpc3RvPjIwMTUtMDItMDZUMTU6MDE6MzQuOTc1KzAxOjAwPC9PcmFBY3F1aXN0bz48SW1wb3J0bz4xMC4wMDwvSW1wb3J0bz48VGlwb0JvbGxvPjAxPC9UaXBvQm9sbG8+PEltcHJvbnRhRG9jdW1lbnRvPjxEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGVuYyNzaGEyNTYiLz48bnMyOkRpZ2VzdFZhbHVlPjd6VkVLcHg2QUJmRlhzbU1HeWM0R1NJSVA1U29ubkFOQUtmS0ZRMHZnQVk9PC9uczI6RGlnZXN0VmFsdWU+PC9JbXByb250YURvY3VtZW50bz48U2lnbmF0dXJlIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjIj48U2lnbmVkSW5mbz48Q2Fub25pY2FsaXphdGlvbk1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1Ii8+PFNpZ25hdHVyZU1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZHNpZy1tb3JlI3JzYS1zaGEyNTYiLz48UmVmZXJlbmNlIFVSST0iIj48VHJhbnNmb3Jtcz48VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiLz48L1RyYW5zZm9ybXM+PERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMDQveG1sZW5jI3NoYTI1NiIvPjxEaWdlc3RWYWx1ZT5vOVM0dk5jYm14eGhTQWNFdys2Vnl3Z3dGbURseTBzcVYxN3pYSHllbmQ4PTwvRGlnZXN0VmFsdWU+PC9SZWZlcmVuY2U+PC9TaWduZWRJbmZvPjxTaWduYXR1cmVWYWx1ZT5RTUVxb1JYR1JlSGRNTFhpV3ZHQnJKM2FZdVNEaENtQmVvUXBONWtDaWNrWnhFeStTdlhSY1RNQWx4MHRmZDlsM1Z1dHlPbUJxN3J2DQorTTJGZXN1UUYwOGJhTEhqUEdlNFZOV3BSSjI3WklBYTR0MnVIUlpSY25GeWhCcmh3QTBZMzhxNlhxdU56T2VJcWNkaXBSZXQwNmE5DQpZZ0hXcC9la3dTb0NoR09YamN5WXA4THlyQjRpRWd0RVFOcEV1TXZ3RjRUT29MMThYWS94TXpHVFhaRmdoNzlQR0xoUGNMZE95UFBhDQpqOHl5bklhcHNVNFNudlpzMjMwSWZiWDhoYVJkRVBsTkErSEpFL3JoeENpYzJlL1lhQzg4OEJDak96VG1BL3o2azI4OVNRV1ZzZlVmDQpOZHJVYnprRUhmY01sWHl0ZUNvUTNQTTZ6SUlXK3phM044Q3JKQT09PC9TaWduYXR1cmVWYWx1ZT48S2V5SW5mbyBJZD0ia2V5aW5mbyI+PFg1MDlEYXRhPjxYNTA5Q2VydGlmaWNhdGU+TUlJRGpEQ0NBblNnQXdJQkFnSUNCWEl3RFFZSktvWklodmNOQVFFRkJRQXdOVEVMTUFrR0ExVUVCaE1DU1ZReERqQU1CZ05WQkFvVA0KQlZOdloyVnBNUll3RkFZRFZRUURFdzFEUVNCVGIyZGxhU0JVWlhOME1CNFhEVEUxTURJd016RTJNRGMxTUZvWERUSXhNREl3TXpFMg0KTURZeU9Gb3dTVEVMTUFrR0ExVUVCaE1DU1ZReER6QU5CZ05WQkFvVEJtbGtVSE53TVRFTU1Bb0dBMVVFQ3hNRFVGTlFNUnN3R1FZRA0KVlFRREV4SXhNak0wTlRZM09Ea3dNU0JwWkZCemNERXdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFDOQ0KQ3hPZXppb2UvNXEraDNKN0lTdkJoQUtnQVRVMkRHanpvY0ZOR0ljemNxUE5GbGFFTWk4ek1hY080eTlIeDNPOUkvNGR1akN5dFFuRQ0KelpvUGFYVm5kSmNFVmhvWmk1alNXa3lrQURkVFpxWCtseE5maEdKcXNhc2lvVk4ycmk1SVppVEZ5MjJ0QkRQaUovejFOcmJBVFJ0Sw0KcEZSdUV1UEVCbTYxbnQxSU1kWU9wMCtXaWhXRmJ6VnNCLyswWGRlN3FwY0xrS0V4UEIzTmlnVllBZ0dnby96OFo4OUZ0RjlzeGdSQw0KQUVLQ0FERFpMVEN1ak0vTUFOaFl2N3RZQ29lODFOSVlZa09JbkFmR0VyditZbkg3Ukl5Vndxa2JOaE1YYXZzQWd2MVVjZDlKVVVBVg0KVHc2RXpJb21zVU5xQnd0eWl4U0tvSHFmL09VblIrR3B1azJOQWdNQkFBR2pnWkV3Z1k0d0RnWURWUjBQQVFIL0JBUURBZ1pBTUYwRw0KQTFVZEl3UldNRlNBRkZmRGZNMFZvbUVUQ21zKzRjWko3RTVESDhPSG9UbWtOekExTVFzd0NRWURWUVFHRXdKSlZERU9NQXdHQTFVRQ0KQ2hNRlUyOW5aV2t4RmpBVUJnTlZCQU1URFVOQklGTnZaMlZwSUZSbGMzU0NBUUV3SFFZRFZSME9CQllFRkRIZCtmbHpRQTVOUUFMSw0KWk1TZHFwcjZURjdWTUEwR0NTcUdTSWIzRFFFQkJRVUFBNElCQVFBSVpacEFEa0ZhRkY3VXAyK3h1R2tDMTRDcVlCUENRbERxcW8vLw0KdThwSi83N2NRMThqcXVxb1FJbncwdkVwWDN0dFJqSVNscnNISFVUL0hBQjdJM0E5Vkp3YlEyZXpaSE9uZFVCS2VCSjVrQllDc1RBag0KTEtVYzNpYWt0ZW9hVHdRVVVxT3ZVYVJxb2laZzlXN2FCZGlnekZXcTd0aFlTaTF6emVncXZRVHR2ekdxVS9EdWVtN2t5MVNHZS8zRA0KTnhwZWVVM0pHcUt4cGkyTE5nNnJpVlhPdXU5bWprSXpyVDBPa0dqY2RZKzh1RjhJayt3Q3Byalh0c1l5d0hhUFdWNmdWc2orTzhVUQ0KeDF5bHJsM3NzUmVjUW90VnpoV2RCRVY3RXZYM2dPTDNOanMyWE1TcUNWNTd3eGxLbHMzeW9BY1B6SERENXowY1pyVEJxVDRsbjlySzwvWDUwOUNlcnRpZmljYXRlPjxYNTA5Q1JMPk1JSXdBekNDTHVzQ0FRRXdEUVlKS29aSWh2Y05BUUVGQlFBd05URUxNQWtHQTFVRUJoTUNTVlF4RGpBTUJnTlZCQW9UQlZOdloyVnANCk1SWXdGQVlEVlFRREV3MURRU0JUYjJkbGFTQlVaWE4wRncweE5UQXlNRFV5TXpBeE1EbGFGdzB4TlRBeU1EWXlNekExTURsYU1JSXUNClRqQTZBZ0VJRncweE16QTFNamd4TWpFNU16aGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UTXdOVEk0TVRJeE9UQXdXakFLQmdOVkhSVUUNCkF3b0JCREFUQWdJQXBCY05NVE13TmpFek1UVXdNakl4V2pBVEFnSUJKeGNOTVRNd056STFNVEEwTnpRd1dqQVRBZ0lCSmhjTk1UTXcNCk56STFNVEEwTnpVeVdqQTdBZ0lCSlJjTk1UTXdPVEkxTVRRMU5qQTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERXpNRGt5TlRFME5UWXcNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0FUUVhEVEV6TURreU5URTBOVFl3T1Zvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TXpBNU1qVXgNCk5EVTJNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ0UxRncweE16QTVNall3T1RBMk1ERmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UTXcNCk9USTJNRGt3TmpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJQk5oY05NVE13T1RJMk1Ea3lPVFExV2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERXpNRGt5TmpBNU16QXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNBVGNYRFRFek1Ea3lOakE1TWprME4xb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TXpBNU1qWXdPVE13TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdFNEZ3MHhNekE1TWpZd09UUTFNakZhTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UTXdPVEkyTURrME5qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUJPUmNOTVRNd09USTJNVEl3TmpJeFdqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREV6TURreU5qRXlNRFl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQVRvWERURXpNRGt5TmpFek1Ua3cNCk5Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE16QTVNall4TXpFNU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnRTdGdzB4TXpBNU1qWXgNCk16TXpORGRhTUNZd0dBWURWUjBZQkJFWUR6SXdNVE13T1RJMk1UTXpOREF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lCYkJjTk1UTXgNCk1EQTNNVEl6T1RNNFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFek1UQXdOekV5TXprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3THdJQ0FiTVgNCkRURXpNVEF6TVRFeU1qRXdNbG93R2pBWUJnTlZIUmdFRVJnUE1qQXhNekV3TXpFeE1qSXhNREJhTUM4Q0FnR3lGdzB4TXpFd016RXgNCk1qSXhNakphTUJvd0dBWURWUjBZQkJFWUR6SXdNVE14TURNeE1USXlNVEF3V2pBVEFnSUJ0QmNOTVRNeE1ETXhNVFV3TURVeFdqQVQNCkFnSUJ0UmNOTVRNeE1ETXhNVFV3TURVNVdqQVRBZ0lCdGhjTk1UTXhNRE14TVRVd016QXhXakE3QWdJRGFSY05NVFF3TlRJd01UWTANCk5UUTVXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNRFV5TURFMk5EWXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNBMU1YRFRFek1USXkNCk16RXpOVFl3TjFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TXpFeU1qTXhNelUyTURCYU1Bb0dBMVVkRlFRRENnRUVNQk1DQWdQR0Z3MHgNCk5EQTJNRGt4TXpFMk5EWmFNRHNDQWdOcUZ3MHhOREExTWpBeE5qUTFOVEZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF3TlRJd01UWTANCk5qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVmaGNOTVRReE1ERXpNVFV3TURBM1dqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXgNCk16RTFNREV3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkg4WERURTBNVEF4TXpFMU1EQXlNVm93SmpBWUJnTlZIUmdFRVJnUE1qQXgNCk5ERXdNVE14TlRBeE1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU0JGdzB4TkRFd01UTXhOVEF3TWpKYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFF4TURFek1UVXdNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFZ0JjTk1UUXhNREV6TVRVd01ESTFXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFME1UQXhNekUxTURFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JJTVhEVEUwTVRBeE16RTFNREF5Tmxvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UQXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1NDRncweE5ERXdNVE14TlRBd01qZGENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFV3TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRWhSY05NVFF4TURFek1UVXcNCk1ESTRXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU1ERXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCSVFYRFRFME1UQXgNCk16RTFNREF6TVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVEF4TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTR0Z3MHgNCk5ERXdNVE14TlRBd016SmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVd01UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUUNCmh4Y05NVFF4TURFek1UVXdNRE16V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFNREV3TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCSWtYRFRFME1UQXhNekUxTURBek5Gb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRBeE1EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdTTkZ3MHhOREV3TVRNeE5UQXdNemRhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVXdNVEF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUVpeGNOTVRReE1ERXpNVFV3TURNNFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTURFd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQklvWERURTBNVEF4TXpFMU1EQXpPVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UQXgNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU0lGdzB4TkRFd01UTXhOVEF3TkRGYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXoNCk1UVXdNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFakJjTk1UUXhNREV6TVRVd01EUXpXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTANCk1UQXhNekUxTURFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JJNFhEVEUwTVRBeE16RTFNREEwTkZvd0pqQVlCZ05WSFJnRUVSZ1ANCk1qQXhOREV3TVRNeE5UQXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1NSRncweE5ERXdNVE14TlRBd05EVmFNQ1l3R0FZRFZSMFkNCkJCRVlEekl3TVRReE1ERXpNVFV3TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRWp4Y05NVFF4TURFek1UVXdNRFEzV2pBbU1CZ0cNCkExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU1ERXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCSlVYRFRFME1UQXhNekUxTURBME9Gb3cNCkpqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVEF4TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTVEZ3MHhOREV3TVRNeE5UQXcNCk5EbGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVd01qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVsQmNOTVRReE1ERXoNCk1UVXdNRFV4V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFNREl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkpBWERURTANCk1UQXhNekUxTURBMU0xb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRBeU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU1MNCkZ3MHhOREV3TVRNeE5UQXdOVFZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVXdNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTcNCkFnSUVsaGNOTVRReE1ERXpNVFUwTVRJMVdqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRJd01Gb3dDZ1lEVlIwVkJBTUsNCkFRUXdPd0lDQkpjWERURTBNVEF4TXpFMU5ERXlObG93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXlNREJhTUFvR0ExVWQNCkZRUURDZ0VFTURzQ0FnU1lGdzB4TkRFd01UTXhOVFF4TWpaYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTWpBd1dqQUsNCkJnTlZIUlVFQXdvQkJEQTdBZ0lFbkJjTk1UUXhNREV6TVRVME1USTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ESXcNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JLNFhEVEUwTVRBeE16RTFOREV6TUZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXgNCk5UUXlNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1N2RncweE5ERXdNVE14TlRReE16QmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXgNCk1ERXpNVFUwTWpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRXNSY05NVFF4TURFek1UVTBNVE14V2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERTBNVEF4TXpFMU5ESXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCTE1YRFRFME1UQXhNekUxTkRFek1sb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TkRFd01UTXhOVFF5TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTYkZ3MHhOREV3TVRNeE5UUXhNelZhTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UUXhNREV6TVRVME1qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVtaGNOTVRReE1ERXpNVFUwTVRNMldqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFOREl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkprWERURTBNVEF4TXpFMU5ERXoNCk4xb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRReU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU2RGdzB4TkRFd01UTXgNCk5UUXhNemhhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTBNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFdEJjTk1UUXgNCk1ERXpNVFUwTVRRd1dqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRJd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JMQVgNCkRURTBNVEF4TXpFMU5ERTBNRm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXlNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0MNCkFnU3lGdzB4TkRFd01UTXhOVFF4TkRKYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTWpBd1dqQUtCZ05WSFJVRUF3b0INCkJEQTdBZ0lFdFJjTk1UUXhNREV6TVRVME1UUXpXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ESXdNRm93Q2dZRFZSMFYNCkJBTUtBUVF3T3dJQ0JKNFhEVEUwTVRBeE16RTFOREUwTkZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVFF5TURCYU1Bb0cNCkExVWRGUVFEQ2dFRU1Ec0NBZ1NmRncweE5ERXdNVE14TlRReE5EUmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVME1qQXcNCldqQUtCZ05WSFJVRUF3b0JCREE3QWdJRW9CY05NVFF4TURFek1UVTBNVFEzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTENCk5ESXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCS01YRFRFME1UQXhNekUxTkRFME9Gb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXcNCk1UTXhOVFF5TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTNEZ3MHhOREV3TVRNeE5UUXhOVEJhTUNZd0dBWURWUjBZQkJFWUR6SXcNCk1UUXhNREV6TVRVME1qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUV0aGNOTVRReE1ERXpNVFUwTVRVd1dqQW1NQmdHQTFVZEdBUVINCkdBOHlNREUwTVRBeE16RTFOREl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQkxjWERURTBNVEF4TXpFMU5ERTFNVm93SmpBWUJnTlYNCkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRReU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnUzZGdzB4TkRFd01UTXhOVFF4TlRKYU1DWXcNCkdBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTBNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFb2hjTk1UUXhNREV6TVRVME1UVTENCldqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRNd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JLRVhEVEUwTVRBeE16RTENCk5ERTFObG93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXpNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1NrRncweE5ERXcNCk1UTXhOVFF4TlRaYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTXpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRXBoY04NCk1UUXhNREV6TVRVME1UVTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ETXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUMNCkJMa1hEVEUwTVRBeE16RTFOREl3TUZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVFF6TURCYU1Bb0dBMVVkRlFRRENnRUUNCk1Ec0NBZ1M3RncweE5ERXdNVE14TlRReU1EQmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVME16QXdXakFLQmdOVkhSVUUNCkF3b0JCREE3QWdJRXZSY05NVFF4TURFek1UVTBNakF4V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFORE13TUZvd0NnWUQNClZSMFZCQU1LQVFRd093SUNCTHdYRFRFME1UQXhNekUxTkRJd01sb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRRek1EQmENCk1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTb0Z3MHhOREV3TVRNeE5UUXlNRFJhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTANCk16QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUVxaGNOTVRReE1ERXpNVFUwTWpBMldqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXgNCk16RTFORE13TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQktVWERURTBNVEF4TXpFMU5ESXdObG93SmpBWUJnTlZIUmdFRVJnUE1qQXgNCk5ERXdNVE14TlRRek1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnU25GdzB4TkRFd01UTXhOVFF5TURoYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFF4TURFek1UVTBNekF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFd1JjTk1UUXhNREV6TVRVME1qQTRXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFME1UQXhNekUxTkRNd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JMOFhEVEUwTVRBeE16RTFOREl4TUZvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXpNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1MrRncweE5ERXdNVE14TlRReU1URmENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXpNVFUwTXpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRXd4Y05NVFF4TURFek1UVTANCk1qRXlXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEF4TXpFMU5ETXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCS2tYRFRFME1UQXgNCk16RTFOREl4TTFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TkRFd01UTXhOVFF6TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdTckZ3MHgNCk5ERXdNVE14TlRReU1UUmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UUXhNREV6TVRVME16QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUUNCndCY05NVFF4TURFek1UVTBNakUxV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUwTVRBeE16RTFORE13TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCSzBYRFRFME1UQXhNekUxTkRJeE5sb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5ERXdNVE14TlRRek1EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdUQ0Z3MHhOREV3TVRNeE5UUXlNVGhhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFF4TURFek1UVTBNekF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUV4UmNOTVRReE1ERXpNVFUwTWpFNFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFME1UQXhNekUxTkRNd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQkt3WERURTBNVEF4TXpFMU5ESXlNRm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOREV3TVRNeE5UUXoNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVEVGdzB4TkRFd01UTXhOVFF5TWpGYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1ERXoNCk1UVTBNekF3V2pBS0JnTlZIUlVFQXdvQkJEQWhBZ0lFeVJjTk1UUXhNREk1TVRNeE1ETTVXakFNTUFvR0ExVWRGUVFEQ2dFR01CTUMNCkFnVE1GdzB4TkRFeE1EVXhORE0zTlRsYU1CTUNBZ1RORncweE5ERXhNRFV4TkRNNE1EWmFNQk1DQWdUT0Z3MHhOREV4TURVeE5ETTQNCk1URmFNQk1DQWdUUEZ3MHhOREV4TURVeE5ETTRNVGRhTURzQ0FnR0hGdzB4TkRFeE1qUXhNekk0TVRWYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFF4TVRJME1UTXlPVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lFNUJjTk1UUXhNVEkwTVRNeU9ERTNXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFME1URXlOREV6TWprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JPWVhEVEUwTVRFeU5URTJNVE0wTjFvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOREV4TWpVeE5qRTFNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1RuRncweE5ERXhNalV4TmpJeE1qbGENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRReE1USTFNVFl5TWpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRTZCY05NVFF4TVRJMk1EZ3kNCk9EVXhXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTBNVEV5TmpBNE16QXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCUXdYRFRFMU1ERXkNCk56RXhNekF5TlZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE13TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVTkZ3MHgNCk5UQXhNamN4TVRNd01qZGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1EQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUYNCkpCY05NVFV3TVRJM01URXpNREk1V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekF3TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCUThYRFRFMU1ERXlOekV4TXpBek1Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNd01EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdVbEZ3MHhOVEF4TWpjeE1UTXdNelZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNREF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUZEaGNOTVRVd01USTNNVEV6TURNM1dqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpBd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQlNnWERURTFNREV5TnpFeE16QXpPVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXcNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVVFGdzB4TlRBeE1qY3hNVE13TkRGYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTMNCk1URXpNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGSnhjTk1UVXdNVEkzTVRFek1EUXpXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTENCk1ERXlOekV4TXpFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JSRVhEVEUxTURFeU56RXhNekEwTlZvd0pqQVlCZ05WSFJnRUVSZ1ANCk1qQXhOVEF4TWpjeE1UTXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1VtRncweE5UQXhNamN4TVRNd05EZGFNQ1l3R0FZRFZSMFkNCkJCRVlEekl3TVRVd01USTNNVEV6TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkVoY05NVFV3TVRJM01URXpNRFV4V2pBbU1CZ0cNCkExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16RXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCU2tYRFRFMU1ERXlOekV4TXpBMU0xb3cNCkpqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE14TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVVEZ3MHhOVEF4TWpjeE1UTXcNCk5UVmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZLaGNOTVRVd01USTMNCk1URXpNRFUzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekV3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlJRWERURTENCk1ERXlOekV4TXpBMU9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNeE1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVXINCkZ3MHhOVEF4TWpjeE1UTXhNRE5hTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTcNCkFnSUZGUmNOTVRVd01USTNNVEV6TVRBMVdqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpFd01Gb3dDZ1lEVlIwVkJBTUsNCkFRUXdPd0lDQlN3WERURTFNREV5TnpFeE16RXdOMW93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXhNREJhTUFvR0ExVWQNCkZRUURDZ0VFTURzQ0FnVVdGdzB4TlRBeE1qY3hNVE14TURsYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVEV6TVRBd1dqQUsNCkJnTlZIUlVFQXdvQkJEQTdBZ0lGTFJjTk1UVXdNVEkzTVRFek1URXhXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16RXcNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JSY1hEVEUxTURFeU56RXhNekV4TTFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3gNCk1UTXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1V1RncweE5UQXhNamN4TVRNeE1UVmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXcNCk1USTNNVEV6TVRBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkdCY05NVFV3TVRJM01URXpNVEU1V2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERTFNREV5TnpFeE16RXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCUzhYRFRFMU1ERXlOekV4TXpFeU1Wb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TlRBeE1qY3hNVE14TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVWkZ3MHhOVEF4TWpjeE1UTXhNak5hTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZNQmNOTVRVd01USTNNVEV6TVRJMVdqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekV3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlI4WERURTFNREV5TnpFeE16RXkNCk4xb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNeE1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVXhGdzB4TlRBeE1qY3gNCk1UTXhNekZhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGSFJjTk1UVXcNCk1USTNNVEV6TVRNeldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpFd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JUSVgNCkRURTFNREV5TnpFeE16RXpOVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXhNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0MNCkFnVWFGdzB4TlRBeE1qY3hNVE14TXpkYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVEV6TVRBd1dqQUtCZ05WSFJVRUF3b0INCkJEQTdBZ0lGTXhjTk1UVXdNVEkzTVRFek1UTTVXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16RXdNRm93Q2dZRFZSMFYNCkJBTUtBUVF3T3dJQ0JSc1hEVEUxTURFeU56RXhNekUwTVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE15TURCYU1Bb0cNCkExVWRGUVFEQ2dFRU1Ec0NBZ1UwRncweE5UQXhNamN4TVRNeE5ETmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1qQXcNCldqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkhCY05NVFV3TVRJM01URXpNVFEzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXgNCk16SXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVFlYRFRFMU1ERXlOekV4TXpFME9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXgNCk1qY3hNVE15TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVZUZ3MHhOVEF4TWpjeE1UTXhOVEZhTUNZd0dBWURWUjBZQkJFWUR6SXcNCk1UVXdNVEkzTVRFek1qQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZOUmNOTVRVd01USTNNVEV6TVRVeldqQW1NQmdHQTFVZEdBUVINCkdBOHlNREUxTURFeU56RXhNekl3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlRjWERURTFNREV5TnpFeE16RTFOVm93SmpBWUJnTlYNCkhSZ0VFUmdQTWpBeE5UQXhNamN4TVRNeU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVWdGdzB4TlRBeE1qY3hNVE14TlRsYU1DWXcNCkdBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01URXpNakF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGT0JjTk1UVXdNVEkzTVRFek1qQXgNCldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekV4TXpJd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JTRVhEVEUxTURFeU56RXgNCk16SXdNMW93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE1UTXlNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1U1RncweE5UQXgNCk1qY3hNVE15TURWYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVEV6TWpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRkloY04NCk1UVXdNVEkzTVRFek1qQTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFeE16SXdNRm93Q2dZRFZSMFZCQU1LQVFRd093SUMNCkJUb1hEVEUxTURFeU56RXhNekl3T1Zvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hNVE15TURCYU1Bb0dBMVVkRlFRRENnRUUNCk1Ec0NBZ1VqRncweE5UQXhNamN4TVRNeU1URmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRFek1qQXdXakFLQmdOVkhSVUUNCkF3b0JCREE3QWdJRk94Y05NVFV3TVRJM01URXpNakV6V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RXhNekl3TUZvd0NnWUQNClZSMFZCQU1LQVFRd093SUNCVDBYRFRFMU1ERXlOekUzTWpnek9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TnpJNE1EQmENCk1Bb0dBMVVkRlFRRENnRUVNRHNDQWdVOEZ3MHhOVEF4TWpjeE56STRNemxhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01UY3kNCk9EQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZRQmNOTVRVd01USTNNVGN5T1RBeldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXkNCk56RTNNamt3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlQ0WERURTFNREV5TnpFM01qa3dPVm93SmpBWUJnTlZIUmdFRVJnUE1qQXgNCk5UQXhNamN4TnpJNU1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVS9GdzB4TlRBeE1qY3hOekk1TVRGYU1DWXdHQVlEVlIwWUJCRVkNCkR6SXdNVFV3TVRJM01UY3lPVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGUWhjTk1UVXdNVEkzTVRjeU9URXpXakFtTUJnR0ExVWQNCkdBUVJHQTh5TURFMU1ERXlOekUzTWprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JVRVhEVEUxTURFeU56RTNNamt4TTFvd0pqQVkNCkJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE56STVNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1ZRRncweE5UQXhNamN4TnpJNU1UVmENCk1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTNNVGN5T1RBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRlF4Y05NVFV3TVRJM01UY3kNCk9URTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV5TnpFM01qa3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVVFYRFRFMU1ERXkNCk56RTNNamt4TjFvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hOekk1TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWUkZ3MHgNCk5UQXhNamN4TnpJNU1UbGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRjeU9UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUYNClN4Y05NVFV3TVRJM01UY3lPVEl3V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RTNNamt3TUZvd0NnWURWUjBWQkFNS0FRUXcNCk93SUNCVW9YRFRFMU1ERXlOekUzTWpreU1sb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNamN4TnpJNU1EQmFNQW9HQTFVZEZRUUQNCkNnRUVNRHNDQWdWRkZ3MHhOVEF4TWpjeE56STVNakphTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRJM01UY3lPVEF3V2pBS0JnTlYNCkhSVUVBd29CQkRBN0FnSUZUUmNOTVRVd01USTNNVGN5T1RJeldqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXlOekUzTWprd01Gb3cNCkNnWURWUjBWQkFNS0FRUXdPd0lDQlVjWERURTFNREV5TnpFM01qa3lORm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TWpjeE56STUNCk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVkpGdzB4TlRBeE1qY3hOekk1TWpSYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01USTMNCk1UY3lPVEF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGUmhjTk1UVXdNVEkzTVRjeU9USTFXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTENCk1ERXlOekUzTWprd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JVZ1hEVEUxTURFeU56RTNNamt5Tmxvd0pqQVlCZ05WSFJnRUVSZ1ANCk1qQXhOVEF4TWpjeE56STVNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1ZTRncweE5UQXhNamN4TnpJNU1qaGFNQ1l3R0FZRFZSMFkNCkJCRVlEekl3TVRVd01USTNNVGN5T1RBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRlRCY05NVFV3TVRJM01UY3lPVEk0V2pBbU1CZ0cNCkExVWRHQVFSR0E4eU1ERTFNREV5TnpFM01qa3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVTRYRFRFMU1ERXlOekUzTWpreU9Wb3cNCkpqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE1qY3hOekk1TURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWVEZ3MHhOVEF4TWpjeE56STUNCk1qbGFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVEkzTVRjeU9UQXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZUeGNOTVRVd01USTMNCk1UY3lPVE13V2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFeU56RTNNamt3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQlZZWERURTENCk1ERXpNREV3TXpZek5Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNekF4TURNMk1EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVlgNCkZ3MHhOVEF4TXpBeE1ETTJNemRhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRNd01UQXpOakF3V2pBS0JnTlZIUlVFQXdvQkJEQTcNCkFnSUZXQmNOTVRVd01UTXdNVEF6TmpReFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXpNREV3TXpZd01Gb3dDZ1lEVlIwVkJBTUsNCkFRUXdPd0lDQlZrWERURTFNREV6TURFd016WTBNVm93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TXpBeE1ETTNNREJhTUFvR0ExVWQNCkZRUURDZ0VFTURzQ0FnVmFGdzB4TlRBeE16QXhNRE0yTkRWYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01UTXdNVEF6TnpBd1dqQUsNCkJnTlZIUlVFQXdvQkJEQTdBZ0lGV3hjTk1UVXdNVE13TVRBek5qUTNXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV6TURFd016Y3cNCk1Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JWd1hEVEUxTURFek1ERXdNelkxTVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE16QXgNCk1ETTNNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0NBZ1ZkRncweE5UQXhNekF4TURNMk5UTmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXcNCk1UTXdNVEF6TnpBd1dqQUtCZ05WSFJVRUF3b0JCREE3QWdJRlhoY05NVFV3TVRNd01UQXpOalUxV2pBbU1CZ0dBMVVkR0FRUkdBOHkNCk1ERTFNREV6TURFd016Y3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVjhYRFRFMU1ERXpNREV3TXpZMU4xb3dKakFZQmdOVkhSZ0UNCkVSZ1BNakF4TlRBeE16QXhNRE0zTURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWZ0Z3MHhOVEF4TXpBeE1ETTNNREZhTUNZd0dBWUQNClZSMFlCQkVZRHpJd01UVXdNVE13TVRBek56QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZZUmNOTVRVd01UTXdNVEF6TnpBeldqQW0NCk1CZ0dBMVVkR0FRUkdBOHlNREUxTURFek1ERXdNemN3TUZvd0NnWURWUjBWQkFNS0FRUXdPd0lDQldJWERURTFNREV6TURFd016Y3cNCk5Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXhNekF4TURNM01EQmFNQW9HQTFVZEZRUURDZ0VFTURzQ0FnVmpGdzB4TlRBeE16QXgNCk1ETTNNRGxhTUNZd0dBWURWUjBZQkJFWUR6SXdNVFV3TVRNd01UQXpOekF3V2pBS0JnTlZIUlVFQXdvQkJEQTdBZ0lGWkJjTk1UVXcNCk1UTXdNVEF6TnpFeFdqQW1NQmdHQTFVZEdBUVJHQTh5TURFMU1ERXpNREV3TXpjd01Gb3dDZ1lEVlIwVkJBTUtBUVF3T3dJQ0JXVVgNCkRURTFNREV6TURFd016Y3hNMW93SmpBWUJnTlZIUmdFRVJnUE1qQXhOVEF4TXpBeE1ETTNNREJhTUFvR0ExVWRGUVFEQ2dFRU1Ec0MNCkFnVm1GdzB4TlRBeE16QXhNRE0zTVRkYU1DWXdHQVlEVlIwWUJCRVlEekl3TVRVd01UTXdNVEF6TnpBd1dqQUtCZ05WSFJVRUF3b0INCkJEQTdBZ0lGWnhjTk1UVXdNVE13TVRBek56RTVXakFtTUJnR0ExVWRHQVFSR0E4eU1ERTFNREV6TURFd016Y3dNRm93Q2dZRFZSMFYNCkJBTUtBUVF3T3dJQ0JXZ1hEVEUxTURFek1ERXdNemN5TVZvd0pqQVlCZ05WSFJnRUVSZ1BNakF4TlRBeE16QXhNRE0zTURCYU1Bb0cNCkExVWRGUVFEQ2dFRU1Ec0NBZ1ZxRncweE5UQXhNekF4TURNM01qTmFNQ1l3R0FZRFZSMFlCQkVZRHpJd01UVXdNVE13TVRBek56QXcNCldqQUtCZ05WSFJVRUF3b0JCREE3QWdJRmFSY05NVFV3TVRNd01UQXpOekkzV2pBbU1CZ0dBMVVkR0FRUkdBOHlNREUxTURFek1ERXcNCk16Y3dNRm93Q2dZRFZSMFZCQU1LQVFRd093SUNCVzBYRFRFMU1ERXpNREV3TXpjeU9Wb3dKakFZQmdOVkhSZ0VFUmdQTWpBeE5UQXgNCk16QXhNRE0zTURCYU1Bb0dBMVVkRlFRRENnRUVNRHNDQWdWckZ3MHhOVEF4TXpBeE1ETTNNekZhTUNZd0dBWURWUjBZQkJFWUR6SXcNCk1UVXdNVE13TVRBek56QXdXakFLQmdOVkhSVUVBd29CQkRBN0FnSUZiQmNOTVRVd01UTXdNVEF6TnpNeldqQW1NQmdHQTFVZEdBUVINCkdBOHlNREUxTURFek1ERXdNemN3TUZvd0NnWURWUjBWQkFNS0FRUXdFd0lDQlhFWERURTFNREl3TXpFMk16a3hNRm93RXdJQ0JXOFgNCkRURTFNREl3TXpFMk16a3hPVm93RXdJQ0JYQVhEVEUxTURJd016RTJOVEF5TVZvd0V3SUNCWE1YRFRFMU1ESXdNekUyTlRFd01WcWcNCk1EQXVNQXNHQTFVZEZBUUVBZ0lDaERBZkJnTlZIU01FR0RBV2dCUlh3M3pORmFKaEV3cHJQdUhHU2V4T1F4L0RoekFOQmdrcWhraUcNCjl3MEJBUVVGQUFPQ0FRRUFmVjRIVDZOdXI4Si9ianhJOEJjZ3p2MWJYRy9mcWhNVzVmb1hRYlQ0VWUzT3huTXIrOW5VQ29ZSTRQU0sNCnB2ZWxQc1hzWllPSWVodkhjbHFyQXpyczhRVUo4YWdFeEtISlltbjd5SzVuR0YxZlpIM0NXd0dFbHcxeGdYZGxVWGN3TGJWRU5vNFQNCkdaaXYvZEJLUTdlWGp1L1RjQU52WS9aaWIrSFBjbkZnanhYMENhOHduOEZFNjVPWkxpNFhxL2UyMExEcXZNaHc1ajV6U29taFNwVVUNCjBWT1h4UjFiZmZhbEdhRVpqQUFhSDRsY2M5RFFrWGVRSlFxOWdSTGh3U3cvM05WQnBJNmV0b0QxQndWUk1zRkZ0Si9tRDYzc0JqWVQNCjY1OHpJK1BTR2R3Y2xWVnhpSkJDRDNrQ0tkNDFubjJlMXM1SVZUVlNSWWhFYTZrZVpJcWFlQT09PC9YNTA5Q1JMPjwvWDUwOURhdGE+PC9LZXlJbmZvPjwvU2lnbmF0dXJlPjwvbWFyY2FEYUJvbGxvPg==</pay_i:testoAllegato>
                  </pay_i:allegatoRicevuta>
                </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
          </pay_i:RT>
        """
      And initial XML nodoInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header>
              <ppt:intestazionePPT>
                <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
              </ppt:intestazionePPT>
          </soapenv:Header>
          <soapenv:Body>
              <ws:nodoInviaRPT>
                <password>pwdpwdpwd</password>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canaleRtPush#</identificativoCanale>
                <tipoFirma></tipoFirma>
                <rpt>$rptAttachment</rpt>
              </ws:nodoInviaRPT>
          </soapenv:Body>
        </soapenv:Envelope>
        """  
      And initial XML pspInviaRPT
        """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:pspInviaRPTResponse>
                        <pspInviaRPTResponse>
                            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                            <identificativoCarrello>$nodoInviaRPT.identificativoUnivocoVersamento</identificativoCarrello>
                            <parametriPagamentoImmediato>idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento</parametriPagamentoImmediato>
                        </pspInviaRPTResponse>
                    </ws:pspInviaRPTResponse>
                </soapenv:Body>
            </soapenv:Envelope>
        """ 
      And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
      And initial XML nodoInviaRT
        """
          <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:nodoInviaRT>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canaleRtPush#</identificativoCanale>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                  <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                  <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                  <tipoFirma></tipoFirma>
                  <forzaControlloSegno>1</forzaControlloSegno>
                  <rt>$rtAttachment</rt>
              </ws:nodoInviaRT>
          </soapenv:Body>
          </soapenv:Envelope>
        """
      And initial XML paaInviaRT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
          <soapenv:Header/>
          <soapenv:Body>
              <ws:paaInviaRTRisposta>
                <paaInviaRTRisposta>
                    <esito>OK</esito>
                </paaInviaRTRisposta>
              </ws:paaInviaRTRisposta>
          </soapenv:Body>
        </soapenv:Envelope>
        """
      And EC replies to nodo-dei-pagamenti with the paaInviaRT
      When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      And psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
      Then check esito is KO of nodoInviaRT response
      And check faultCode is PPT_SEMANTICA of nodoInviaRT response 