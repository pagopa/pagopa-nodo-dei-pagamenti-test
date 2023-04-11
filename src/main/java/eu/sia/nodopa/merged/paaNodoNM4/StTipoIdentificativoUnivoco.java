
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for stTipoIdentificativoUnivoco.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <pre>
 * &lt;simpleType name="stTipoIdentificativoUnivoco"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;enumeration value="G"/&gt;
 *     &lt;enumeration value="A"/&gt;
 *     &lt;enumeration value="B"/&gt;
 *     &lt;length value="1"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stTipoIdentificativoUnivoco", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
@XmlEnum
public enum StTipoIdentificativoUnivoco {

    G,
    A,
    B;

    public String value() {
        return name();
    }

    public static StTipoIdentificativoUnivoco fromValue(String v) {
        return valueOf(v);
    }

}
