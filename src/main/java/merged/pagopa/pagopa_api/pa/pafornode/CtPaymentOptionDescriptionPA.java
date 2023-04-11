
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Classe Java per ctPaymentOptionDescriptionPA complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctPaymentOptionDescriptionPA"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="amount" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stAmount"/&gt;
 *         &lt;element name="options" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stAmountOption"/&gt;
 *         &lt;element name="dueDate" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stISODate" minOccurs="0"/&gt;
 *         &lt;element name="detailDescription" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText140" minOccurs="0"/&gt;
 *         &lt;element name="allCCP" type="{http://www.w3.org/2001/XMLSchema}boolean"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctPaymentOptionDescriptionPA", propOrder = {
    "amount",
    "options",
    "dueDate",
    "detailDescription",
    "allCCP"
})
public class CtPaymentOptionDescriptionPA {

    @XmlElement(required = true)
    protected BigDecimal amount;
    @XmlElement(required = true)
    @XmlSchemaType(name = "string")
    protected StAmountOption options;
    @XmlSchemaType(name = "date")
    protected XMLGregorianCalendar dueDate;
    protected String detailDescription;
    protected boolean allCCP;

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
     * Recupera il valore della proprieta options.
     * 
     * @return
     *     possible object is
     *     {@link StAmountOption }
     *     
     */
    public StAmountOption getOptions() {
        return options;
    }

    /**
     * Imposta il valore della proprieta options.
     * 
     * @param value
     *     allowed object is
     *     {@link StAmountOption }
     *     
     */
    public void setOptions(StAmountOption value) {
        this.options = value;
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

    /**
     * Recupera il valore della proprieta detailDescription.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDetailDescription() {
        return detailDescription;
    }

    /**
     * Imposta il valore della proprieta detailDescription.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDetailDescription(String value) {
        this.detailDescription = value;
    }

    /**
     * Recupera il valore della proprieta allCCP.
     * 
     */
    public boolean isAllCCP() {
        return allCCP;
    }

    /**
     * Imposta il valore della proprieta allCCP.
     * 
     */
    public void setAllCCP(boolean value) {
        this.allCCP = value;
    }

}
