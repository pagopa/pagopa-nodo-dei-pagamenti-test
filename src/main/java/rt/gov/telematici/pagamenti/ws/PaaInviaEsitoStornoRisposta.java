
package rt.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * &lt;p&gt;Java class for paaInviaEsitoStornoRisposta complex type.
 * 
 * &lt;p&gt;The following schema fragment specifies the expected content contained within this class.
 * 
 * &lt;pre&gt;
 * &amp;lt;complexType name="paaInviaEsitoStornoRisposta"&amp;gt;
 *   &amp;lt;complexContent&amp;gt;
 *     &amp;lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&amp;gt;
 *       &amp;lt;sequence&amp;gt;
 *         &amp;lt;element name="paaInviaEsitoStornoRisposta" type="{http://ws.pagamenti.telematici.gov/}tipoInviaEsitoStornoRisposta"/&amp;gt;
 *       &amp;lt;/sequence&amp;gt;
 *     &amp;lt;/restriction&amp;gt;
 *   &amp;lt;/complexContent&amp;gt;
 * &amp;lt;/complexType&amp;gt;
 * &lt;/pre&gt;
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paaInviaEsitoStornoRisposta", propOrder = {
    "paaInviaEsitoStornoRisposta"
})
public class PaaInviaEsitoStornoRisposta {

    @XmlElement(required = true)
    protected TipoInviaEsitoStornoRisposta paaInviaEsitoStornoRisposta;

    /**
     * Gets the value of the paaInviaEsitoStornoRisposta property.
     * 
     * @return
     *     possible object is
     *     {@link TipoInviaEsitoStornoRisposta }
     *     
     */
    public TipoInviaEsitoStornoRisposta getPaaInviaEsitoStornoRisposta() {
        return paaInviaEsitoStornoRisposta;
    }

    /**
     * Sets the value of the paaInviaEsitoStornoRisposta property.
     * 
     * @param value
     *     allowed object is
     *     {@link TipoInviaEsitoStornoRisposta }
     *     
     */
    public void setPaaInviaEsitoStornoRisposta(TipoInviaEsitoStornoRisposta value) {
        this.paaInviaEsitoStornoRisposta = value;
    }

}
