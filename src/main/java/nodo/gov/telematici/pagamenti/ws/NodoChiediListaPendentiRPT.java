
package nodo.gov.telematici.pagamenti.ws;

import java.math.BigInteger;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Java class for nodoChiediListaPendentiRPT complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="nodoChiediListaPendentiRPT"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="identificativoIntermediarioPA" type="{http://ws.pagamenti.telematici.gov/}stText35"/&gt;
 *         &lt;element name="identificativoStazioneIntermediarioPA" type="{http://ws.pagamenti.telematici.gov/}stText35"/&gt;
 *         &lt;element name="password" type="{http://ws.pagamenti.telematici.gov/}stPassword"/&gt;
 *         &lt;element name="identificativoDominio" type="{http://ws.pagamenti.telematici.gov/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="rangeDa" type="{http://www.w3.org/2001/XMLSchema}dateTime" minOccurs="0"/&gt;
 *         &lt;element name="rangeA" type="{http://www.w3.org/2001/XMLSchema}dateTime" minOccurs="0"/&gt;
 *         &lt;element name="dimensioneLista" type="{http://www.w3.org/2001/XMLSchema}positiveInteger"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "nodoChiediListaPendentiRPT", propOrder = {
    "identificativoIntermediarioPA",
    "identificativoStazioneIntermediarioPA",
    "password",
    "identificativoDominio",
    "rangeDa",
    "rangeA",
    "dimensioneLista"
})
public class NodoChiediListaPendentiRPT {

    @XmlElement(required = true)
    protected String identificativoIntermediarioPA;
    @XmlElement(required = true)
    protected String identificativoStazioneIntermediarioPA;
    @XmlElement(required = true)
    protected String password;
    protected String identificativoDominio;
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar rangeDa;
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar rangeA;
    @XmlElement(required = true)
    @XmlSchemaType(name = "positiveInteger")
    protected BigInteger dimensioneLista;

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
     * Gets the value of the rangeDa property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getRangeDa() {
        return rangeDa;
    }

    /**
     * Sets the value of the rangeDa property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setRangeDa(XMLGregorianCalendar value) {
        this.rangeDa = value;
    }

    /**
     * Gets the value of the rangeA property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getRangeA() {
        return rangeA;
    }

    /**
     * Sets the value of the rangeA property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setRangeA(XMLGregorianCalendar value) {
        this.rangeA = value;
    }

    /**
     * Gets the value of the dimensioneLista property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getDimensioneLista() {
        return dimensioneLista;
    }

    /**
     * Sets the value of the dimensioneLista property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setDimensioneLista(BigInteger value) {
        this.dimensioneLista = value;
    }

}
