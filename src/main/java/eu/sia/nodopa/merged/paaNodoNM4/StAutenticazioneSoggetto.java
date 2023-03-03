
package eu.sia.nodopa.merged.paaNodoNM4;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for stAutenticazioneSoggetto.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <pre>
 * &lt;simpleType name="stAutenticazioneSoggetto"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;maxLength value="4"/&gt;
 *     &lt;enumeration value="CNS"/&gt;
 *     &lt;enumeration value="USR"/&gt;
 *     &lt;enumeration value="OTH"/&gt;
 *     &lt;enumeration value="N/A"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "stAutenticazioneSoggetto", namespace = "http://www.digitpa.gov.it/schemas/2011/Pagamenti/")
@XmlEnum
public enum StAutenticazioneSoggetto {

    CNS("CNS"),
    USR("USR"),
    OTH("OTH"),
    @XmlEnumValue("N/A")
    N_A("N/A");
    private final String value;

    StAutenticazioneSoggetto(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static StAutenticazioneSoggetto fromValue(String v) {
        for (StAutenticazioneSoggetto c: StAutenticazioneSoggetto.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
