
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per paGetPaymentV2Response complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paGetPaymentV2Response"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}ctResponse"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="data" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctPaymentPAV2" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paGetPaymentV2Response", propOrder = {
    "data"
})
public class PaGetPaymentV2Response
    extends CtResponse
{

    protected CtPaymentPAV2 data;

    /**
     * Recupera il valore della proprieta data.
     * 
     * @return
     *     possible object is
     *     {@link CtPaymentPAV2 }
     *     
     */
    public CtPaymentPAV2 getData() {
        return data;
    }

    /**
     * Imposta il valore della proprieta data.
     * 
     * @param value
     *     allowed object is
     *     {@link CtPaymentPAV2 }
     *     
     */
    public void setData(CtPaymentPAV2 value) {
        this.data = value;
    }

}
