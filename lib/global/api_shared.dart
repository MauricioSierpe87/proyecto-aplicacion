const bool bCert = false;
const int hBackPort = 8000;

String Global_FormatURL(String szEndPoint, {int iPort = hBackPort})
{
    String szPort = (bCert) ? "https" : "http";
    String szUrl = "$szPort://localhost:$iPort$szEndPoint";

    return szUrl;
}