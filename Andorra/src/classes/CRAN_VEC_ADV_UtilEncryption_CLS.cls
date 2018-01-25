/**
 * Esta clase proporciona funcionalidades de encriptación
 *
 * Fecha: 19/11/2016
 * @author  Cloud Coachers (Iñaki Hernando Urcullu - inakihu@gmail.com)
 * Edit encryptWithManagedIV for DataPower Services
 * @version 1.1
 *
*/

public with sharing class CRAN_VEC_ADV_UtilEncryption_CLS {

    
    /*--------------------------*/
    /*     VARIABLES PRIVADAS   */
    /*--------------------------*/
    
	CRAN_VEC_ADV_AvaloqSettings__c cs;
	Blob privateKey;
    String algorithmName;

	/*--------------------------*/
    /*     CONSTRUCTORES        */
    /*--------------------------*/
    
    public CRAN_VEC_ADV_UtilEncryption_CLS() {
        cs = CRAN_VEC_ADV_AvaloqSettings__c.getInstance();
        privateKey = Blob.valueOf(cs.CRAN_VEC_ADV_T_PrivateKey__c);
        algorithmName = cs.CRAN_VEC_ADV_T_AlgorithmName__c;
    }


    /*--------------------------*/
    /*     MÉTODOS PUBLICOS     */
    /*--------------------------*/
    

    /**
    * Encriptación de un String pasado por parametro usando IV managed.
    *
    * Edicion Julian Gonzalez (Vector ITC)
    *
    * @param stringToEncrypt - String de lo que se quiere encriptar.
    * 
    * @return resultado encriptado.
    */

     public String encryptManaged(String stringToEncrypt){
        System.debug('------ encryptManaged -----');
        System.debug('algorithmName: ' + algorithmName);
        System.debug('key: ' + EncodingUtil.base64Encode(privateKey));
        System.debug('stringToEncrypt: ' + stringToEncrypt);
        System.debug('------                -----');
        Blob encryptedBody = Crypto.encryptWithManagedIV(algorithmName, privateKey, Blob.valueOf(stringToEncrypt));
        System.debug('base64Encode Blob ' + EncodingUtil.base64Encode(encryptedBody));
        return EncodingUtil.base64Encode(encryptedBody);
    }

    /**
    * Desencriptacion de un String pasado por parametro usando IV managed.
    *
    * Edicion Julian Gonzalez (Vector ITC)
    *
    * @param stringToDecrypt - String de lo que se quiere desencriptar.
    * 
    * @return resultado String desencriptado.
    */

     public String decryptManaged(String stringToDecrypt){
        System.debug('------ decryptManaged -----');
        System.debug('algorithmName: ' + algorithmName);
        System.debug('key: ' + EncodingUtil.base64Encode(privateKey));
        System.debug('stringToDecrypt: ' + stringToDecrypt);
        System.debug('------                -----');
        Blob decryptedBody = Crypto.decryptWithManagedIV(algorithmName, privateKey, EncodingUtil.base64Decode(stringToDecrypt));
        //System.debug('base64Decoded Blob ' + EncodingUtil.base64Encode(decryptedBody));
        System.debug('decodedString: ' + decryptedBody.toString());
        return decryptedBody.toString();
    }

}