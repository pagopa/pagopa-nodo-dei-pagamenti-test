
package nodo.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for nodoInviaRichiestaStorno complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="nodoInviaRichiestaStorno"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="identificativoIntermediarioPA" type="{http://ws.pagamenti.telematici.gov/}stText35"/&gt;
 *         &lt;element name="identificativoStazioneIntermediarioPA" type="{http://ws.pagamenti.telematici.gov/}stText35"/&gt;
 *         &lt;element name="password" type="{http://ws.pagamenti.telematici.gov/}stPassword"/&gt;
 *         &lt;element name="identificativoDominio" type="{http://ws.pagamenti.telematici.gov/}stText35"/&gt;
 *         &lt;element name="identificativoUnivocoVersamento" type="{http://ws.pagamenti.telematici.gov/}stText35"/&gt;
 *         &lt;element name="codiceContestoPagamento" type="{http://ws.pagamenti.telematici.gov/}stText35"/&gt;
 *         &lt;element name="rr" type="{http://www.w3.org/2001/XMLSchema}base64Binary"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "nodoInviaRichiestaStorno", propOrder = {
    "identificativoIntermediarioPA",
    "identificativoStazioneIntermediarioPA",
    "password",
    "identificativoDominio",
    "identificativoUnivocoVersamento",
    "codiceContestoPagamento",
    "rr"
})
public class NodoInviaRichiestaStorno {

    @XmlElement(required = true)
    protected String identificativoIntermediarioPA;
    @XmlElement(required = true)
    protected String identificativoStazioneIntermediarioPA;
    @XmlElement(required = true)
    protected String password;
    @XmlElement(required = true)
    protected String identificativoDominio;
    @XmlElement(required = true)
    protected String identificativoUnivocoVersamento;
    @XmlElement(required = true)
    protected String codiceContestoPagamento;
    @XmlElement(required = true)
    protected byte[] rr;

    /**
     * Gets the value of the identificativoIntermediarioPA property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoIntermediarioPA() {
        return identificativoIntermediarioPA;
    }

    /**
     * Sets the value of the identificativoIntermediarioPA property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoIntermediarioPA(String value) {
        this.identificativoIntermediarioPA = value;
    }

    /**
     * Gets the value of the identificativoStazioneIntermediarioPA property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoStazioneIntermediarioPA() {
        return identificativoStazioneIntermediarioPA;
    }

    /**
     * Sets the value of the identificativoStazioneIntermediarioPA property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoStazioneIntermediarioPA(String value) {
        this.identificativoStazioneIntermediarioPA = value;
    }

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
     * Gets the value of the identificativoDominio property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoDominio() {
        return identificativoDominio;
    }

    /**
     * Sets the value of the identificativoDominio property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoDominio(String value) {
        this.identificativoDominio = value;
    }

    /**
     * Gets the value of the identificativoUnivocoVersamento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoUnivocoVersamento() {
        return identificativoUnivocoVersamento;
    }

    /**
     * Sets the value of the identificativoUnivocoVersamento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoUnivocoVersamento(String value) {
        this.identificativoUnivocoVersamento = value;
    }

    /**
     * Gets the value of the codiceContestoPagamento property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCodiceContestoPagamento() {
        return codiceContestoPagamento;
    }

    /**
     * Sets the value of the codiceContestoPagamento property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCodiceContestoPagamento(String value) {
        this.codiceContestoPagamento = value;
    }

    /**
     * Gets the value of the rr property.
     * 
     * @return
     *     possible object is
     *     byte[]
     */
    public byte[] getRr() {
        return rr;
    }

    /**
     * Sets the value of the rr property.
     * 
     * @param value
     *     allowed object is
     *     byte[]
     */
    public void setRr(byte[] value) {
        this.rr = value;
    }

}
