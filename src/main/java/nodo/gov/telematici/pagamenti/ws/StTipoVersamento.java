
package nodo.gov.telematici.pagamenti.ws;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for stTipoVersamento.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <pre>
 * &lt;simpleType name="stTipoVersamento"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;enumeration value="BBT"/&gt;
 *     &lt;enumeration value="BP"/&gt;
 *     &lt;enumeration value="AD"/&gt;
 *     &lt;enumeration value="CP"/&gt;
 *     &lt;enumeration value="PO"/&gt;
 *     &lt;enumeration value="OBEP"/&gt;
 *     &lt;maxLength value="4"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stTipoVersamento")
@XmlEnum
public enum StTipoVersamento {

    BBT,
    BP,
    AD,
    CP,
    PO,
    OBEP;

    public String value() {
        return name();
    }

    public static StTipoVersamento fromValue(String v) {
        return valueOf(v);
    }

}
