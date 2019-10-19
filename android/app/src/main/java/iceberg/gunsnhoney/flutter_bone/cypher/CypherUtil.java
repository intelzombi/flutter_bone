package iceberg.gunsnhoney.flutter_bone.cypher;

import android.util.Log;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.InvalidParameterSpecException;
import java.security.spec.KeySpec;
import java.util.concurrent.atomic.AtomicReference;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * Created by hsmith on 8/16/2017.
 * Yes it's spelled incorrectly.  That is on purpose
 */

public class CypherUtil {
    private static SecretKey secret;
    private static final int iterationCount = 0x1962;
    private static final int saltLength = 32; // 256/8   AES 256
    private static final int keyLength = 256; // AES
    private static byte[] initializationVector;
    private static byte[] salt;
    private static AtomicReference<byte[]> saltRef;
    private static AtomicReference<byte[]> ivRef;
    private static byte[] saveSalt = {-88, -85, -20, 73, -101, -10, -87, -26, -118, -67, 121, 24, 91, 95, 78, -101, -122, 27, 42, -66, 35, -46, 60, -63, -128, -26, 12, -38, -81, 74, -73, 82};
    private static byte[] saveIVector = { -71, 107 , 46 , -113 , -90 , 51 , -97 , -53 , 61 , -11 , 91 , -97 , -76 , -34 , 114, -121};

    public static byte[] generateInitializationVector() {
        Cipher cipher = null;
        byte[] iv;
        try {
            cipher = Cipher.getInstance("AES/CBC/PKCS7PADDING");
            iv = generateInitializationVector(cipher.getBlockSize());
        } catch (NoSuchAlgorithmException nsae) {
            iv = new byte[]{40};
        } catch (NoSuchPaddingException nspe) {
            iv = new byte[]{40};
        }
        return iv;
    }

    public static byte[] generateInitializationVector(int blockSize) {
        SecureRandom random = new SecureRandom();
        initializationVector = new byte[blockSize];
        random.nextBytes(initializationVector);
        return initializationVector;
    }

    public static byte[] retrieveInitializationVector(String ivName, int blockSize) {
        if(ivRef == null) {
            ivRef = new AtomicReference<>(generateInitializationVector(blockSize));
        }
        return ivRef.get();
    }

    public static byte[] generateSalt() {
        salt = new byte[saltLength];
        SecureRandom random = new SecureRandom();
        random.nextBytes(salt);
        return salt;
    }

    public static byte[] retrieveSalt(String saltName) {
        if(saltRef==null) {
            saltRef = new AtomicReference<>(generateSalt());
        }
        return saltRef.get();
    }



    public static SecretKey generateKey(String password,  byte[] salt) throws NoSuchAlgorithmException, InvalidKeyException, InvalidKeySpecException
    {

        KeySpec keySpec = new PBEKeySpec(password.toCharArray(), salt, iterationCount, keyLength);
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        byte [] keyBytes = keyFactory.generateSecret(keySpec).getEncoded();
        secret = new SecretKeySpec(keyBytes, "AES");
        return secret;
    }

    public static byte[] encryptMsg(String password, String clearMessage, byte[] salt, byte[] pepper) {
        try {
            secret = CypherUtil.generateKey(password, salt);
            return CypherUtil.encryptMsg(password, clearMessage, secret, pepper);
        } catch (NoSuchAlgorithmException nsae) {
            return new byte[]{0x40};
        } catch (InvalidKeyException ike) {
            return new byte[]{0x40};
        } catch (InvalidKeySpecException ise) {
            return new byte[]{0x40};
        }
    }

    public static byte[] encryptMsg(String password, String clearMessage, SecretKey secret, byte[] pepper) {
        byte [] encryptedWalletPWBytes;
        try {

            encryptedWalletPWBytes = CypherUtil.encryptMsg(clearMessage, secret, pepper, true);

        } catch (NoSuchAlgorithmException nsae) {
            Log.d("CypherDecrpt", nsae.getMessage());
            return new byte[]{0x40};

        } catch(NoSuchPaddingException nspe) {
            Log.d("CypherDecrpt", nspe.getMessage());
            return new byte[]{0x40};

        } catch (InvalidAlgorithmParameterException iape) {
            Log.d("CypherDecrpt", iape.getMessage());
            return new byte[]{0x40};

        } catch (InvalidKeyException ike) {
            Log.d("CypherDecrpt", ike.getMessage());
            return new byte[]{0x40};

        } catch (InvalidParameterSpecException ipse) {
            Log.d("CypherDecrpt", ipse.getMessage());
            return new byte[]{0x40};

        } catch (IllegalBlockSizeException ibse) {
            Log.d("CypherDecrpt", ibse.getMessage());
            return new byte[]{0x40};

        } catch (BadPaddingException bpe) {
            Log.d("CypherDecrpt", bpe.getMessage());
            return new byte[]{0x40};

        } catch (UnsupportedEncodingException uee) {
            Log.d("CypherDecrpt", uee.getMessage());
            return new byte[]{0x40};

        }

        return encryptedWalletPWBytes;
    }
    /*
        https://android-developers.googleblog.com/2016/06/security-crypto-provider-deprecated-in.html
        https://nelenkov.blogspot.com/2012/04/using-password-based-encryption-on.html
     */
    public static byte[] encryptMsg(String message, SecretKey secret, byte[] pepper, boolean isEncrypt) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, InvalidKeyException, InvalidParameterSpecException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException
    {
        /* Encrypt the message */
        SecureRandom random = new SecureRandom();
        Cipher cipher = null;
        cipher = Cipher.getInstance("AES/CBC/PKCS7PADDING");
        IvParameterSpec ivParams = new IvParameterSpec(pepper);
        cipher.init(isEncrypt? Cipher.ENCRYPT_MODE: Cipher.DECRYPT_MODE,secret,ivParams);
        return cipher.doFinal(message.getBytes(StandardCharsets.UTF_8));
    }

    public static String decryptMsg(byte[] encryptedMsg, String password, byte[] salt, byte[] pepper) {
        String decryptedWalletPWBytes;
        try {
            secret = CypherUtil.generateKey(password, salt);
            decryptedWalletPWBytes = CypherUtil.decryptMsg( encryptedMsg, secret, pepper );
        }catch (Exception e) {
            e.printStackTrace();
            return "uh uh uh you didn't say the magic word";
        }
        return decryptedWalletPWBytes;
    }

    public static String decryptMsg(byte[] cipherText, SecretKey secret, byte[] pepper) throws NoSuchPaddingException, NoSuchAlgorithmException,  InvalidAlgorithmParameterException, InvalidKeyException,  BadPaddingException, IllegalBlockSizeException, UnsupportedEncodingException
    {
        /* decrypt the message */
        Cipher cipher = null;
        cipher = Cipher.getInstance("AES/CBC/PKCS7PADDING");
        IvParameterSpec ivParams = new IvParameterSpec(pepper);
        cipher.init(Cipher.DECRYPT_MODE, secret, ivParams);

        return new String(cipher.doFinal(cipherText),"UTF-8");
    }

}
