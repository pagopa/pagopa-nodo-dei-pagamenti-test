
package nodo.gov.telematici.pagamenti.ws;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for esitoChiediStatoRPT complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="esitoChiediStatoRPT"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="stato" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="redirect" type="{http://www.w3.org/2001/XMLSchema}int" minOccurs="0"/&gt;
 *         &lt;element name="url" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="elementoStoricoRPT" type="{http://ws.pagamenti.telematici.gov/}tipoStoricoRPT" maxOccurs="unbounded" minOccurs="0"/&gt;
 *         &lt;element name="elementoStoricoVersamento" type="{http://ws.pagamenti.telematici.gov/}tipoStoricoVersamento" maxOccurs="unbounded" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "esitoChiediStatoRPT", propOrder = {
    "stato",
    "redirect",
    "url",
    "elementoStoricoRPT",
    "elementoStoricoVersamento"
})
public class EsitoChiediStatoRPT {

    @XmlElement(required = true)
    protected String stato;
    @XmlElement(defaultValue = "0")
    protected Integer redirect;
    @XmlElement(defaultValue = "")
    protected String url;
    @XmlElement(nillable = true)
    protected List<TipoStoricoRPT> elementoStoricoRPT;
    @XmlElement(nillable = true)
    protected List<TipoStoricoVersamento> elementoStoricoVersamento;

    /**
     * Gets the value of the stato property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStato() {
        return stato;
    }

    /**
     * Sets the value of the stato property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStato(String value) {
        this.stato = value;
    }

    /**
     * Gets the value of the redirect property.
     * 
     * @return
     *     possible object is
     *     {@link Integer }
     *     
     */
    public Integer getRedirect() {
        return redirect;
    }

    /**
     * Sets the value of the redirect property.
     * 
     * @param value
     *     allowed object is
     *     {@link Integer }
     *     
     */
    public void setRedirect(Integer value) {
        this.redirect = value;
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
     * Gets the value of the elementoStoricoRPT property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the elementoStoricoRPT property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getElementoStoricoRPT().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link TipoStoricoRPT }
     * 
     * 
     */
    public List<TipoStoricoRPT> getElementoStoricoRPT() {
        if (elementoStoricoRPT == null) {
            elementoStoricoRPT = new ArrayList<TipoStoricoRPT>();
        }
        return this.elementoStoricoRPT;
    }

    /**
     * Gets the value of the elementoStoricoVersamento property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the elementoStoricoVersamento property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getElementoStoricoVersamento().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link TipoStoricoVersamento }
     * 
     * 
     */
    public List<TipoStoricoVersamento> getElementoStoricoVersamento() {
        if (elementoStoricoVersamento == null) {
            elementoStoricoVersamento = new ArrayList<TipoStoricoVersamento>();
        }
        return this.elementoStoricoVersamento;
    }

}
