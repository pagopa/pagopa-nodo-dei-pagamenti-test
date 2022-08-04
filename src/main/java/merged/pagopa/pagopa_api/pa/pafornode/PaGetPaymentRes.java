
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * 
 * Its a response to `paGetPaymentReq` and contains :
 * 
 * - `outcome` and _optional_ `fault` (_see below to details_)
 * - all `data` related to payment (_see below to details_)
 * 
 *       
 * 
 * <p>Classe Java per paGetPaymentRes complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
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
     * Recupera il valore della proprietà data.
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
     * Imposta il valore della proprietà data.
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
