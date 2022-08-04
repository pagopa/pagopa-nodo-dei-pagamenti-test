
package nodo.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for stEffettuazioneScelta.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <pre>
 * &lt;simpleType name="stEffettuazioneScelta"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;enumeration value="SI"/&gt;
 *     &lt;enumeration value="NO"/&gt;
 *     &lt;enumeration value="PO"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stEffettuazioneScelta")
@XmlEnum
public enum StEffettuazioneScelta {

    SI,
    NO,
    PO;

    public String value() {
        return name();
    }

    public static StEffettuazioneScelta fromValue(String v) {
        return valueOf(v);
    }

}
