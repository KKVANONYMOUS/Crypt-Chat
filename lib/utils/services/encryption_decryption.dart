import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionDecryption{
  static final key=encrypt.Key.fromLength(32);
  static final iv=encrypt.IV.fromLength(16);
  static final encrypter=encrypt.Encrypter(encrypt.AES(key));

  static encryptMessage(String plainMessageText){
    final encrypted=encrypter.encrypt(plainMessageText,iv: iv);
    return encrypted.base64;
  }
  static decryptMessage(encryptedMessageText){
    return encrypter.decrypt(encryptedMessageText,iv:iv);
  }
}