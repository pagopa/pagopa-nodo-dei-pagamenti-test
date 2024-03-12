import encoding from 'k6/encoding';

export function getMBD(psp, iubd) {
   
return `<marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
<PSP>
<CodiceFiscale>CF60000000006</CodiceFiscale>
<Denominazione>${psp}</Denominazione>
</PSP>
<IUBD>${iubd}</IUBD>
<OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
<Importo>5.00</Importo>
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
<DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</DigestValue>
</Reference>
</SignedInfo>
<SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
</Signature>
</marcaDaBollo>`;

    
}



export function getMbdEncoded(psp, iubd){
	
	let MBD = getMBD(psp, iubd);
	
    let mbdEncoded= encoding.b64encode(MBD);

	return mbdEncoded;
}



	