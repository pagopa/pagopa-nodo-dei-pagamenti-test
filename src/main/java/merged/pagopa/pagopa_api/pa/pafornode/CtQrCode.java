
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * 
 * Payment Notice **QR-CODE** data.
 * QR-CODE is ISO/IEC 18004:2015 compliant generated with:
 * 
 * Parameters for generating the QR-CODE
 * 
 * - Symbol Version : 4
 * - Modules : 33x33
 * - Modules width : 3 pixels
 * - ECC Level: M ( max correction error 15%)
 * - Character set : UTF-8
 * 
 * QR-CODE contains a string formatted as :
 * `PAGOPA|002|noticeNumber|fiscalCode|amount`
 * 
 * Where `noticeNumber` is composed by :
 * 
 * `[auxDigit][segregationCode][IUVBase][IUVCheckDigit]`
 * 
 * While `fiscalCode` is the creditor tax code.
 *       
 * 
 * <p>Classe Java per ctQrCode complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctQrCode"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="fiscalCode" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stFiscalCodePA"/&gt;
 *         &lt;element name="noticeNumber" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stNoticeNumber"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctQrCode", propOrder = {
    "fiscalCode",
    "noticeNumber"
})
public class CtQrCode {

    @XmlElement(required = true)
    protected String fiscalCode;
    @XmlElement(required = true)
    protected String noticeNumber;

    /**
     * Recupera il valore della proprietà fiscalCode.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFiscalCode() {
        return fiscalCode;
    }

    /**
     * Imposta il valore della proprietà fiscalCode.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFiscalCode(String value) {
        this.fiscalCode = value;
    }

    /**
     * Recupera il valore della proprietà noticeNumber.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNoticeNumber() {
        return noticeNumber;
    }

    /**
     * Imposta il valore della proprietà noticeNumber.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNoticeNumber(String value) {
        this.noticeNumber = value;
    }

}
