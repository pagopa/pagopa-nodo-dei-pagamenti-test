
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Java class for ctRichiestaPagamentoTelematico complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="ctRichiestaPagamentoTelematico"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="versioneOggetto" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText16"/&gt;
 *         &lt;element name="dominio" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctDominio"/&gt;
 *         &lt;element name="identificativoMessaggioRichiesta" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="dataOraMessaggioRichiesta" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stISODateTime"/&gt;
 *         &lt;element name="autenticazioneSoggetto" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stAutenticazioneSoggetto"/&gt;
 *         &lt;element name="soggettoVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctSoggettoVersante" minOccurs="0"/&gt;
 *         &lt;element name="soggettoPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctSoggettoPagatore"/&gt;
 *         &lt;element name="enteBeneficiario" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctEnteBeneficiario"/&gt;
 *         &lt;element name="datiVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctDatiVersamentoRPT"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctRichiestaPagamentoTelematico", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "versioneOggetto",
    "dominio",
    "identificativoMessaggioRichiesta",
    "dataOraMessaggioRichiesta",
    "autenticazioneSoggetto",
    "soggettoVersante",
    "soggettoPagatore",
    "enteBeneficiario",
    "datiVersamento"
})
public class CtRichiestaPagamentoTelematico {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String versioneOggetto;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtDominio dominio;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String identificativoMessaggioRichiesta;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar dataOraMessaggioRichiesta;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    @XmlSchemaType(name = "string")
    protected StAutenticazioneSoggetto autenticazioneSoggetto;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected CtSoggettoVersante soggettoVersante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtSoggettoPagatore soggettoPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtEnteBeneficiario enteBeneficiario;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtDatiVersamentoRPT datiVersamento;

    /**
     * Gets the value of the versioneOggetto property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getVersioneOggetto() {
        return versioneOggetto;
    }

    /**
     * Sets the value of the versioneOggetto property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setVersioneOggetto(String value) {
        this.versioneOggetto = value;
    }

    /**
     * Gets the value of the dominio property.
     * 
     * @return
     *     possible object is
     *     {@link CtDominio }
     *     
     */
    public CtDominio getDominio() {
        return dominio;
    }

    /**
     * Sets the value of the dominio property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtDominio }
     *     
     */
    public void setDominio(CtDominio value) {
        this.dominio = value;
    }

    /**
     * Gets the value of the identificativoMessaggioRichiesta property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoMessaggioRichiesta() {
        return identificativoMessaggioRichiesta;
    }

    /**
     * Sets the value of the identificativoMessaggioRichiesta property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoMessaggioRichiesta(String value) {
        this.identificativoMessaggioRichiesta = value;
    }

    /**
     * Gets the value of the dataOraMessaggioRichiesta property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getDataOraMessaggioRichiesta() {
        return dataOraMessaggioRichiesta;
    }

    /**
     * Sets the value of the dataOraMessaggioRichiesta property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setDataOraMessaggioRichiesta(XMLGregorianCalendar value) {
        this.dataOraMessaggioRichiesta = value;
    }

    /**
     * Gets the value of the autenticazioneSoggetto property.
     * 
     * @return
     *     possible object is
     *     {@link StAutenticazioneSoggetto }
     *     
     */
    public StAutenticazioneSoggetto getAutenticazioneSoggetto() {
        return autenticazioneSoggetto;
    }

    /**
     * Sets the value of the autenticazioneSoggetto property.
     * 
     * @param value
     *     allowed object is
     *     {@link StAutenticazioneSoggetto }
     *     
     */
    public void setAutenticazioneSoggetto(StAutenticazioneSoggetto value) {
        this.autenticazioneSoggetto = value;
    }

    /**
     * Gets the value of the soggettoVersante property.
     * 
     * @return
     *     possible object is
     *     {@link CtSoggettoVersante }
     *     
     */
    public CtSoggettoVersante getSoggettoVersante() {
        return soggettoVersante;
    }

    /**
     * Sets the value of the soggettoVersante property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtSoggettoVersante }
     *     
     */
    public void setSoggettoVersante(CtSoggettoVersante value) {
        this.soggettoVersante = value;
    }

    /**
     * Gets the value of the soggettoPagatore property.
     * 
     * @return
     *     possible object is
     *     {@link CtSoggettoPagatore }
     *     
     */
    public CtSoggettoPagatore getSoggettoPagatore() {
        return soggettoPagatore;
    }

    /**
     * Sets the value of the soggettoPagatore property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtSoggettoPagatore }
     *     
     */
    public void setSoggettoPagatore(CtSoggettoPagatore value) {
        this.soggettoPagatore = value;
    }

    /**
     * Gets the value of the enteBeneficiario property.
     * 
     * @return
     *     possible object is
     *     {@link CtEnteBeneficiario }
     *     
     */
    public CtEnteBeneficiario getEnteBeneficiario() {
        return enteBeneficiario;
    }

    /**
     * Sets the value of the enteBeneficiario property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtEnteBeneficiario }
     *     
     */
    public void setEnteBeneficiario(CtEnteBeneficiario value) {
        this.enteBeneficiario = value;
    }

    /**
     * Gets the value of the datiVersamento property.
     * 
     * @return
     *     possible object is
     *     {@link CtDatiVersamentoRPT }
     *     
     */
    public CtDatiVersamentoRPT getDatiVersamento() {
        return datiVersamento;
    }

    /**
     * Sets the value of the datiVersamento property.
     * 
     * @param value
     *     allowed object is
     *     {@link CtDatiVersamentoRPT }
     *     
     */
    public void setDatiVersamento(CtDatiVersamentoRPT value) {
        this.datiVersamento = value;
    }

}
