###
ISC License

Copyright 2018, Saksham (DawnImpulse)

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE
OR PERFORMANCE OF THIS SOFTWARE.
###

'use strict'
###
esat
aes256

@author Saksham
@note Last Branch Update - master

@note Created on 2018-06-02 by Saksham
@note Updates :
###
crypto = require 'crypto'

###
----- EXPORTS -----
###

###
  Used to encrypt data with its key
  @param KEY - encryption key
  @param data - data to be encrypted
  @param callback - in case of promise kindly don't provide this
###
exports.encrypt = (data, key, callback) ->
  if(callback)
    encryptedData = encrypt(key, data)
    callback(null, encryptedData)
  else
    return new Promise((resolve, _)->
      encryptedData = encrypt(key, data)
      resolve(encryptedData)
    )

###
  Used to decrypt data with its key
  @param KEY - encryption key
  @param data - data to be decrypted
  @param callback - in case of promise kindly don't provide this
###
exports.decrypt = (data, key, callback) ->
  if(callback)
    try
      decryptedData = decrypt(key, data)
      callback(null, decryptedData)
    catch error
      callback(error, null)
  else
    return new Promise((resolve, reject)->
      try
        decryptedData = decrypt(key, data)
        resolve(decryptedData)
      catch error
        reject(error)
    )

###
----- PRIVATE -----
###

# the encryption function
encrypt = (KEY, data) ->
  cipher = crypto.createCipher('aes256', KEY)
  encrypted = cipher.update(data, 'utf8', 'hex')
  encrypted += cipher.final('hex')
  encrypted

# aes decryption function
decrypt = (KEY, data) ->
  decipher = crypto.createDecipher('aes256', KEY)
  decrypted = decipher.update(data, 'hex', 'utf8')
  decrypted += decipher.final('utf8')
  decrypted

