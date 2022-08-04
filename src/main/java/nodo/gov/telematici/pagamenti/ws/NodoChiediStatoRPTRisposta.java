
package nodo.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for nodoChiediStatoRPTRisposta complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="nodoChiediStatoRPTRisposta"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://ws.pagamenti.telematici.gov/}risposta"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="esito" type="{http://ws.pagamenti.telematici.gov/}esitoChiediStatoRPT"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "nodoChiediStatoRPTRisposta", propOrder = {
    "esito"
})
public class NodoChiediStatoRPTRisposta
    extends Risposta
{

    @XmlElement(required = true)
    protected EsitoChiediStatoRPT esito;

    /**
     * Gets the value of the esito property.
     * 
     * @return
     *     possible object is
     *     {@link EsitoChiediStatoRPT }
     *     
     */
    public EsitoChiediStatoRPT getEsito() {
        return esito;
    }

    /**
     * Sets the value of the esito property.
     * 
     * @param value
     *     allowed object is
     *     {@link EsitoChiediStatoRPT }
     *     
     */
    public void setEsito(EsitoChiediStatoRPT value) {
        this.esito = value;
    }

}
