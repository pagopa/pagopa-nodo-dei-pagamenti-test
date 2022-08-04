
package rt.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * &lt;p&gt;Java class for paaInviaRichiestaRevocaRisposta complex type.
 * 
 * &lt;p&gt;The following schema fragment specifies the expected content contained within this class.
 * 
 * &lt;pre&gt;
 * &amp;lt;complexType name="paaInviaRichiestaRevocaRisposta"&amp;gt;
 *   &amp;lt;complexContent&amp;gt;
 *     &amp;lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&amp;gt;
 *       &amp;lt;sequence&amp;gt;
 *         &amp;lt;element name="paaInviaRichiestaRevocaRisposta" type="{http://ws.pagamenti.telematici.gov/}tipoInviaRichiestaRevocaRisposta"/&amp;gt;
 *       &amp;lt;/sequence&amp;gt;
 *     &amp;lt;/restriction&amp;gt;
 *   &amp;lt;/complexContent&amp;gt;
 * &amp;lt;/complexType&amp;gt;
 * &lt;/pre&gt;
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paaInviaRichiestaRevocaRisposta", propOrder = {
    "paaInviaRichiestaRevocaRisposta"
})
public class PaaInviaRichiestaRevocaRisposta {

    @XmlElement(required = true)
    protected TipoInviaRichiestaRevocaRisposta paaInviaRichiestaRevocaRisposta;

    /**
     * Gets the value of the paaInviaRichiestaRevocaRisposta property.
     * 
     * @return
     *     possible object is
     *     {@link TipoInviaRichiestaRevocaRisposta }
     *     
     */
    public TipoInviaRichiestaRevocaRisposta getPaaInviaRichiestaRevocaRisposta() {
        return paaInviaRichiestaRevocaRisposta;
    }

    /**
     * Sets the value of the paaInviaRichiestaRevocaRisposta property.
     * 
     * @param value
     *     allowed object is
     *     {@link TipoInviaRichiestaRevocaRisposta }
     *     
     */
    public void setPaaInviaRichiestaRevocaRisposta(TipoInviaRichiestaRevocaRisposta value) {
        this.paaInviaRichiestaRevocaRisposta = value;
    }

}
