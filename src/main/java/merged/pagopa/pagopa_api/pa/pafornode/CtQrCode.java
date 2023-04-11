
package merged.pagopa.pagopa_api.pa.pafornode;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

/**
 * <p>
 * Classe Java per ctQrCode complex type.
 * 
 * <p>
 * Il seguente frammento di schema specifica il contenuto previsto contenuto in
 * questa classe.
 * 
 * <pre>
 * &lt;complexType name="ctQrCode"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="fiscalCode" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stFiscalCodePA"/&gt;
 *         &lt;element name="noticeNumber" type="{http://pagopa-api.pagopa.gov.it/xsd/common-types/v1.0.0/}stNoticeNumber"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ctQrCode", propOrder = { "fiscalCode", "noticeNumber" })
public class CtQrCode {

	@XmlElement(required = true)
	protected String fiscalCode;
	@XmlElement(required = true)
	protected String noticeNumber;

	/**
	 * Recupera il valore della proprieta fiscalCode.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getFiscalCode() {
		return fiscalCode;
	}

	/**
	 * Imposta il valore della proprieta fiscalCode.
	 * 
	 * @param value allowed object is {@link String }
	 * 
	 */
	public void setFiscalCode(String value) {
		this.fiscalCode = value;
	}

	/**
	 * Recupera il valore della proprieta noticeNumber.
	 * 
	 * @return possible object is {@link String }
	 * 
	 */
	public String getNoticeNumber() {
		return noticeNumber;
	}

	/**
	 * Imposta il valore della proprieta noticeNumber.
	 * 
	 * @param value allowed object is {@link String }
	 * 
	 */
	public void setNoticeNumber(String value) {
		this.noticeNumber = value;
	}

}
