
package nodo.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for risposta complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="risposta"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="fault" type="{http://ws.pagamenti.telematici.gov/}faultBean" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "risposta", propOrder = {
    "fault"
})
@XmlSeeAlso({
    NodoChiediCopiaRTRisposta.class,
    NodoInviaRichiestaStornoRisposta.class,
    NodoInviaRispostaRevocaRisposta.class,
    NodoChiediListaPendentiRPTRisposta.class,
    NodoChiediStatoRPTRisposta.class,
    NodoInviaRPTRisposta.class,
    NodoInviaCarrelloRPTRisposta.class,
    NodoChiediInformativaPSPRisposta.class,
    NodoPAChiediInformativaPARisposta.class,
    NodoChiediElencoQuadraturePARisposta.class,
    NodoChiediQuadraturaPARisposta.class,
    NodoChiediElencoFlussiRendicontazioneRisposta.class,
    NodoChiediFlussoRendicontazioneRisposta.class,
    NodoChiediSceltaWISPRisposta.class
})
public class Risposta {

    protected FaultBean fault;

    /**
     * Gets the value of the fault property.
     * 
     * @return
     *     possible object is
     *     {@link FaultBean }
     *     
     */
    public FaultBean getFault() {
        return fault;
    }

    /**
     * Sets the value of the fault property.
     * 
     * @param value
     *     allowed object is
     *     {@link FaultBean }
     *     
     */
    public void setFault(FaultBean value) {
        this.fault = value;
    }

}
