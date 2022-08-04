
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * 
 * Its contains all payment information :
 * 
 * - `creditorReferenceId` : its equal to **IUV** _Identificativo Univoco Versamento_ 
 * - `paymentAmount` : amount, it must be equal to the sums of `transferAmount` present in the `transferList`
 * - `dueDate` : indicates the expiration payment date according to the ISO 8601 format `[YYYY]-[MM]-[DD]`.
 * - `retentionDate` : indicates the retention payment date according to the ISO 8601 format `[YYYY]-[MM]-[DD]`.
 * - `lastPayment` : boolean flag used for in installment payments 
 * - `description` : free text available to describe the payment reasons
 * - `companyName` : Public Administration full name
 * - `officeName` : Public Admninistration Department Name
 * - `debtor` : identifies the debtor to whom the debt position refers
 * - `transferList` : the list of all available transfer information (_see below to details_)
 * - `metadata` : (_see below to details_)
 * 
 *     
 * 
 * <p>Classe Java per ctPaymentPA complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctPaymentPA"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="creditorReferenceId" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35"/&gt;
 *         &lt;element name="paymentAmount" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stAmountNotZero"/&gt;
 *         &lt;element name="dueDate" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stISODate"/&gt;
 *         &lt;element name="retentionDate" type="{http://www.w3.org/2001/XMLSchema}dateTime" minOccurs="0"/&gt;
 *         &lt;element name="lastPayment" type="{http://www.w3.org/2001/XMLSchema}boolean" minOccurs="0"/&gt;
 *         &lt;element name="description" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140"/&gt;
 *         &lt;element name="companyName" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140" minOccurs="0"/&gt;
 *         &lt;element name="officeName" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText140" minOccurs="0"/&gt;
 *         &lt;element name="debtor" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctSubject"/&gt;
 *         &lt;element name="transferList" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctTransferListPA"/&gt;
 *         &lt;element name="metadata" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctMetadata" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctPaymentPA", propOrder = {
    "creditorReferenceId",
    "paymentAmount",
    "dueDate",
    "retentionDate",
    "lastPayment",
    "description",
    "companyName",
    "officeName",
    "debtor",
    "transferList",
    "metadata"
})
public class CtPaymentPA {

    @XmlElement(required = true)
    protected String creditorReferenceId;
    @XmlElement(required = true)
    protected BigDecimal paymentAmount;
    @XmlElement(required = true)
    @XmlSchemaType(name = "date")
    protected XMLGregorianCalendar dueDate;
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar retentionDate;
    protected Boolean lastPayment;
    @XmlElement(required = true)
    protected String description;
    protected String companyName;
    protected String officeName;
    @XmlElement(required = true)
    protected CtSubject debtor;
    @XmlElement(required = true)
    protected CtTransferListPA transferList;
    protected CtMetadata metadata;

    /**
     * Recupera il valore della proprietà creditorReferenceId.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCreditorReferenceId() {
        return creditorReferenceId;
    }

    /**
     * Imposta il valore della proprietà creditorReferenceId.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCreditorReferenceId(String value) {
        this.creditorReferenceId = value;
    }

    /**
     * Recupera il valore della proprietà paymentAmount.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getPaymentAmount() {
        return paymentAmount;
    }

    /**
     * Imposta il valore della proprietà paymentAmount.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setPaymentAmount(BigDecimal value) {
        this.paymentAmount = value;
    }

    /**
     * Recupera il valore della proprietà dueDate.
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
     * Imposta il valore della proprietà dueDate.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setDueDate(XMLGregorianCalendar value) {
        this.dueDate = value;
    }

    /**
     * Recupera il valore della proprietà retentionDate.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getRetentionDate() {
        return retentionDate;
    }

    /**
     * Imposta il valore della proprietà retentionDate.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setRetentionDate(XMLGregorianCalendar value) {
        this.retentionDate = value;
    }

    /**
     * Recupera il valore della proprietà lastPayment.
     * 
     * @return
     *     possible object is
     *     {@link Boolean }
     *     
     */
    public Boolean isLastPayment() {
        return lastPayment;
    }

    /**
     * Imposta il valore della proprietà lastPayment.
     * 
     * @param value
     *     allowed object is
     *     {@link Boolean }
     *     
     */
    public void setLastPayment(Boolean value) {
        this.lastPayment = value;
    }

    /**
     * Recupera il valore della proprietà description.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDescription() {
        return description;
    }

    /**
     * Imposta il valore della proprietà description.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDescription(String value) {
        this.description = value;
    }

    /**
     * Recupera il valore della proprietà companyName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCompanyName() {
        return companyName;
    }

    /**
     * Imposta il valore della proprietà companyName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCompanyName(String value) {
        this.companyName = value;
    }

    /**
     * Recupera il valore della proprietà officeName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOfficeName() {
        return officeName;
    }

    /**
     * Imposta il valore della proprietà officeName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOfficeName(String value) {
        this.officeName = value;
    }

    /**
     * Recupera il valore della proprietà debtor.
     * 
     * @return
     *     possible object is
     *     {@link CtSubject }
     *     
     */
    public CtSubject getDebtor() {
        return debtor;
    }

    /**
     * Imposta il valore della proprietà debtor.
     * 
     * @param value
     *     allowed object is
     *     {@link CtSubject }
     *     
     */
    public void setDebtor(CtSubject value) {
        this.debtor = value;
    }

    /**
     * Recupera il valore della proprietà transferList.
     * 
     * @return
     *     possible object is
     *     {@link CtTransferListPA }
     *     
     */
    public CtTransferListPA getTransferList() {
        return transferList;
    }

    /**
     * Imposta il valore della proprietà transferList.
     * 
     * @param value
     *     allowed object is
     *     {@link CtTransferListPA }
     *     
     */
    public void setTransferList(CtTransferListPA value) {
        this.transferList = value;
    }

    /**
     * Recupera il valore della proprietà metadata.
     * 
     * @return
     *     possible object is
     *     {@link CtMetadata }
     *     
     */
    public CtMetadata getMetadata() {
        return metadata;
    }

    /**
     * Imposta il valore della proprietà metadata.
     * 
     * @param value
     *     allowed object is
     *     {@link CtMetadata }
     *     
     */
    public void setMetadata(CtMetadata value) {
        this.metadata = value;
    }

}
