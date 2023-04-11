
package merged.pagopa.pagopa_api.pa.pafornode;

import java.math.BigDecimal;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per paaTipoDatiPagamentoPSP complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paaTipoDatiPagamentoPSP"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="importoSingoloVersamento" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stImporto"/&gt;
 *         &lt;element name="ibanAppoggio" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stIBANIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="bicAppoggio" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stBICIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="soggettoVersante" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctSoggettoVersante" minOccurs="0"/&gt;
 *         &lt;element name="ibanAddebito" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stIBANIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="bicAddebito" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stBICIdentifier" minOccurs="0"/&gt;
 *         &lt;element name="soggettoPagatore" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}ctSoggettoPagatore" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paaTipoDatiPagamentoPSP", namespace = "http://ws.pagamenti.telematici.gov/", propOrder = {
    "importoSingoloVersamento",
    "ibanAppoggio",
    "bicAppoggio",
    "soggettoVersante",
    "ibanAddebito",
    "bicAddebito",
    "soggettoPagatore"
})
public class PaaTipoDatiPagamentoPSP {

    @XmlElement(required = true)
    protected BigDecimal importoSingoloVersamento;
    protected String ibanAppoggio;
    protected String bicAppoggio;
    protected CtSoggettoVersante soggettoVersante;
    protected String ibanAddebito;
    protected String bicAddebito;
    protected CtSoggettoPagatore soggettoPagatore;

    /**
     * Recupera il valore della proprieta importoSingoloVersamento.
     * 
     * @return
     *     possible object is
     *     {@link BigDecimal }
     *     
     */
    public BigDecimal getImportoSingoloVersamento() {
        return importoSingoloVersamento;
    }

    /**
     * Imposta il valore della proprieta importoSingoloVersamento.
     * 
     * @param value
     *     allowed object is
     *     {@link BigDecimal }
     *     
     */
    public void setImportoSingoloVersamento(BigDecimal value) {
        this.importoSingoloVersamento = value;
    }

    /**
     * Recupera il valore della proprieta ibanAppoggio.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIbanAppoggio() {
        return ibanAppoggio;
    }

    /**
     * Imposta il valore della proprieta ibanAppoggio.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIbanAppoggio(String value) {
        this.ibanAppoggio = value;
    }

    /**
     * Recupera il valore della proprieta bicAppoggio.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBicAppoggio() {
        return bicAppoggio;
    }

    /**
     * Imposta il valore della proprieta bicAppoggio.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBicAppoggio(String value) {
        this.bicAppoggio = value;
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

}
