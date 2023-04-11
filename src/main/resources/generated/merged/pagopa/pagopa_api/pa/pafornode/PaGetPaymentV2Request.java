
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Classe Java per paGetPaymentV2Request complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paGetPaymentV2Request"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="idPA" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="idBrokerPA" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="idStation" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText35"/&gt;
 *         &lt;element name="qrCode" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctQrCode"/&gt;
 *         &lt;element name="amount" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stAmount" minOccurs="0"/&gt;
 *         &lt;element name="paymentNote" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText210" minOccurs="0"/&gt;
 *         &lt;element name="transferType" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stTransferType" minOccurs="0"/&gt;
 *         &lt;element name="dueDate" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stISODate" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paGetPaymentV2Request", propOrder = {
    "idPA",
    "idBrokerPA",
    "idStation",
    "qrCode",
    "amount",
    "paymentNote",
    "transferType",
    "dueDate"
})
public class PaGetPaymentV2Request {

    @XmlElement(required = true)
    protected String idPA;
    @XmlElement(required = true)
    protected String idBrokerPA;
    @XmlElement(required = true)
    protected String idStation;
    @XmlElement(required = true)
    protected CtQrCode qrCode;
    protected BigDecimal amount;
    protected String paymentNote;
    @XmlSchemaType(name = "string")
    protected StTransferType transferType;
    @XmlSchemaType(name = "date")
    protected XMLGregorianCalendar dueDate;

    /**
     * Recupera il valore della proprieta idPA.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdPA() {
        return idPA;
    }

    /**
     * Imposta il valore della proprieta idPA.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdPA(String value) {
        this.idPA = value;
    }

    /**
     * Recupera il valore della proprieta idBrokerPA.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdBrokerPA() {
        return idBrokerPA;
    }

    /**
     * Imposta il valore della proprieta idBrokerPA.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdBrokerPA(String value) {
        this.idBrokerPA = value;
    }

    /**
     * Recupera il valore della proprieta idStation.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdStation() {
        return idStation;
    }

    /**
     * Imposta il valore della proprieta idStation.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdStation(String value) {
        this.idStation = value;
    }

    /**
     * Recupera il valore della proprieta qrCode.
     * 
     * @return
     *     possible object is
     *     {@link CtQrCode }
     *     
     */
    public CtQrCode getQrCode() {
        return qrCode;
    }

    /**
     * Imposta il valore della proprieta qrCode.
     * 
     * @param value
     *     allowed object is
     *     {@link CtQrCode }
     *     
     */
    public void setQrCode(CtQrCode value) {
        this.qrCode = value;
    }

    /**
     * Recupera il valore della proprieta amount.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getAmount() {
        return amount;
    }

    /**
     * Imposta il valore della proprieta amount.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setAmount(BigDecimal value) {
        this.amount = value;
    }

    /**
     * Recupera il valore della proprieta paymentNote.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPaymentNote() {
        return paymentNote;
    }

    /**
     * Imposta il valore della proprieta paymentNote.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPaymentNote(String value) {
        this.paymentNote = value;
    }

    /**
     * Recupera il valore della proprieta transferType.
     * 
     * @return
     *     possible object is
     *     {@link StTransferType }
     *     
     */
    public StTransferType getTransferType() {
        return transferType;
    }

    /**
     * Imposta il valore della proprieta transferType.
     * 
     * @param value
     *     allowed object is
     *     {@link StTransferType }
     *     
     */
    public void setTransferType(StTransferType value) {
        this.transferType = value;
    }

    /**
     * Recupera il valore della proprieta dueDate.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getDueDate() {
        return dueDate;
    }

    /**
     * Imposta il valore della proprieta dueDate.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setDueDate(XMLGregorianCalendar value) {
        this.dueDate = value;
    }

}
