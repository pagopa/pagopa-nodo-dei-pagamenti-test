
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ctSoggettoPagatore complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ctSoggettoPagatore"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="identificativoUnivocoPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctIdentificativoUnivocoPersonaFG"/&gt;
 *         &lt;element name="anagraficaPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText70"/&gt;
 *         &lt;element name="indirizzoPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText70" minOccurs="0"/&gt;
 *         &lt;element name="civicoPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText16" minOccurs="0"/&gt;
 *         &lt;element name="capPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText16" minOccurs="0"/&gt;
 *         &lt;element name="localitaPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="provinciaPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="nazionePagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stNazioneProvincia" minOccurs="0"/&gt;
 *         &lt;element name="e-mailPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stEMail" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctSoggettoPagatore", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "identificativoUnivocoPagatore",
    "anagraficaPagatore",
    "indirizzoPagatore",
    "civicoPagatore",
    "capPagatore",
    "localitaPagatore",
    "provinciaPagatore",
    "nazionePagatore",
    "eMailPagatore"
})
public class CtSoggettoPagatore {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtIdentificativoUnivocoPersonaFG identificativoUnivocoPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String anagraficaPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String indirizzoPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String civicoPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String capPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String localitaPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String provinciaPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String nazionePagatore;
    @XmlElement(name = "e-mailPagatore", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String eMailPagatore;

    /**
     * Gets the value of the identificativoUnivocoPagatore property.
     * 
     * @return
     *     possible object is
     *     {@link CtIdentificativoUnivocoPersonaFG }
     *     
     */
    public CtIdentificativoUnivocoPersonaFG getIdentificativoUnivocoPagatore() {
        return identificativoUnivocoPagatore;
    }

    /**
     * Sets the value of the identificativoUnivocoPagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtIdentificativoUnivocoPersonaFG }
     *     
     */
    public void setIdentificativoUnivocoPagatore(CtIdentificativoUnivocoPersonaFG value) {
        this.identificativoUnivocoPagatore = value;
    }

    /**
     * Gets the value of the anagraficaPagatore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAnagraficaPagatore() {
        return anagraficaPagatore;
    }

    /**
     * Sets the value of the anagraficaPagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAnagraficaPagatore(String value) {
        this.anagraficaPagatore = value;
    }

    /**
     * Gets the value of the indirizzoPagatore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIndirizzoPagatore() {
        return indirizzoPagatore;
    }

    /**
     * Sets the value of the indirizzoPagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIndirizzoPagatore(String value) {
        this.indirizzoPagatore = value;
    }

    /**
     * Gets the value of the civicoPagatore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCivicoPagatore() {
        return civicoPagatore;
    }

    /**
     * Sets the value of the civicoPagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCivicoPagatore(String value) {
        this.civicoPagatore = value;
    }

    /**
     * Gets the value of the capPagatore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCapPagatore() {
        return capPagatore;
    }

    /**
     * Sets the value of the capPagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCapPagatore(String value) {
        this.capPagatore = value;
    }

    /**
     * Gets the value of the localitaPagatore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLocalitaPagatore() {
        return localitaPagatore;
    }

    /**
     * Sets the value of the localitaPagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLocalitaPagatore(String value) {
        this.localitaPagatore = value;
    }

    /**
     * Gets the value of the provinciaPagatore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getProvinciaPagatore() {
        return provinciaPagatore;
    }

    /**
     * Sets the value of the provinciaPagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setProvinciaPagatore(String value) {
        this.provinciaPagatore = value;
    }

    /**
     * Gets the value of the nazionePagatore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNazionePagatore() {
        return nazionePagatore;
    }

    /**
     * Sets the value of the nazionePagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNazionePagatore(String value) {
        this.nazionePagatore = value;
    }

    /**
     * Gets the value of the eMailPagatore property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEMailPagatore() {
        return eMailPagatore;
    }

    /**
     * Sets the value of the eMailPagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEMailPagatore(String value) {
        this.eMailPagatore = value;
    }

}
