
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java per paVerifyPaymentNoticeRes complex type.
 * 
 * <p>Il seguente frammento di schema specifica il contenuto previsto contenuto in questa classe.
 * 
 * <pre>
 * &lt;complexType name="paVerifyPaymentNoticeRes"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}ctResponse"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="paymentList" type="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctPaymentOptionsDescriptionListPA" minOccurs="0"/&gt;
 *         &lt;element name="paymentDescription" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText140" minOccurs="0"/&gt;
 *         &lt;element name="fiscalCodePA" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stFiscalCodePA" minOccurs="0"/&gt;
 *         &lt;element name="companyName" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText140" minOccurs="0"/&gt;
 *         &lt;element name="officeName" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stText140" minOccurs="0"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paVerifyPaymentNoticeRes", propOrder = {
    "paymentList",
    "paymentDescription",
    "fiscalCodePA",
    "companyName",
    "officeName"
})
public class PaVerifyPaymentNoticeRes
    extends CtResponse
{

    protected CtPaymentOptionsDescriptionListPA paymentList;
    protected String paymentDescription;
    protected String fiscalCodePA;
    protected String companyName;
    protected String officeName;

    /**
     * Recupera il valore della proprieta paymentList.
     * 
     * @return
     *     possible object is
     *     {@link CtPaymentOptionsDescriptionListPA }
     *     
     */
    public CtPaymentOptionsDescriptionListPA getPaymentList() {
        return paymentList;
    }

    /**
     * Imposta il valore della proprieta paymentList.
     * 
     * @param value
     *     allowed object is
     *     {@link CtPaymentOptionsDescriptionListPA }
     *     
     */
    public void setPaymentList(CtPaymentOptionsDescriptionListPA value) {
        this.paymentList = value;
    }

    /**
     * Recupera il valore della proprieta paymentDescription.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPaymentDescription() {
        return paymentDescription;
    }

    /**
     * Imposta il valore della proprieta paymentDescription.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPaymentDescription(String value) {
        this.paymentDescription = value;
    }

    /**
     * Recupera il valore della proprieta fiscalCodePA.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getFiscalCodePA() {
        return fiscalCodePA;
    }

    /**
     * Imposta il valore della proprieta fiscalCodePA.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setFiscalCodePA(String value) {
        this.fiscalCodePA = value;
    }

    /**
     * Recupera il valore della proprieta companyName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCompanyName() {
        return companyName;
    }

    /**
     * Imposta il valore della proprieta companyName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCompanyName(String value) {
        this.companyName = value;
    }

    /**
     * Recupera il valore della proprieta officeName.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getOfficeName() {
        return officeName;
    }

    /**
     * Imposta il valore della proprieta officeName.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setOfficeName(String value) {
        this.officeName = value;
    }

}
