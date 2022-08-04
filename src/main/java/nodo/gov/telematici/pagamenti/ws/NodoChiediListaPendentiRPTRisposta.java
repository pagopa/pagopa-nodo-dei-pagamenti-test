
package nodo.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for nodoChiediListaPendentiRPTRisposta complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="nodoChiediListaPendentiRPTRisposta"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://ws.pagamenti.telematici.gov/}risposta"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="listaRPTPendenti" type="{http://ws.pagamenti.telematici.gov/}tipoListaRPTPendenti" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "nodoChiediListaPendentiRPTRisposta", propOrder = {
    "listaRPTPendenti"
})
public class NodoChiediListaPendentiRPTRisposta
    extends Risposta
{

    protected TipoListaRPTPendenti listaRPTPendenti;

    /**
     * Gets the value of the listaRPTPendenti property.
     * 
     * @return
     *     possible object is
     *     {@link TipoListaRPTPendenti }
     *     
     */
    public TipoListaRPTPendenti getListaRPTPendenti() {
        return listaRPTPendenti;
    }

    /**
     * Sets the value of the listaRPTPendenti property.
     * 
     * @param value
     *     allowed object is
     *     {@link TipoListaRPTPendenti }
     *     
     */
    public void setListaRPTPendenti(TipoListaRPTPendenti value) {
        this.listaRPTPendenti = value;
    }

}
