
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
 *         &lt;element name="outcome" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stOutcome"/&gt;
 *         &lt;element name="fault" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}ctFaultBean" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctResponse", namespace = "http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/", propOrder = {
    "outcome",
    "fault"
})
@XmlSeeAlso({
    PaVerifyPaymentNoticeRes.class,
    PaGetPaymentRes.class,
    PaSendRTRes.class,
    PaDemandPaymentNoticeResponse.class,
    PaGetPaymentV2Response.class,
    PaSendRTV2Response.class
})
public class CtResponse {

    @XmlElement(required = true)
    @XmlSchemaType(name = "string")
    protected StOutcome outcome;
    protected CtFaultBean fault;

    /**
     * Recupera il valore della proprieta outcome.
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
     * Imposta il valore della proprieta outcome.
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
     * Recupera il valore della proprieta fault.
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
     * Imposta il valore della proprieta fault.
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
