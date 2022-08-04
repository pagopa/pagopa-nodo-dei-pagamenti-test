
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctResponse complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctResponse"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="outcome" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stOutcome"/&gt;
 *         &lt;element name="fault" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctFaultBean" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctResponse", propOrder = {
    "outcome",
    "fault"
})
@XmlSeeAlso({
    PaVerifyPaymentNoticeRes.class,
    PaGetPaymentRes.class,
    PaSendRTRes.class
})
public class CtResponse {

    @XmlElement(required = true)
    @XmlSchemaType(name = "string")
    protected StOutcome outcome;
    protected CtFaultBean fault;

    /**
     * Recupera il valore della proprietà outcome.
     * 
     * @return
     *     possible object is
     *     {@link StOutcome }
     *     
     */
    public StOutcome getOutcome() {
        return outcome;
    }

    /**
     * Imposta il valore della proprietà outcome.
     * 
     * @param value
     *     allowed object is
     *     {@link StOutcome }
     *     
     */
    public void setOutcome(StOutcome value) {
        this.outcome = value;
    }

    /**
     * Recupera il valore della proprietà fault.
     * 
     * @return
     *     possible object is
     *     {@link CtFaultBean }
     *     
     */
    public CtFaultBean getFault() {
        return fault;
    }

    /**
     * Imposta il valore della proprietà fault.
     * 
     * @param value
     *     allowed object is
     *     {@link CtFaultBean }
     *     
     */
    public void setFault(CtFaultBean value) {
        this.fault = value;
    }

}
