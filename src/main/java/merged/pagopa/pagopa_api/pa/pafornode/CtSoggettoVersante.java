
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctSoggettoVersante complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctSoggettoVersante"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="identificativoUnivocoVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctIdentificativoUnivocoPersonaFG"/&gt;
 *         &lt;element name="anagraficaVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText70"/&gt;
 *         &lt;element name="indirizzoVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText70" minOccurs="0"/&gt;
 *         &lt;element name="civicoVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText16" minOccurs="0"/&gt;
 *         &lt;element name="capVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText16" minOccurs="0"/&gt;
 *         &lt;element name="localitaVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="provinciaVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="nazioneVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stNazioneProvincia" minOccurs="0"/&gt;
 *         &lt;element name="e-mailVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stEMail" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctSoggettoVersante", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "identificativoUnivocoVersante",
    "anagraficaVersante",
    "indirizzoVersante",
    "civicoVersante",
    "capVersante",
    "localitaVersante",
    "provinciaVersante",
    "nazioneVersante",
    "eMailVersante"
})
public class CtSoggettoVersante {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtIdentificativoUnivocoPersonaFG identificativoUnivocoVersante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String anagraficaVersante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String indirizzoVersante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String civicoVersante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String capVersante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String localitaVersante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String provinciaVersante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String nazioneVersante;
    @XmlElement(name = "e-mailVersante", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String eMailVersante;

    /**
     * Recupera il valore della proprieta identificativoUnivocoVersante.
     * 
     * @return
     *     possible object is
     *     {@link CtIdentificativoUnivocoPersonaFG }
     *     
     */
    public CtIdentificativoUnivocoPersonaFG getIdentificativoUnivocoVersante() {
        return identificativoUnivocoVersante;
    }

    /**
     * Imposta il valore della proprieta identificativoUnivocoVersante.
     * 
     * @param value
     *     allowed object is
     *     {@link CtIdentificativoUnivocoPersonaFG }
     *     
     */
    public void setIdentificativoUnivocoVersante(CtIdentificativoUnivocoPersonaFG value) {
        this.identificativoUnivocoVersante = value;
    }

    /**
     * Recupera il valore della proprieta anagraficaVersante.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAnagraficaVersante() {
        return anagraficaVersante;
    }

    /**
     * Imposta il valore della proprieta anagraficaVersante.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAnagraficaVersante(String value) {
        this.anagraficaVersante = value;
    }

    /**
     * Recupera il valore della proprieta indirizzoVersante.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIndirizzoVersante() {
        return indirizzoVersante;
    }

    /**
     * Imposta il valore della proprieta indirizzoVersante.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIndirizzoVersante(String value) {
        this.indirizzoVersante = value;
    }

    /**
     * Recupera il valore della proprieta civicoVersante.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCivicoVersante() {
        return civicoVersante;
    }

    /**
     * Imposta il valore della proprieta civicoVersante.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCivicoVersante(String value) {
        this.civicoVersante = value;
    }

    /**
     * Recupera il valore della proprieta capVersante.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCapVersante() {
        return capVersante;
    }

    /**
     * Imposta il valore della proprieta capVersante.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCapVersante(String value) {
        this.capVersante = value;
    }

    /**
     * Recupera il valore della proprieta localitaVersante.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLocalitaVersante() {
        return localitaVersante;
    }

    /**
     * Imposta il valore della proprieta localitaVersante.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLocalitaVersante(String value) {
        this.localitaVersante = value;
    }

    /**
     * Recupera il valore della proprieta provinciaVersante.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getProvinciaVersante() {
        return provinciaVersante;
    }

    /**
     * Imposta il valore della proprieta provinciaVersante.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setProvinciaVersante(String value) {
        this.provinciaVersante = value;
    }

    /**
     * Recupera il valore della proprieta nazioneVersante.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNazioneVersante() {
        return nazioneVersante;
    }

    /**
     * Imposta il valore della proprieta nazioneVersante.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNazioneVersante(String value) {
        this.nazioneVersante = value;
    }

    /**
     * Recupera il valore della proprieta eMailVersante.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEMailVersante() {
        return eMailVersante;
    }

    /**
     * Imposta il valore della proprieta eMailVersante.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEMailVersante(String value) {
        this.eMailVersante = value;
    }

}
