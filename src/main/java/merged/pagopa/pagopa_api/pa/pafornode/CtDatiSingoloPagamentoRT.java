
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Classe Java per ctDatiSingoloPagamentoRT complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctDatiSingoloPagamentoRT"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="singoloImportoPagato" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImporto"/&gt;
 *         &lt;element name="esitoSingoloPagamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35" minOccurs="0"/&gt;
 *         &lt;element name="dataEsitoSingoloPagamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stISODate"/&gt;
 *         &lt;element name="identificativoUnivocoRiscossione" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="causaleVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText140"/&gt;
 *         &lt;element name="datiSpecificiRiscossione" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stDatiSpecificiRiscossione"/&gt;
 *         &lt;element name="commissioniApplicatePSP" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImporto" minOccurs="0"/&gt;
 *         &lt;element name="commissioniApplicatePA" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImportoDiversoDaZero" minOccurs="0"/&gt;
 *         &lt;element name="allegatoRicevuta" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctAllegatoRicevuta" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctDatiSingoloPagamentoRT", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "singoloImportoPagato",
    "esitoSingoloPagamento",
    "dataEsitoSingoloPagamento",
    "identificativoUnivocoRiscossione",
    "causaleVersamento",
    "datiSpecificiRiscossione",
    "commissioniApplicatePSP",
    "commissioniApplicatePA",
    "allegatoRicevuta"
})
public class CtDatiSingoloPagamentoRT {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected BigDecimal singoloImportoPagato;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String esitoSingoloPagamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    @XmlSchemaType(name = "date")
    protected XMLGregorianCalendar dataEsitoSingoloPagamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String identificativoUnivocoRiscossione;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String causaleVersamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String datiSpecificiRiscossione;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected BigDecimal commissioniApplicatePSP;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected BigDecimal commissioniApplicatePA;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected CtAllegatoRicevuta allegatoRicevuta;

    /**
     * Recupera il valore della proprieta singoloImportoPagato.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getSingoloImportoPagato() {
        return singoloImportoPagato;
    }

    /**
     * Imposta il valore della proprieta singoloImportoPagato.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setSingoloImportoPagato(BigDecimal value) {
        this.singoloImportoPagato = value;
    }

    /**
     * Recupera il valore della proprieta esitoSingoloPagamento.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEsitoSingoloPagamento() {
        return esitoSingoloPagamento;
    }

    /**
     * Imposta il valore della proprieta esitoSingoloPagamento.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEsitoSingoloPagamento(String value) {
        this.esitoSingoloPagamento = value;
    }

    /**
     * Recupera il valore della proprieta dataEsitoSingoloPagamento.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getDataEsitoSingoloPagamento() {
        return dataEsitoSingoloPagamento;
    }

    /**
     * Imposta il valore della proprieta dataEsitoSingoloPagamento.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setDataEsitoSingoloPagamento(XMLGregorianCalendar value) {
        this.dataEsitoSingoloPagamento = value;
    }

    /**
     * Recupera il valore della proprieta identificativoUnivocoRiscossione.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIdentificativoUnivocoRiscossione() {
        return identificativoUnivocoRiscossione;
    }

    /**
     * Imposta il valore della proprieta identificativoUnivocoRiscossione.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIdentificativoUnivocoRiscossione(String value) {
        this.identificativoUnivocoRiscossione = value;
    }

    /**
     * Recupera il valore della proprieta causaleVersamento.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCausaleVersamento() {
        return causaleVersamento;
    }

    /**
     * Imposta il valore della proprieta causaleVersamento.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCausaleVersamento(String value) {
        this.causaleVersamento = value;
    }

    /**
     * Recupera il valore della proprieta datiSpecificiRiscossione.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDatiSpecificiRiscossione() {
        return datiSpecificiRiscossione;
    }

    /**
     * Imposta il valore della proprieta datiSpecificiRiscossione.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDatiSpecificiRiscossione(String value) {
        this.datiSpecificiRiscossione = value;
    }

    /**
     * Recupera il valore della proprieta commissioniApplicatePSP.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getCommissioniApplicatePSP() {
        return commissioniApplicatePSP;
    }

    /**
     * Imposta il valore della proprieta commissioniApplicatePSP.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setCommissioniApplicatePSP(BigDecimal value) {
        this.commissioniApplicatePSP = value;
    }

    /**
     * Recupera il valore della proprieta commissioniApplicatePA.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getCommissioniApplicatePA() {
        return commissioniApplicatePA;
    }

    /**
     * Imposta il valore della proprieta commissioniApplicatePA.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setCommissioniApplicatePA(BigDecimal value) {
        this.commissioniApplicatePA = value;
    }

    /**
     * Recupera il valore della proprieta allegatoRicevuta.
     * 
     * @return
     *     possible object is
     *     {@link CtAllegatoRicevuta }
     *     
     */
    public CtAllegatoRicevuta getAllegatoRicevuta() {
        return allegatoRicevuta;
    }

    /**
     * Imposta il valore della proprieta allegatoRicevuta.
     * 
     * @param value
     *     allowed object is
     *     {@link CtAllegatoRicevuta }
     *     
     */
    public void setAllegatoRicevuta(CtAllegatoRicevuta value) {
        this.allegatoRicevuta = value;
    }

}
