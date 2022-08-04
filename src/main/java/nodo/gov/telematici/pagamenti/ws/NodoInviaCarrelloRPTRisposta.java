
package nodo.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for nodoInviaCarrelloRPTRisposta complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="nodoInviaCarrelloRPTRisposta"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://ws.pagamenti.telematici.gov/}risposta"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="esitoComplessivoOperazione" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="url" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="listaErroriRPT" type="{http://ws.pagamenti.telematici.gov/}listaErroriRPT" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "nodoInviaCarrelloRPTRisposta", propOrder = {
    "esitoComplessivoOperazione",
    "url",
    "listaErroriRPT"
})
public class NodoInviaCarrelloRPTRisposta
    extends Risposta
{

    @XmlElement(required = true)
    protected String esitoComplessivoOperazione;
    @XmlElement(defaultValue = "")
    protected String url;
    protected ListaErroriRPT listaErroriRPT;

    /**
     * Gets the value of the esitoComplessivoOperazione property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEsitoComplessivoOperazione() {
        return esitoComplessivoOperazione;
    }

    /**
     * Sets the value of the esitoComplessivoOperazione property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEsitoComplessivoOperazione(String value) {
        this.esitoComplessivoOperazione = value;
    }

    /**
     * Gets the value of the url property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getUrl() {
        return url;
    }

    /**
     * Sets the value of the url property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setUrl(String value) {
        this.url = value;
    }

    /**
     * Gets the value of the listaErroriRPT property.
     * 
     * @return
     *     possible object is
     *     {@link ListaErroriRPT }
     *     
     */
    public ListaErroriRPT getListaErroriRPT() {
        return listaErroriRPT;
    }

    /**
     * Sets the value of the listaErroriRPT property.
     * 
     * @param value
     *     allowed object is
     *     {@link ListaErroriRPT }
     *     
     */
    public void setListaErroriRPT(ListaErroriRPT value) {
        this.listaErroriRPT = value;
    }

}
