
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctIdentificativoUnivocoPersonaFG complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctIdentificativoUnivocoPersonaFG"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="tipoIdentificativoUnivoco" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stTipoIdentificativoUnivocoPersFG"/&gt;
 *         &lt;element name="codiceIdentificativoUnivoco" type="{http://www.digitpa.gov.it/schemas/2011/Pagamenti/}stCodiceIdentificativoUnivoco"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctIdentificativoUnivocoPersonaFG", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", propOrder = {
    "tipoIdentificativoUnivoco",
    "codiceIdentificativoUnivoco"
})
public class CtIdentificativoUnivocoPersonaFG {

    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    @XmlSchemaType(name = "string")
    protected StTipoIdentificativoUnivocoPersFG tipoIdentificativoUnivoco;
    @XmlElement(namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/", required = true)
    protected String codiceIdentificativoUnivoco;

    /**
     * Recupera il valore della proprieta tipoIdentificativoUnivoco.
     * 
     * @return
     *     possible object is
     *     {@link StTipoIdentificativoUnivocoPersFG }
     *     
     */
    public StTipoIdentificativoUnivocoPersFG getTipoIdentificativoUnivoco() {
        return tipoIdentificativoUnivoco;
    }

    /**
     * Imposta il valore della proprieta tipoIdentificativoUnivoco.
     * 
     * @param value
     *     allowed object is
     *     {@link StTipoIdentificativoUnivocoPersFG }
     *     
     */
    public void setTipoIdentificativoUnivoco(StTipoIdentificativoUnivocoPersFG value) {
        this.tipoIdentificativoUnivoco = value;
    }

    /**
     * Recupera il valore della proprieta codiceIdentificativoUnivoco.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCodiceIdentificativoUnivoco() {
        return codiceIdentificativoUnivoco;
    }

    /**
     * Imposta il valore della proprieta codiceIdentificativoUnivoco.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCodiceIdentificativoUnivoco(String value) {
        this.codiceIdentificativoUnivoco = value;
    }

}
