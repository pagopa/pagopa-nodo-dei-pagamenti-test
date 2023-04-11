
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlType;


/**
 * 
 * Its a response to 'paSendRTReq' and contains :
 * 
 * - 'outcome' and _optional_ 'fault' (_see below to details_)
 * 
 *       
 * 
 * <p>Java class for paSendRTRes complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="paSendRTRes"&gt;
 *   &lt;complexContent&gt;
 *     &lt;extension base="{http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd}ctResponse"&gt;
 *     &lt;/extension&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "paSendRTRes")
public class PaSendRTRes
    extends CtResponse
{


}
