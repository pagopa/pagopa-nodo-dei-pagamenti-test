
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


/**
 * <p>Classe Java per ctDatiVersamentoRPT complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctDatiVersamentoRPT"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="dataEsecuzionePagamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stISODate"/&gt;
 *         &lt;element name="importoTotaleDaVersare" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImportoDiversoDaZero"/&gt;
 *         &lt;element name="tipoVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stTipoVersamento"/&gt;
 *         &lt;element name="identificativoUnivocoVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="codiceContestoPagamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stText35"/&gt;
 *         &lt;element name="ibanAddebito" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stIBANIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="bicAddebito" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stBICIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="firmaRicevuta" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stFirmaRicevuta"/&gt;
 *         &lt;element name="datiSingoloVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctDatiSingoloVersamentoRPT" maxOccurs="5"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctDatiVersamentoRPT", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "dataEsecuzionePagamento",
    "importoTotaleDaVersare",
    "tipoVersamento",
    "identificativoUnivocoVersamento",
    "codiceContestoPagamento",
    "ibanAddebito",
    "bicAddebito",
    "firmaRicevuta",
    "datiSingoloVersamento"
})
public class CtDatiVersamentoRPT {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    @XmlSchemaType(name = "date")
    protected XMLGregorianCalendar dataEsecuzionePagamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected BigDecimal importoTotaleDaVersare;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    @XmlSchemaType(name = "string")
    protected StTipoVersamento tipoVersamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String identificativoUnivocoVersamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String codiceContestoPagamento;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String ibanAddebito;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
    protected String bicAddebito;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String firmaRicevuta;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected List<CtDatiSingoloVersamentoRPT> datiSingoloVersamento;

    /**
     * Recupera il valore della proprieta dataEsecuzionePagamento.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getDataEsecuzionePagamento() {
        return dataEsecuzionePagamento;
    }

    /**
     * Imposta il valore della proprieta dataEsecuzionePagamento.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setDataEsecuzionePagamento(XMLGregorianCalendar value) {
        this.dataEsecuzionePagamento = value;
    }

    /**
     * Recupera il valore della proprieta importoTotaleDaVersare.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getImportoTotaleDaVersare() {
        return importoTotaleDaVersare;
    }

    /**
     * Imposta il valore della proprieta importoTotaleDaVersare.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setImportoTotaleDaVersare(BigDecimal value) {
        this.importoTotaleDaVersare = value;
    }

    /**
     * Recupera il valore della proprieta tipoVersamento.
     * 
     * @return
     *     possible object is
     *     {@link StTipoVersamento }
     *     
     */
    public StTipoVersamento getTipoVersamento() {
        return tipoVersamento;
    }

    /**
     * Imposta il valore della proprieta tipoVersamento.
     * 
     * @param value
     *     allowed object is
     *     {@link StTipoVersamento }
     *     
     */
    public void setTipoVersamento(StTipoVersamento value) {
        this.tipoVersamento = value;
    }

    /**
     * Recupera il valore della proprieta identificativoUnivocoVersamento.
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
     * Imposta il valore della proprieta identificativoUnivocoVersamento.
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
     * Recupera il valore della proprieta codiceContestoPagamento.
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
     * Imposta il valore della proprieta codiceContestoPagamento.
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
     * Recupera il valore della proprieta ibanAddebito.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIbanAddebito() {
        return ibanAddebito;
    }

    /**
     * Imposta il valore della proprieta ibanAddebito.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIbanAddebito(String value) {
        this.ibanAddebito = value;
    }

    /**
     * Recupera il valore della proprieta bicAddebito.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBicAddebito() {
        return bicAddebito;
    }

    /**
     * Imposta il valore della proprieta bicAddebito.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBicAddebito(String value) {
        this.bicAddebito = value;
    }

    /**
     * Recupera il valore della proprieta firmaRicevuta.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFirmaRicevuta() {
        return firmaRicevuta;
    }

    /**
     * Imposta il valore della proprieta firmaRicevuta.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFirmaRicevuta(String value) {
        this.firmaRicevuta = value;
    }

    /**
     * Gets the value of the datiSingoloVersamento property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the datiSingoloVersamento property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getDatiSingoloVersamento().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link CtDatiSingoloVersamentoRPT }
     * 
     * 
     */
    public List<CtDatiSingoloVersamentoRPT> getDatiSingoloVersamento() {
        if (datiSingoloVersamento == null) {
            datiSingoloVersamento = new ArrayList<CtDatiSingoloVersamentoRPT>();
        }
        return this.datiSingoloVersamento;
    }

}
