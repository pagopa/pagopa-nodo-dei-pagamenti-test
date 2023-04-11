
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for ctIstitutoAttestante complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ctIstitutoAttestante"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="identificativoUnivocoAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctIdentificativoUnivoco"/&gt;
 *         &lt;element name="denominazioneAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText70"/&gt;
 *         &lt;element name="codiceUnitOperAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="denomUnitOperAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText70" minOccurs="0"/&gt;
 *         &lt;element name="indirizzoAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText70" minOccurs="0"/&gt;
 *         &lt;element name="civicoAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText16" minOccurs="0"/&gt;
 *         &lt;element name="capAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText16" minOccurs="0"/&gt;
 *         &lt;element name="localitaAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="provinciaAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="nazioneAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stNazioneProvincia" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctIstitutoAttestante", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "identificativoUnivocoAttestante",
    "denominazioneAttestante",
    "codiceUnitOperAttestante",
    "denomUnitOperAttestante",
    "indirizzoAttestante",
    "civicoAttestante",
    "capAttestante",
    "localitaAttestante",
    "provinciaAttestante",
    "nazioneAttestante"
})
public class CtIstitutoAttestante {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtIdentificativoUnivoco identificativoUnivocoAttestante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String denominazioneAttestante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String codiceUnitOperAttestante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String denomUnitOperAttestante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String indirizzoAttestante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String civicoAttestante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String capAttestante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String localitaAttestante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String provinciaAttestante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String nazioneAttestante;

    /**
     * Gets the value of the identificativoUnivocoAttestante property.
     * 
     * @return
     *     possible object is
     *     {@link CtIdentificativoUnivoco }
     *     
     */
    public CtIdentificativoUnivoco getIdentificativoUnivocoAttestante() {
        return identificativoUnivocoAttestante;
    }

    /**
     * Sets the value of the identificativoUnivocoAttestante property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtIdentificativoUnivoco }
     *     
     */
    public void setIdentificativoUnivocoAttestante(CtIdentificativoUnivoco value) {
        this.identificativoUnivocoAttestante = value;
    }

    /**
     * Gets the value of the denominazioneAttestante property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDenominazioneAttestante() {
        return denominazioneAttestante;
    }

    /**
     * Sets the value of the denominazioneAttestante property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDenominazioneAttestante(String value) {
        this.denominazioneAttestante = value;
    }

    /**
     * Gets the value of the codiceUnitOperAttestante property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCodiceUnitOperAttestante() {
        return codiceUnitOperAttestante;
    }

    /**
     * Sets the value of the codiceUnitOperAttestante property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCodiceUnitOperAttestante(String value) {
        this.codiceUnitOperAttestante = value;
    }

    /**
     * Gets the value of the denomUnitOperAttestante property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDenomUnitOperAttestante() {
        return denomUnitOperAttestante;
    }

    /**
     * Sets the value of the denomUnitOperAttestante property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDenomUnitOperAttestante(String value) {
        this.denomUnitOperAttestante = value;
    }

    /**
     * Gets the value of the indirizzoAttestante property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIndirizzoAttestante() {
        return indirizzoAttestante;
    }

    /**
     * Sets the value of the indirizzoAttestante property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIndirizzoAttestante(String value) {
        this.indirizzoAttestante = value;
    }

    /**
     * Gets the value of the civicoAttestante property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCivicoAttestante() {
        return civicoAttestante;
    }

    /**
     * Sets the value of the civicoAttestante property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCivicoAttestante(String value) {
        this.civicoAttestante = value;
    }

    /**
     * Gets the value of the capAttestante property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCapAttestante() {
        return capAttestante;
    }

    /**
     * Sets the value of the capAttestante property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCapAttestante(String value) {
        this.capAttestante = value;
    }

    /**
     * Gets the value of the localitaAttestante property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLocalitaAttestante() {
        return localitaAttestante;
    }

    /**
     * Sets the value of the localitaAttestante property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLocalitaAttestante(String value) {
        this.localitaAttestante = value;
    }

    /**
     * Gets the value of the provinciaAttestante property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getProvinciaAttestante() {
        return provinciaAttestante;
    }

    /**
     * Sets the value of the provinciaAttestante property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setProvinciaAttestante(String value) {
        this.provinciaAttestante = value;
    }

    /**
     * Gets the value of the nazioneAttestante property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNazioneAttestante() {
        return nazioneAttestante;
    }

    /**
     * Sets the value of the nazioneAttestante property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNazioneAttestante(String value) {
        this.nazioneAttestante = value;
    }

}
