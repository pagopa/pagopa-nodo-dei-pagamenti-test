
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctPaymentOptionsDescriptionListPA complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctPaymentOptionsDescriptionListPA"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="paymentOptionDescription" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctPaymentOptionDescriptionPA"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctPaymentOptionsDescriptionListPA", propOrder = {
    "paymentOptionDescription"
})
public class CtPaymentOptionsDescriptionListPA {

    @XmlElement(required = true)
    protected CtPaymentOptionDescriptionPA paymentOptionDescription;

    /**
     * Recupera il valore della proprieta paymentOptionDescription.
     * 
     * @return
     *     possible object is
     *     {@link CtPaymentOptionDescriptionPA }
     *     
     */
    public CtPaymentOptionDescriptionPA getPaymentOptionDescription() {
        return paymentOptionDescription;
    }

    /**
     * Imposta il valore della proprieta paymentOptionDescription.
     * 
     * @param value
     *     allowed object is
     *     {@link CtPaymentOptionDescriptionPA }
     *     
     */
    public void setPaymentOptionDescription(CtPaymentOptionDescriptionPA value) {
        this.paymentOptionDescription = value;
    }

}
