Feature: MBD syntax checks in sendPaymentOutcomeV2

   Background:
      Given systems up

   @skip
   Scenario: Define MBD test
      Given initial xml MB
         """
         <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
         <PSP>
         <CodiceFiscale>CF60000000006</CodiceFiscale>
         <Denominazione>#psp#</Denominazione>
         </PSP>
         <IUBD>#iubd#</IUBD>
         <OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
         <Importo>5.00</Importo>
         <TipoBollo>01</TipoBollo>
         <ImprontaDocumento>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
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
         <X509CRL>MIIwAzCCLusCAQEwDQYJKoZIhvcNAQEFBQAwNTELMAkGA1UEBhMCSVQxDjAMBgNVBAoTBVNvZ2Vp MRYwFAYDVQQDEw1DQSBTb2dlaSBUZXN0Fw0xNTAyMDUyMzAxMDlaFw0xNTAyMDYyMzA1MDlaMIIu TjA6AgEIFw0xMzA1MjgxMjE5MzhaMCYwGAYDVR0YBBEYDzIwMTMwNTI4MTIxOTAwWjAKBgNVHRUE AwoBBDATAgIApBcNMTMwNjEzMTUwMjIxWjATAgIBJxcNMTMwNzI1MTA0NzQwWjATAgIBJhcNMTMw NzI1MTA0NzUyWjA7AgIBJRcNMTMwOTI1MTQ1NjA3WjAmMBgGA1UdGAQRGA8yMDEzMDkyNTE0NTYw MFowCgYDVR0VBAMKAQQwOwICATQXDTEzMDkyNTE0NTYwOVowJjAYBgNVHRgEERgPMjAxMzA5MjUx NDU2MDBaMAoGA1UdFQQDCgEEMDsCAgE1Fw0xMzA5MjYwOTA2MDFaMCYwGAYDVR0YBBEYDzIwMTMw OTI2MDkwNjAwWjAKBgNVHRUEAwoBBDA7AgIBNhcNMTMwOTI2MDkyOTQ1WjAmMBgGA1UdGAQRGA8y MDEzMDkyNjA5MzAwMFowCgYDVR0VBAMKAQQwOwICATcXDTEzMDkyNjA5Mjk0N1owJjAYBgNVHRgE ERgPMjAxMzA5MjYwOTMwMDBaMAoGA1UdFQQDCgEEMDsCAgE4Fw0xMzA5MjYwOTQ1MjFaMCYwGAYD VR0YBBEYDzIwMTMwOTI2MDk0NjAwWjAKBgNVHRUEAwoBBDA7AgIBORcNMTMwOTI2MTIwNjIxWjAm MBgGA1UdGAQRGA8yMDEzMDkyNjEyMDYwMFowCgYDVR0VBAMKAQQwOwICAToXDTEzMDkyNjEzMTkw NVowJjAYBgNVHRgEERgPMjAxMzA5MjYxMzE5MDBaMAoGA1UdFQQDCgEEMDsCAgE7Fw0xMzA5MjYx MzMzNDdaMCYwGAYDVR0YBBEYDzIwMTMwOTI2MTMzNDAwWjAKBgNVHRUEAwoBBDA7AgIBbBcNMTMx MDA3MTIzOTM4WjAmMBgGA1UdGAQRGA8yMDEzMTAwNzEyMzkwMFowCgYDVR0VBAMKAQQwLwICAbMX DTEzMTAzMTEyMjEwMlowGjAYBgNVHRgEERgPMjAxMzEwMzExMjIxMDBaMC8CAgGyFw0xMzEwMzEx MjIxMjJaMBowGAYDVR0YBBEYDzIwMTMxMDMxMTIyMTAwWjATAgIBtBcNMTMxMDMxMTUwMDUxWjAT AgIBtRcNMTMxMDMxMTUwMDU5WjATAgIBthcNMTMxMDMxMTUwMzAxWjA7AgIDaRcNMTQwNTIwMTY0 NTQ5WjAmMBgGA1UdGAQRGA8yMDE0MDUyMDE2NDYwMFowCgYDVR0VBAMKAQQwOwICA1MXDTEzMTIy MzEzNTYwN1owJjAYBgNVHRgEERgPMjAxMzEyMjMxMzU2MDBaMAoGA1UdFQQDCgEEMBMCAgPGFw0x NDA2MDkxMzE2NDZaMDsCAgNqFw0xNDA1MjAxNjQ1NTFaMCYwGAYDVR0YBBEYDzIwMTQwNTIwMTY0 NjAwWjAKBgNVHRUEAwoBBDA7AgIEfhcNMTQxMDEzMTUwMDA3WjAmMBgGA1UdGAQRGA8yMDE0MTAx MzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBH8XDTE0MTAxMzE1MDAyMVowJjAYBgNVHRgEERgPMjAx NDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSBFw0xNDEwMTMxNTAwMjJaMCYwGAYDVR0YBBEY DzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEgBcNMTQxMDEzMTUwMDI1WjAmMBgGA1Ud GAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBIMXDTE0MTAxMzE1MDAyNlowJjAY BgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSCFw0xNDEwMTMxNTAwMjda MCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEhRcNMTQxMDEzMTUw MDI4WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBIQXDTE0MTAx MzE1MDAzMVowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSGFw0x NDEwMTMxNTAwMzJaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIE hxcNMTQxMDEzMTUwMDMzWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQw OwICBIkXDTE0MTAxMzE1MDAzNFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQD CgEEMDsCAgSNFw0xNDEwMTMxNTAwMzdaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNV HRUEAwoBBDA7AgIEixcNMTQxMDEzMTUwMDM4WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDEwMFow CgYDVR0VBAMKAQQwOwICBIoXDTE0MTAxMzE1MDAzOVowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAx MDBaMAoGA1UdFQQDCgEEMDsCAgSIFw0xNDEwMTMxNTAwNDFaMCYwGAYDVR0YBBEYDzIwMTQxMDEz MTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEjBcNMTQxMDEzMTUwMDQzWjAmMBgGA1UdGAQRGA8yMDE0 MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBI4XDTE0MTAxMzE1MDA0NFowJjAYBgNVHRgEERgP MjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSRFw0xNDEwMTMxNTAwNDVaMCYwGAYDVR0Y BBEYDzIwMTQxMDEzMTUwMTAwWjAKBgNVHRUEAwoBBDA7AgIEjxcNMTQxMDEzMTUwMDQ3WjAmMBgG A1UdGAQRGA8yMDE0MTAxMzE1MDEwMFowCgYDVR0VBAMKAQQwOwICBJUXDTE0MTAxMzE1MDA0OFow JjAYBgNVHRgEERgPMjAxNDEwMTMxNTAxMDBaMAoGA1UdFQQDCgEEMDsCAgSTFw0xNDEwMTMxNTAw NDlaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMjAwWjAKBgNVHRUEAwoBBDA7AgIElBcNMTQxMDEz MTUwMDUxWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1MDIwMFowCgYDVR0VBAMKAQQwOwICBJAXDTE0 MTAxMzE1MDA1M1owJjAYBgNVHRgEERgPMjAxNDEwMTMxNTAyMDBaMAoGA1UdFQQDCgEEMDsCAgSS Fw0xNDEwMTMxNTAwNTVaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTUwMjAwWjAKBgNVHRUEAwoBBDA7 AgIElhcNMTQxMDEzMTU0MTI1WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMK AQQwOwICBJcXDTE0MTAxMzE1NDEyNlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1Ud FQQDCgEEMDsCAgSYFw0xNDEwMTMxNTQxMjZaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAK BgNVHRUEAwoBBDA7AgIEnBcNMTQxMDEzMTU0MTI3WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIw MFowCgYDVR0VBAMKAQQwOwICBK4XDTE0MTAxMzE1NDEzMFowJjAYBgNVHRgEERgPMjAxNDEwMTMx NTQyMDBaMAoGA1UdFQQDCgEEMDsCAgSvFw0xNDEwMTMxNTQxMzBaMCYwGAYDVR0YBBEYDzIwMTQx MDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEsRcNMTQxMDEzMTU0MTMxWjAmMBgGA1UdGAQRGA8y MDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBLMXDTE0MTAxMzE1NDEzMlowJjAYBgNVHRgE ERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgSbFw0xNDEwMTMxNTQxMzVaMCYwGAYD VR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEmhcNMTQxMDEzMTU0MTM2WjAm MBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBJkXDTE0MTAxMzE1NDEz N1owJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgSdFw0xNDEwMTMx NTQxMzhaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEtBcNMTQx MDEzMTU0MTQwWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBLAX DTE0MTAxMzE1NDE0MFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsC AgSyFw0xNDEwMTMxNTQxNDJaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoB BDA7AgIEtRcNMTQxMDEzMTU0MTQzWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDIwMFowCgYDVR0V BAMKAQQwOwICBJ4XDTE0MTAxMzE1NDE0NFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQyMDBaMAoG A1UdFQQDCgEEMDsCAgSfFw0xNDEwMTMxNTQxNDRaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAw WjAKBgNVHRUEAwoBBDA7AgIEoBcNMTQxMDEzMTU0MTQ3WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1 NDIwMFowCgYDVR0VBAMKAQQwOwICBKMXDTE0MTAxMzE1NDE0OFowJjAYBgNVHRgEERgPMjAxNDEw MTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgS4Fw0xNDEwMTMxNTQxNTBaMCYwGAYDVR0YBBEYDzIw MTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEthcNMTQxMDEzMTU0MTUwWjAmMBgGA1UdGAQR GA8yMDE0MTAxMzE1NDIwMFowCgYDVR0VBAMKAQQwOwICBLcXDTE0MTAxMzE1NDE1MVowJjAYBgNV HRgEERgPMjAxNDEwMTMxNTQyMDBaMAoGA1UdFQQDCgEEMDsCAgS6Fw0xNDEwMTMxNTQxNTJaMCYw GAYDVR0YBBEYDzIwMTQxMDEzMTU0MjAwWjAKBgNVHRUEAwoBBDA7AgIEohcNMTQxMDEzMTU0MTU1 WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBKEXDTE0MTAxMzE1 NDE1NlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgSkFw0xNDEw MTMxNTQxNTZaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIEphcN MTQxMDEzMTU0MTU3WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwIC BLkXDTE0MTAxMzE1NDIwMFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEE MDsCAgS7Fw0xNDEwMTMxNTQyMDBaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUE AwoBBDA7AgIEvRcNMTQxMDEzMTU0MjAxWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYD VR0VBAMKAQQwOwICBLwXDTE0MTAxMzE1NDIwMlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBa MAoGA1UdFQQDCgEEMDsCAgSoFw0xNDEwMTMxNTQyMDRaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0 MzAwWjAKBgNVHRUEAwoBBDA7AgIEqhcNMTQxMDEzMTU0MjA2WjAmMBgGA1UdGAQRGA8yMDE0MTAx MzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBKUXDTE0MTAxMzE1NDIwNlowJjAYBgNVHRgEERgPMjAx NDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgSnFw0xNDEwMTMxNTQyMDhaMCYwGAYDVR0YBBEY DzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIEwRcNMTQxMDEzMTU0MjA4WjAmMBgGA1Ud GAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBL8XDTE0MTAxMzE1NDIxMFowJjAY BgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgS+Fw0xNDEwMTMxNTQyMTFa MCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIEwxcNMTQxMDEzMTU0 MjEyWjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQwOwICBKkXDTE0MTAx MzE1NDIxM1owJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQDCgEEMDsCAgSrFw0x NDEwMTMxNTQyMTRaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNVHRUEAwoBBDA7AgIE wBcNMTQxMDEzMTU0MjE1WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFowCgYDVR0VBAMKAQQw OwICBK0XDTE0MTAxMzE1NDIxNlowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQzMDBaMAoGA1UdFQQD CgEEMDsCAgTCFw0xNDEwMTMxNTQyMThaMCYwGAYDVR0YBBEYDzIwMTQxMDEzMTU0MzAwWjAKBgNV HRUEAwoBBDA7AgIExRcNMTQxMDEzMTU0MjE4WjAmMBgGA1UdGAQRGA8yMDE0MTAxMzE1NDMwMFow CgYDVR0VBAMKAQQwOwICBKwXDTE0MTAxMzE1NDIyMFowJjAYBgNVHRgEERgPMjAxNDEwMTMxNTQz MDBaMAoGA1UdFQQDCgEEMDsCAgTEFw0xNDEwMTMxNTQyMjFaMCYwGAYDVR0YBBEYDzIwMTQxMDEz MTU0MzAwWjAKBgNVHRUEAwoBBDAhAgIEyRcNMTQxMDI5MTMxMDM5WjAMMAoGA1UdFQQDCgEGMBMC AgTMFw0xNDExMDUxNDM3NTlaMBMCAgTNFw0xNDExMDUxNDM4MDZaMBMCAgTOFw0xNDExMDUxNDM4 MTFaMBMCAgTPFw0xNDExMDUxNDM4MTdaMDsCAgGHFw0xNDExMjQxMzI4MTVaMCYwGAYDVR0YBBEY DzIwMTQxMTI0MTMyOTAwWjAKBgNVHRUEAwoBBDA7AgIE5BcNMTQxMTI0MTMyODE3WjAmMBgGA1Ud GAQRGA8yMDE0MTEyNDEzMjkwMFowCgYDVR0VBAMKAQQwOwICBOYXDTE0MTEyNTE2MTM0N1owJjAY BgNVHRgEERgPMjAxNDExMjUxNjE1MDBaMAoGA1UdFQQDCgEEMDsCAgTnFw0xNDExMjUxNjIxMjla MCYwGAYDVR0YBBEYDzIwMTQxMTI1MTYyMjAwWjAKBgNVHRUEAwoBBDA7AgIE6BcNMTQxMTI2MDgy ODUxWjAmMBgGA1UdGAQRGA8yMDE0MTEyNjA4MzAwMFowCgYDVR0VBAMKAQQwOwICBQwXDTE1MDEy NzExMzAyNVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMwMDBaMAoGA1UdFQQDCgEEMDsCAgUNFw0x NTAxMjcxMTMwMjdaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMDAwWjAKBgNVHRUEAwoBBDA7AgIF JBcNMTUwMTI3MTEzMDI5WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzAwMFowCgYDVR0VBAMKAQQw OwICBQ8XDTE1MDEyNzExMzAzMVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMwMDBaMAoGA1UdFQQD CgEEMDsCAgUlFw0xNTAxMjcxMTMwMzVaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMDAwWjAKBgNV HRUEAwoBBDA7AgIFDhcNMTUwMTI3MTEzMDM3WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzAwMFow CgYDVR0VBAMKAQQwOwICBSgXDTE1MDEyNzExMzAzOVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMw MDBaMAoGA1UdFQQDCgEEMDsCAgUQFw0xNTAxMjcxMTMwNDFaMCYwGAYDVR0YBBEYDzIwMTUwMTI3 MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFJxcNMTUwMTI3MTEzMDQzWjAmMBgGA1UdGAQRGA8yMDE1 MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBREXDTE1MDEyNzExMzA0NVowJjAYBgNVHRgEERgP MjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUmFw0xNTAxMjcxMTMwNDdaMCYwGAYDVR0Y BBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFEhcNMTUwMTI3MTEzMDUxWjAmMBgG A1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBSkXDTE1MDEyNzExMzA1M1ow JjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUTFw0xNTAxMjcxMTMw NTVaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7AgIFKhcNMTUwMTI3 MTEzMDU3WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMKAQQwOwICBRQXDTE1 MDEyNzExMzA1OVowJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1UdFQQDCgEEMDsCAgUr Fw0xNTAxMjcxMTMxMDNaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAKBgNVHRUEAwoBBDA7 AgIFFRcNMTUwMTI3MTEzMTA1WjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEwMFowCgYDVR0VBAMK AQQwOwICBSwXDTE1MDEyNzExMzEwN1owJjAYBgNVHRgEERgPMjAxNTAxMjcxMTMxMDBaMAoGA1Ud FQQDCgEEMDsCAgUWFw0xNTAxMjcxMTMxMDlaMCYwGAYDVR0YBBEYDzIwMTUwMTI3MTEzMTAwWjAK BgNVHRUEAwoBBDA7AgIFLRcNMTUwMTI3MTEzMTExWjAmMBgGA1UdGAQRGA8yMDE1MDEyNzExMzEw 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</X509CRL>
         </X509Data>
         </KeyInfo>
         </Signature>
         </marcaDaBollo>
         """

   @skip
   Scenario: sendPaymentOutcomeV2
      Given initial XML sendPaymentOutcomeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeV2Request>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <idempotencyKey>#idempotency_key#</idempotencyKey>
         <paymentTokens>
         <paymentToken>12345678901234567890123456789012</paymentToken>
         </paymentTokens>
         <outcome>OK</outcome>
         <!--Optional:-->
         <details>
         <paymentMethod>creditCard</paymentMethod>
         <!--Optional:-->
         <paymentChannel>app</paymentChannel>
         <fee>2.00</fee>
         <primaryCiIncurredFee>1.00</primaryCiIncurredFee>
         <idBundle>1</idBundle>
         <idCiBundle>1.00</idCiBundle>
         <!--Optional:-->
         <payer>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
         </uniqueIdentifier>
         <fullName>name</fullName>
         <!--Optional:-->
         <streetName>street</streetName>
         <!--Optional:-->
         <civicNumber>civic</civicNumber>
         <!--Optional:-->
         <postalCode>postal</postalCode>
         <!--Optional:-->
         <city>city</city>
         <!--Optional:-->
         <stateProvinceRegion>state</stateProvinceRegion>
         <!--Optional:-->
         <country>IT</country>
         <!--Optional:-->
         <e-mail>prova@test.it</e-mail>
         </payer>
         <applicationDate>2021-12-12</applicationDate>
         <transferDate>2021-12-11</transferDate>
         <marcheDaBollo>
         <marcaDaBollo>
         <paymentToken>12345678901234567890123456789012</paymentToken>
         <idTransfer>1</idTransfer>
         <MBDAttachment>$bollo</MBDAttachment>
         </marcaDaBollo>
         </marcheDaBollo>
         </details>
         </nod:sendPaymentOutcomeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   # PPT_SINTASSI_XSD error on sendPaymentOutcomeV2 for wrong syntax in MBD
   Scenario Outline: Check PPT_SINTASSI_XSD error
      Given the Define MBD test scenario executed successfully
      And <elem> with <value> in MB
      And MB generation
         """
         $MB
         """
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SINTASSI_XSD of sendPaymentOutcomeV2 response
      And check description is Errore validazione marca da bollo of sendPaymentOutcomeV2 response
      Examples:
         | elem                   | value                         | Test   |
         | PSP                    | None                          | Test 1 |
         | PSP                    | Empty                         | Test 2 |
         | PSP                    | RemoveParent                  | Test 3 |
         | CodiceFiscale          | None                          | Test 3 |
         | CodiceFiscale          | Empty                         | Test 3 |
         | Denominazione          | None                          | Test 3 |
         | Denominazione          | Empty                         | Test 3 |
         | IUBD                   | None                          | Test 3 |
         | IUBD                   | Empty                         | Test 3 |
         | OraAcquisto            | None                          | Test 3 |
         | OraAcquisto            | Empty                         | Test 3 |
         | OraAcquisto            | 15:00:44.659                  | Test 3 |
         | OraAcquisto            | 2022-02-06                    | Test 3 |
         | OraAcquisto            | 02-06-2022T15:00:44.659+01:00 | Test 3 |
         | Importo                | None                          | Test 3 |
         | Importo                | Empty                         | Test 3 |
         | Importo                | 5                             | Test 3 |
         | Importo                | 5.8                           | Test 3 |
         | Importo                | 5.845                         | Test 3 |
         | Importo                | 5,84                          | Test 3 |
         | TipoBollo              | None                          | Test 3 |
         | TipoBollo              | Empty                         | Test 3 |
         | TipoBollo              | 02                            | Test 3 |
         | ImprontaDocumento      | None                          | Test 3 |
         | ImprontaDocumento      | Empty                         | Test 3 |
         | ImprontaDocumento      | RemoveParent                  | Test 3 |
         | DigestMethod           | None                          | Test 3 |
         | DigestMethod           | Empty                         | Test 3 |
         | ns2:DigestValue        | None                          | Test 3 |
         | ns2:DigestValue        | Empty                         | Test 3 |
         | ns2:DigestValue        | nobase64                      | Test 3 |
         | Signature              | None                          | Test 3 |
         | Signature              | Empty                         | Test 3 |
         | SignedInfo             | None                          | Test 3 |
         | SignedInfo             | Empty                         | Test 3 |
         | SignedInfo             | RemoveParent                  | Test 3 |
         | CanonicalizationMethod | None                          | Test 3 |
         | CanonicalizationMethod | Empty                         | Test 3 |
         | SignatureMethod        | None                          | Test 3 |
         | SignatureMethod        | Empty                         | Test 3 |
         | Reference              | None                          | Test 3 |
         | Reference              | Empty                         | Test 3 |
         | Transforms             | Empty                         | Test 3 |
         | Transforms             | RemoveParent                  | Test 3 |
         | Transform              | None                          | Test 3 |
         | Transform              | Empty                         | Test 3 |
         | DigestMethod           | None                          | Test 3 |
         | DigestMethod           | Empty                         | Test 3 |
         | DigestValue            | None                          | Test 3 |
         | DigestValue            | Empty                         | Test 3 |
         | DigestValue            | nobase64                      | Test 3 |
         | SignatureValue         | None                          | Test 3 |
         | SignatureValue         | Empty                         | Test 3 |
         | SignatureValue         | nobase64                      | Test 3 |
         | KeyInfo                | None                          | Test 3 |
         | KeyInfo                | Empty                         | Test 3 |
         | KeyInfo                | RemoveParent                  | Test 3 |
         | X509Data               | None                          | Test 3 |
         | X509Data               | Empty                         | Test 3 |
         | X509Data               | RemoveParent                  | Test 3 |
         | X509Certificate        | None                          | Test 3 |
         | X509Certificate        | Empty                         | Test 3 |
         | X509Certificate        | nobase64                      | Test 3 |
         | X509CRL                | None                          | Test 3 |
         | X509CRL                | Empty                         | Test 3 |
         | X509CRL                | nobase64                      | Test 3 |


   # sendPaymentOutcomeV2 OK
   Scenario Outline: Check sendPaymentOutcomeV2 OK
      Given the Define MBD test scenario executed successfully
      And <elem> with <value> in MB
      And MB generation
         """
         $MB
         """
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is not PPT_SINTASSI_XSD of sendPaymentOutcomeV2 response
      And check faultCode is not PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
      And check faultCode is not PPT_SEMANTICA of sendPaymentOutcomeV2 response
      Examples:
         | elem       | value | Test   |
         | Transforms | None  | Test 3 |