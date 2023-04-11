
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * 
 * Its a response to 'paGetPaymentReq' and contains :
 * 
 * - 'outcome' and _optional_ 'fault' (_see below to details_)
 * - all 'data' related to payment (_see below to details_)
 * 
 *       
 * 
 * <p>Java class for paGetPaymentRes complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="paGetPaymentRes"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctResponse"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="data" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctPaymentPA" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paGetPaymentRes", propOrder = {
    "data"
})
public class PaGetPaymentRes
    extends CtResponse
{

    protected CtPaymentPA data;

    /**
     * Gets the value of the data property.
     * 
     * @return
     *     possible object is
     *     {@link CtPaymentPA }
     *     
     */
    public CtPaymentPA getData() {
        return data;
    }

    /**
     * Sets the value of the data property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtPaymentPA }
     *     
     */
    public void setData(CtPaymentPA value) {
        this.data = value;
    }

}
