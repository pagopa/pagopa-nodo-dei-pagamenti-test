
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctTransferPA complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctTransferPA"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="idTransfer" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stIdTransfer"/&gt;
 *         &lt;element name="transferAmount" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stAmountNotZero"/&gt;
 *         &lt;element name="fiscalCodePA" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stFiscalCodePA"/&gt;
 *         &lt;element name="IBAN" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stIBAN"/&gt;
 *         &lt;element name="remittanceInformation" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140"/&gt;
 *         &lt;element name="transferCategory" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctTransferPA", propOrder = {
    "idTransfer",
    "transferAmount",
    "fiscalCodePA",
    "iban",
    "remittanceInformation",
    "transferCategory"
})
public class CtTransferPA {

    protected int idTransfer;
    @XmlElement(required = true)
    protected BigDecimal transferAmount;
    @XmlElement(required = true)
    protected String fiscalCodePA;
    @XmlElement(name = "IBAN", required = true)
    protected String iban;
    @XmlElement(required = true)
    protected String remittanceInformation;
    @XmlElement(required = true)
    protected String transferCategory;

    /**
     * Recupera il valore della proprietà idTransfer.
     * 
     */
    public int getIdTransfer() {
        return idTransfer;
    }

    /**
     * Imposta il valore della proprietà idTransfer.
     * 
     */
    public void setIdTransfer(int value) {
        this.idTransfer = value;
    }

    /**
     * Recupera il valore della proprietà transferAmount.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getTransferAmount() {
        return transferAmount;
    }

    /**
     * Imposta il valore della proprietà transferAmount.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setTransferAmount(BigDecimal value) {
        this.transferAmount = value;
    }

    /**
     * Recupera il valore della proprietà fiscalCodePA.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFiscalCodePA() {
        return fiscalCodePA;
    }

    /**
     * Imposta il valore della proprietà fiscalCodePA.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFiscalCodePA(String value) {
        this.fiscalCodePA = value;
    }

    /**
     * Recupera il valore della proprietà iban.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIBAN() {
        return iban;
    }

    /**
     * Imposta il valore della proprietà iban.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIBAN(String value) {
        this.iban = value;
    }

    /**
     * Recupera il valore della proprietà remittanceInformation.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRemittanceInformation() {
        return remittanceInformation;
    }

    /**
     * Imposta il valore della proprietà remittanceInformation.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRemittanceInformation(String value) {
        this.remittanceInformation = value;
    }

    /**
     * Recupera il valore della proprietà transferCategory.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTransferCategory() {
        return transferCategory;
    }

    /**
     * Imposta il valore della proprietà transferCategory.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTransferCategory(String value) {
        this.transferCategory = value;
    }

}
