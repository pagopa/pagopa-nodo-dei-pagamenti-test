
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Classe Java per ctRicevutaTelematica complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctRicevutaTelematica"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="versioneOggetto" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText16"/&gt;
 *         &lt;element name="dominio" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctDominio"/&gt;
 *         &lt;element name="identificativoMessaggioRicevuta" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="dataOraMessaggioRicevuta" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stISODateTime"/&gt;
 *         &lt;element name="riferimentoMessaggioRichiesta" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="riferimentoDataRichiesta" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stISODate"/&gt;
 *         &lt;element name="istitutoAttestante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctIstitutoAttestante"/&gt;
 *         &lt;element name="enteBeneficiario" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctEnteBeneficiario"/&gt;
 *         &lt;element name="soggettoVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctSoggettoVersante" minOccurs="0"/&gt;
 *         &lt;element name="soggettoPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctSoggettoPagatore"/&gt;
 *         &lt;element name="datiPagamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctDatiVersamentoRT"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctRicevutaTelematica", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "versioneOggetto",
    "dominio",
    "identificativoMessaggioRicevuta",
    "dataOraMessaggioRicevuta",
    "riferimentoMessaggioRichiesta",
    "riferimentoDataRichiesta",
    "istitutoAttestante",
    "enteBeneficiario",
    "soggettoVersante",
    "soggettoPagatore",
    "datiPagamento"
})
public class CtRicevutaTelematica {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String versioneOggetto;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtDominio dominio;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String identificativoMessaggioRicevuta;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar dataOraMessaggioRicevuta;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String riferimentoMessaggioRichiesta;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    @XmlSchemaType(name = "date")
    protected XMLGregorianCalendar riferimentoDataRichiesta;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtIstitutoAttestante istitutoAttestante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtEnteBeneficiario enteBeneficiario;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected CtSoggettoVersante soggettoVersante;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtSoggettoPagatore soggettoPagatore;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected CtDatiVersamentoRT datiPagamento;

    /**
     * Recupera il valore della proprieta versioneOggetto.
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
     * Imposta il valore della proprieta versioneOggetto.
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
     * Recupera il valore della proprieta dominio.
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
     * Imposta il valore della proprieta dominio.
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
     * Recupera il valore della proprieta identificativoMessaggioRicevuta.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoMessaggioRicevuta() {
        return identificativoMessaggioRicevuta;
    }

    /**
     * Imposta il valore della proprieta identificativoMessaggioRicevuta.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoMessaggioRicevuta(String value) {
        this.identificativoMessaggioRicevuta = value;
    }

    /**
     * Recupera il valore della proprieta dataOraMessaggioRicevuta.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getDataOraMessaggioRicevuta() {
        return dataOraMessaggioRicevuta;
    }

    /**
     * Imposta il valore della proprieta dataOraMessaggioRicevuta.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setDataOraMessaggioRicevuta(XMLGregorianCalendar value) {
        this.dataOraMessaggioRicevuta = value;
    }

    /**
     * Recupera il valore della proprieta riferimentoMessaggioRichiesta.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRiferimentoMessaggioRichiesta() {
        return riferimentoMessaggioRichiesta;
    }

    /**
     * Imposta il valore della proprieta riferimentoMessaggioRichiesta.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRiferimentoMessaggioRichiesta(String value) {
        this.riferimentoMessaggioRichiesta = value;
    }

    /**
     * Recupera il valore della proprieta riferimentoDataRichiesta.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getRiferimentoDataRichiesta() {
        return riferimentoDataRichiesta;
    }

    /**
     * Imposta il valore della proprieta riferimentoDataRichiesta.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setRiferimentoDataRichiesta(XMLGregorianCalendar value) {
        this.riferimentoDataRichiesta = value;
    }

    /**
     * Recupera il valore della proprieta istitutoAttestante.
     * 
     * @return
     *     possible object is
     *     {@link CtIstitutoAttestante }
     *     
     */
    public CtIstitutoAttestante getIstitutoAttestante() {
        return istitutoAttestante;
    }

    /**
     * Imposta il valore della proprieta istitutoAttestante.
     * 
     * @param value
     *     allowed object is
     *     {@link CtIstitutoAttestante }
     *     
     */
    public void setIstitutoAttestante(CtIstitutoAttestante value) {
        this.istitutoAttestante = value;
    }

    /**
     * Recupera il valore della proprieta enteBeneficiario.
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
     * Imposta il valore della proprieta enteBeneficiario.
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
     * Recupera il valore della proprieta soggettoVersante.
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
     * Imposta il valore della proprieta soggettoVersante.
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
     * Recupera il valore della proprieta soggettoPagatore.
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
     * Imposta il valore della proprieta soggettoPagatore.
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
     * Recupera il valore della proprieta datiPagamento.
     * 
     * @return
     *     possible object is
     *     {@link CtDatiVersamentoRT }
     *     
     */
    public CtDatiVersamentoRT getDatiPagamento() {
        return datiPagamento;
    }

    /**
     * Imposta il valore della proprieta datiPagamento.
     * 
     * @param value
     *     allowed object is
     *     {@link CtDatiVersamentoRT }
     *     
     */
    public void setDatiPagamento(CtDatiVersamentoRT value) {
        this.datiPagamento = value;
    }

}
