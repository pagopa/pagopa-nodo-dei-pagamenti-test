
package merged.pagopa.pagopa_api.pa.pafornode;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * 
 * Structure containing the details of possible payments relating to the debt position to be paid.
 * 
 * Currently set at 5 eligible payments per single position.
 * 
 * Where each `paymentOptionDescription` items contains :
 * 
 * - `amount` : payment amount
 * - `options` : indicates the payment criteria accepted by the institution with respect to the amount, or if it accepts for this payment option other than `amount`.
 * - `dueDate` : indicates the expiration payment date according to the ISO 8601 format `[YYYY]-[MM]-[DD]`.
 * - `detailDescription` : Free text available to describe the payment reasons
 * - `allCCP` : indicates that all transfers are associable to all postal IBAN
 * 
 *       
 * 
 * <p>Classe Java per ctPaymentOptionsDescriptionListPA complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctPaymentOptionsDescriptionListPA"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="paymentOptionDescription" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctPaymentOptionDescriptionPA" maxOccurs="5"/&gt;
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
    protected List<CtPaymentOptionDescriptionPA> paymentOptionDescription;

    /**
     * Gets the value of the paymentOptionDescription property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the paymentOptionDescription property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getPaymentOptionDescription().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link CtPaymentOptionDescriptionPA }
     * 
     * 
     */
    public List<CtPaymentOptionDescriptionPA> getPaymentOptionDescription() {
        if (paymentOptionDescription == null) {
            paymentOptionDescription = new ArrayList<CtPaymentOptionDescriptionPA>();
        }
        return this.paymentOptionDescription;
    }

}
