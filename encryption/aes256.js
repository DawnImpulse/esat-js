// Generated by CoffeeScript 2.2.3
(function() {
  /*
  ISC License

  Copyright 2018, Saksham (DawnImpulse)

  Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
  provided that the above copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
  INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE
  OR PERFORMANCE OF THIS SOFTWARE.
  */
  'use strict';
  /*
  esat
  aes256

  @author Saksham
  @note Last Branch Update - master

  @note Created on 2018-06-02 by Saksham
  @note Updates :
  */
  var crypto, decrypt, encrypt;

  crypto = require('crypto');

  /*
  ----- EXPORTS -----
  */
  /*
    Used to encrypt data with its key
    @param KEY - encryption key
    @param data - data to be encrypted
    @param callback - in case of promise kindly don't provide this
  */
  exports.encrypt = function(KEY, data, callback) {
    var encryptedData, error;
    if (callback) {
      try {
        encryptedData = encrypt(KEY, data);
        return callback(null, encryptedData);
      } catch (error1) {
        error = error1;
        return callback(error, null);
      }
    } else {
      return new Promise(function(resolve, reject) {
        try {
          encryptedData = encrypt(KEY, data);
          return resolve(encryptedData);
        } catch (error1) {
          error = error1;
          return reject(error);
        }
      });
    }
  };

  /*
    Used to decrypt data with its key
    @param KEY - encryption key
    @param data - data to be decrypted
    @param callback - in case of promise kindly don't provide this
  */
  exports.decrypt = function(KEY, data, callback) {
    var decryptedData, error;
    if (callback) {
      try {
        decryptedData = decrypt(KEY, data);
        return callback(null, decryptedData);
      } catch (error1) {
        error = error1;
        return callback(error, null);
      }
    } else {
      return new Promise(function(resolve, reject) {
        try {
          decryptedData = decrypt(KEY, data);
          return resolve(decryptedData);
        } catch (error1) {
          error = error1;
          return reject(error);
        }
      });
    }
  };

  /*
  ----- PRIVATE -----
  */
  // the encryption function
  encrypt = function(KEY, data) {
    var cipher, encrypted;
    cipher = crypto.createCipher('aes256', KEY);
    encrypted = cipher.update(data, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return encrypted;
  };

  // aes decryption function
  decrypt = function(KEY, data) {
    var decipher, decrypted;
    decipher = crypto.createDecipher('aes256', KEY);
    decrypted = decipher.update(data, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
  };

}).call(this);

//# sourceMappingURL=aes256.js.map
