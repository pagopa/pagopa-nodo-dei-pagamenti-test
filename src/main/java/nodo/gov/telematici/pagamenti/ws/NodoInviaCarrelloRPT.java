
package nodo.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for nodoInviaCarrelloRPT complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="nodoInviaCarrelloRPT"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="password" type="{http://ws.pagamenti.telematici.gov/}stPassword"/&gt;
 *         &lt;element name="identificativoPSP" type="{http://ws.pagamenti.telematici.gov/}stText35"/&gt;
 *         &lt;element name="identificativoIntermediarioPSP" type="{http://ws.pagamenti.telematici.gov/}stText35"/&gt;
 *         &lt;element name="identificativoCanale" type="{http://ws.pagamenti.telematici.gov/}stText35"/&gt;
 *         &lt;element name="listaRPT" type="{http://ws.pagamenti.telematici.gov/}tipoListaRPT"/&gt;
 *         &lt;element name="requireLightPayment" type="{http://ws.pagamenti.telematici.gov/}stZeroUno" minOccurs="0"/&gt;
 *         &lt;element name="codiceConvenzione" type="{http://ws.pagamenti.telematici.gov/}stConvenzione" minOccurs="0"/&gt;
 *         &lt;element name="multiBeneficiario" type="{http://www.w3.org/2001/XMLSchema}boolean" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "nodoInviaCarrelloRPT", propOrder = {
    "password",
    "identificativoPSP",
    "identificativoIntermediarioPSP",
    "identificativoCanale",
    "listaRPT",
    "requireLightPayment",
    "codiceConvenzione",
    "multiBeneficiario"
})
public class NodoInviaCarrelloRPT {

    @XmlElement(required = true)
    protected String password;
    @XmlElement(required = true)
    protected String identificativoPSP;
    @XmlElement(required = true)
    protected String identificativoIntermediarioPSP;
    @XmlElement(required = true)
    protected String identificativoCanale;
    @XmlElement(required = true)
    protected TipoListaRPT listaRPT;
    protected Integer requireLightPayment;
    protected String codiceConvenzione;
    protected Boolean multiBeneficiario;

    /**
     * Gets the value of the password property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPassword() {
        return password;
    }

    /**
     * Sets the value of the password property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPassword(String value) {
        this.password = value;
    }

    /**
     * Gets the value of the identificativoPSP property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoPSP() {
        return identificativoPSP;
    }

    /**
     * Sets the value of the identificativoPSP property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoPSP(String value) {
        this.identificativoPSP = value;
    }

    /**
     * Gets the value of the identificativoIntermediarioPSP property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoIntermediarioPSP() {
        return identificativoIntermediarioPSP;
    }

    /**
     * Sets the value of the identificativoIntermediarioPSP property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoIntermediarioPSP(String value) {
        this.identificativoIntermediarioPSP = value;
    }

    /**
     * Gets the value of the identificativoCanale property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoCanale() {
        return identificativoCanale;
    }

    /**
     * Sets the value of the identificativoCanale property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoCanale(String value) {
        this.identificativoCanale = value;
    }

    /**
     * Gets the value of the listaRPT property.
     * 
     * @return
     *     possible object is
     *     {@link TipoListaRPT }
     *     
     */
    public TipoListaRPT getListaRPT() {
        return listaRPT;
    }

    /**
     * Sets the value of the listaRPT property.
     * 
     * @param value
     *     allowed object is
     *     {@link TipoListaRPT }
     *     
     */
    public void setListaRPT(TipoListaRPT value) {
        this.listaRPT = value;
    }

    /**
     * Gets the value of the requireLightPayment property.
     * 
     * @return
     *     possible object is
     *     {@link Integer }
     *     
     */
    public Integer getRequireLightPayment() {
        return requireLightPayment;
    }

    /**
     * Sets the value of the requireLightPayment property.
     * 
     * @param value
     *     allowed object is
     *     {@link Integer }
     *     
     */
    public void setRequireLightPayment(Integer value) {
        this.requireLightPayment = value;
    }

    /**
     * Gets the value of the codiceConvenzione property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCodiceConvenzione() {
        return codiceConvenzione;
    }

    /**
     * Sets the value of the codiceConvenzione property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCodiceConvenzione(String value) {
        this.codiceConvenzione = value;
    }

    /**
     * Gets the value of the multiBeneficiario property.
     * 
     * @return
     *     possible object is
     *     {@link Boolean }
     *     
     */
    public Boolean isMultiBeneficiario() {
        return multiBeneficiario;
    }

    /**
     * Sets the value of the multiBeneficiario property.
     * 
     * @param value
     *     allowed object is
     *     {@link Boolean }
     *     
     */
    public void setMultiBeneficiario(Boolean value) {
        this.multiBeneficiario = value;
    }

}
