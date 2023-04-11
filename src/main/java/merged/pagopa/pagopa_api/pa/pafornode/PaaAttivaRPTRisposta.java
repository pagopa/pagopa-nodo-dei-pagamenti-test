
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per paaAttivaRPTRisposta complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paaAttivaRPTRisposta"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="paaAttivaRPTRisposta" type="{http://ws.pagamenti.telematici.gov/}esitoAttivaRPT"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paaAttivaRPTRisposta", namespace = "http://ws.pagamenti.telematici.gov/", propOrder = {
    "paaAttivaRPTRisposta"
})
public class PaaAttivaRPTRisposta {

    @XmlElement(required = true)
    protected EsitoAttivaRPT paaAttivaRPTRisposta;

    /**
     * Recupera il valore della proprieta paaAttivaRPTRisposta.
     * 
     * @return
     *     possible object is
     *     {@link EsitoAttivaRPT }
     *     
     */
    public EsitoAttivaRPT getPaaAttivaRPTRisposta() {
        return paaAttivaRPTRisposta;
    }

    /**
     * Imposta il valore della proprieta paaAttivaRPTRisposta.
     * 
     * @param value
     *     allowed object is
     *     {@link EsitoAttivaRPT }
     *     
     */
    public void setPaaAttivaRPTRisposta(EsitoAttivaRPT value) {
        this.paaAttivaRPTRisposta = value;
    }

}
