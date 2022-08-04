package eu.sia.nft;

public class RptModel {
	final String dominio, intPa, stazPa, ccp, iuv;

	public RptModel(String in) {
		dominio = in.split(",")[0];
		intPa = in.split(",")[1];
		stazPa = in.split(",")[2];
		ccp = in.split(",")[3];
		iuv = in.split(",")[4];
	}

	public String getDominio() {
		return dominio;
	}

	public String getIntPa() {
		return intPa;
	}

	public String getStazPa() {
		return stazPa;
	}

	public String getCcp() {
		return ccp;
	}

	public String getIuv() {
		return iuv;
	}
	
	
}
