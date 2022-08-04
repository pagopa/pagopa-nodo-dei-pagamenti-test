
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * 
 * Contains all data for the subject of payment :
 * 
 * - `uniqueIdentifier` : (_see below to details_)
 * - `fullName` : name of the subject
 * - `streetName` : street name
 * - `civicNumber` : building number
 * - `postalCode` : postal code
 * - `city` : town name
 * - `stateProvinceRegion` : country subdivision
 * - `country` : country name
 * - `e-mail` : remittance location electronic address
 * 
 *      
 * 
 * <p>Classe Java per ctSubject complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctSubject"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="uniqueIdentifier" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctEntityUniqueIdentifier"/&gt;
 *         &lt;element name="fullName" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText70"/&gt;
 *         &lt;element name="streetName" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText70" minOccurs="0"/&gt;
 *         &lt;element name="civicNumber" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText16" minOccurs="0"/&gt;
 *         &lt;element name="postalCode" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText16" minOccurs="0"/&gt;
 *         &lt;element name="city" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35" minOccurs="0"/&gt;
 *         &lt;element name="stateProvinceRegion" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stText35" minOccurs="0"/&gt;
 *         &lt;element name="country" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stNazioneProvincia" minOccurs="0"/&gt;
 *         &lt;element name="e-mail" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}stEMail" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctSubject", propOrder = {
    "uniqueIdentifier",
    "fullName",
    "streetName",
    "civicNumber",
    "postalCode",
    "city",
    "stateProvinceRegion",
    "country",
    "eMail"
})
public class CtSubject {

    @XmlElement(required = true)
    protected CtEntityUniqueIdentifier uniqueIdentifier;
    @XmlElement(required = true)
    protected String fullName;
    protected String streetName;
    protected String civicNumber;
    protected String postalCode;
    protected String city;
    protected String stateProvinceRegion;
    protected String country;
    @XmlElement(name = "e-mail")
    protected String eMail;

    /**
     * Recupera il valore della proprietà uniqueIdentifier.
     * 
     * @return
     *     possible object is
     *     {@link CtEntityUniqueIdentifier }
     *     
     */
    public CtEntityUniqueIdentifier getUniqueIdentifier() {
        return uniqueIdentifier;
    }

    /**
     * Imposta il valore della proprietà uniqueIdentifier.
     * 
     * @param value
     *     allowed object is
     *     {@link CtEntityUniqueIdentifier }
     *     
     */
    public void setUniqueIdentifier(CtEntityUniqueIdentifier value) {
        this.uniqueIdentifier = value;
    }

    /**
     * Recupera il valore della proprietà fullName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFullName() {
        return fullName;
    }

    /**
     * Imposta il valore della proprietà fullName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFullName(String value) {
        this.fullName = value;
    }

    /**
     * Recupera il valore della proprietà streetName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStreetName() {
        return streetName;
    }

    /**
     * Imposta il valore della proprietà streetName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStreetName(String value) {
        this.streetName = value;
    }

    /**
     * Recupera il valore della proprietà civicNumber.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCivicNumber() {
        return civicNumber;
    }

    /**
     * Imposta il valore della proprietà civicNumber.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCivicNumber(String value) {
        this.civicNumber = value;
    }

    /**
     * Recupera il valore della proprietà postalCode.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPostalCode() {
        return postalCode;
    }

    /**
     * Imposta il valore della proprietà postalCode.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPostalCode(String value) {
        this.postalCode = value;
    }

    /**
     * Recupera il valore della proprietà city.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCity() {
        return city;
    }

    /**
     * Imposta il valore della proprietà city.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCity(String value) {
        this.city = value;
    }

    /**
     * Recupera il valore della proprietà stateProvinceRegion.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStateProvinceRegion() {
        return stateProvinceRegion;
    }

    /**
     * Imposta il valore della proprietà stateProvinceRegion.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStateProvinceRegion(String value) {
        this.stateProvinceRegion = value;
    }

    /**
     * Recupera il valore della proprietà country.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCountry() {
        return country;
    }

    /**
     * Imposta il valore della proprietà country.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCountry(String value) {
        this.country = value;
    }

    /**
     * Recupera il valore della proprietà eMail.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getEMail() {
        return eMail;
    }

    /**
     * Imposta il valore della proprietà eMail.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setEMail(String value) {
        this.eMail = value;
    }

}
