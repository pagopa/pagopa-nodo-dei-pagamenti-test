
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per ctEntityUniqueIdentifier complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctEntityUniqueIdentifier"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="entityUniqueIdentifierType" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stEntityUniqueIdentifierType"/&gt;
 *         &lt;element name="entityUniqueIdentifierValue" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stEntityUniqueIdentifierValue"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctEntityUniqueIdentifier", propOrder = {
    "entityUniqueIdentifierType",
    "entityUniqueIdentifierValue"
})
public class CtEntityUniqueIdentifier {

    @XmlElement(required = true)
    @XmlSchemaType(name = "string")
    protected StEntityUniqueIdentifierType entityUniqueIdentifierType;
    @XmlElement(required = true)
    protected String entityUniqueIdentifierValue;

    /**
     * Recupera il valore della proprieta entityUniqueIdentifierType.
     * 
     * @return
     *     possible object is
     *     {@link StEntityUniqueIdentifierType }
     *     
     */
    public StEntityUniqueIdentifierType getEntityUniqueIdentifierType() {
        return entityUniqueIdentifierType;
    }

    /**
     * Imposta il valore della proprieta entityUniqueIdentifierType.
     * 
     * @param value
     *     allowed object is
     *     {@link StEntityUniqueIdentifierType }
     *     
     */
    public void setEntityUniqueIdentifierType(StEntityUniqueIdentifierType value) {
        this.entityUniqueIdentifierType = value;
    }

    /**
     * Recupera il valore della proprieta entityUniqueIdentifierValue.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEntityUniqueIdentifierValue() {
        return entityUniqueIdentifierValue;
    }

    /**
     * Imposta il valore della proprieta entityUniqueIdentifierValue.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEntityUniqueIdentifierValue(String value) {
        this.entityUniqueIdentifierValue = value;
    }

}
