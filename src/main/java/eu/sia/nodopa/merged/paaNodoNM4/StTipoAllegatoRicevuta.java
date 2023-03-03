
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for stTipoAllegatoRicevuta.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <pre>
 * &lt;simpleType name="stTipoAllegatoRicevuta"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;enumeration value="ES"/&gt;
 *     &lt;enumeration value="BD"/&gt;
 *     &lt;length value="2"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stTipoAllegatoRicevuta", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
@XmlEnum
public enum StTipoAllegatoRicevuta {

    ES,
    BD;

    public String value() {
        return name();
    }

    public static StTipoAllegatoRicevuta fromValue(String v) {
        return valueOf(v);
    }

}
