 set define off
 CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED "TestLogin"
AS
import java.io.*;
import java.util.Base64;
import org.bouncycastle.cert.jcajce.JcaCertStore;
import org.bouncycastle.cms.*;
import org.bouncycastle.cms.jcajce.JcaSignerInfoGeneratorBuilder;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.operator.ContentSigner;
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder;
import org.bouncycastle.operator.jcajce.JcaDigestCalculatorProviderBuilder;
import org.bouncycastle.util.Store;
import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;
import javax.xml.rpc.ParameterMode;

import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.Security;
import java.security.cert.CertStore;
import java.security.cert.CollectionCertStoreParameters;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.TimeZone;
import org.apache.axis.client.Call;
import org.apache.axis.client.Service;

  public class TestLogin {
  
      public static String csmxml()
               {

           String ln = "";




        String endpoint = "xx";
        String service = xx
        String dstDN = "xx";
        String p12file = "xx";
        String signer = "xx";
        String p12pass = "xx";


        PrivateKey pKey = null;
        X509Certificate pCertificate = null;
        byte[] asn1_cms = null;
        CertStore cstore = null;
        String LoginTicketRequest_xml;
        String SignerDN = null;

        //
        // Manage Keys & Certificates
        //
        try {
            //ClassLoader loader = TestLogin.class.getClassLoader();
            //InputStream inst = loader.getResourceAsStream(p12file);
            File myFile = new File (p12file);
            FileInputStream p12stream = new FileInputStream(myFile);

            // Create a keystore using keys from the pkcs#12 p12file
            KeyStore ks = KeyStore.getInstance("PKCS12");
            ks.load(p12stream, p12pass.toCharArray());
            p12stream.close();

            // Get Certificate & Private key from KeyStore
            pKey = (PrivateKey) ks.getKey(signer, p12pass.toCharArray());

            pCertificate = (X509Certificate) ks.getCertificate(signer);


            if (Security.getProvider("BC") == null) {
                Security.addProvider(new BouncyCastleProvider());
            }

        } catch (Exception e) {
            ln = "paso 1 :" + e.getMessage();
        }




        int year = 2024;
        int month = 5;
        int day = 25;
        int hour = 12;
        int minute = 0;
        int second = 0;

        int yearexp = 2024;
        int monthexp = 5;
        int dayexp = 25;
        int hourexp = 12;
        int minuteexp = 0;
        int secondexp = 0;

        GregorianCalendar gentime = new GregorianCalendar(year, month, day, hour, minute, second);
        gentime.setTimeZone(TimeZone.getTimeZone("America/Argentina/Buenos_Aires"));

        GregorianCalendar exptime = new GregorianCalendar(yearexp, monthexp, dayexp, hourexp, minuteexp, secondexp);
        exptime.setTimeZone(TimeZone.getTimeZone("America/Argentina/Buenos_Aires"));

        String UniqueId = String. valueOf(gentime.getTime().getTime() / 1000);

        XMLGregorianCalendar XMLGenTime = null;
        try {
            XMLGenTime = DatatypeFactory.newInstance()
                    .newXMLGregorianCalendar(gentime);
        } catch (DatatypeConfigurationException e) {
            ln = e.getMessage();
        } 


        XMLGregorianCalendar XMLExpTime = null;
        try {
            XMLExpTime = DatatypeFactory.newInstance()
                    .newXMLGregorianCalendar(exptime);
        } catch (DatatypeConfigurationException e) {
            ln = e.getMessage();
        } 


        LoginTicketRequest_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
                + "<loginTicketRequest version=\"1.0\">" + "<header>" + "<source>" + SignerDN + "</source>"
                + "<destination>" + dstDN + "</destination>" + "<uniqueId>" + UniqueId + "</uniqueId>"
                + "<generationTime>" + XMLGenTime + "</generationTime>" + "<expirationTime>" + XMLExpTime
                + "</expirationTime>" + "</header>" + "<service>" + service + "</service>" + "</loginTicketRequest>";

//        System.out.println(LoginTicketRequest_xml);
            ln = LoginTicketRequest_xml;


      // crea cms
        try {
            // Create a new empty CMS Message
            CMSSignedDataGenerator gen = new CMSSignedDataGenerator();

            List<X509Certificate> certList = new ArrayList<X509Certificate>();
            certList.add(pCertificate);

            Store certStore = new JcaCertStore(certList);
            ContentSigner sha1Signer = new JcaContentSignerBuilder("SHA1withRSA").setProvider("BC").build(pKey);
            gen.addSignerInfoGenerator(
                    new JcaSignerInfoGeneratorBuilder(
                            new JcaDigestCalculatorProviderBuilder().setProvider("BC").build())
                            .build(sha1Signer, pCertificate));

            gen.addCertificates(certStore);

            CMSTypedData data2 = new CMSProcessableByteArray(LoginTicketRequest_xml.getBytes("UTF-8"));

            CMSSignedData sigData = gen.generate(data2, true);
            asn1_cms = sigData.getEncoded();

        } catch (Exception e) {
            ln = "paso 3 :" + e.getMessage();
        }

       byte[] encoded = Base64.getEncoder().encode(asn1_cms);
       return (new String(encoded));

      }
  };