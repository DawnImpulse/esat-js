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
  Saksham - 2018 06 05 - master - minor fix in key/data
  Saksham - 2019 07 15 - master - changed deprecated encryption method
###
crypto = require 'crypto'
handler = require '../utils/errorHandler'
utils = require '../utils/utilities'

IV_LENGTH = 16

###
----- EXPORTS -----
###

###
  Used to encrypt data with its key
  @param KEY - encryption key (must be 256 bits , 32 chars)
  @param data - data to be encrypted
  @param callback - in case of promise kindly don't provide this
###
exports.encrypt = (data, key, callback) ->
  if(callback)
    encryptedData = encrypt(data, key)

    # if not an error
    if(utils.typeOf(encryptedData) == 'string')
      callback(undefined, encryptedData)
    else
# here data is the error
      callback(encryptedData, undefined)
  else
    return new Promise((resolve, reject)->
      encryptedData = encrypt(data, key)

      # if not an error
      if(utils.typeOf(encryptedData) == 'string')
        resolve(encryptedData)
      else
# here data is the error
        reject(encryptedData)
    )

###
  Used to decrypt data with its key
  @param KEY - encryption key (must be 256 bits , 32 chars)
  @param data - data to be decrypted
  @param callback - in case of promise kindly don't provide this
###
exports.decrypt = (data, key, callback) ->
  if(callback)
    try
      decryptedData = decrypt(data, key)
      # if not an error
      if(utils.typeOf(decryptedData) == 'string')
        callback(undefined, decryptedData)
      else
# here data is the error
        callback(decryptedData, undefined)
# error decrypting
    catch error
      callback(error, undefined)
  else
    return new Promise((resolve, reject)->
      try
        decryptedData = decrypt(data, key)

        # if not an error
        if(utils.typeOf(decryptedData) == 'string')
          resolve(decryptedData)
        else
# here data is the error
          reject(decryptedData)
      catch error
        reject(error)
    )

###
----- PRIVATE -----
###

# the encryption function
encrypt = (data, key) ->
  try
    iv = crypto.randomBytes(IV_LENGTH)
    cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(key), iv)
    encrypted = cipher.update(data)
    encrypted = Buffer.concat([
      encrypted
      cipher.final()
    ])
    iv.toString('hex') + ':' + encrypted.toString('hex')
  catch err
    return handler.invalidKeyLength()

# aes decryption function
decrypt = (data, key) ->
  try
    textParts = data.split(':')
    iv = Buffer.from(textParts.shift(), 'hex')
    encryptedText = Buffer.from(textParts.join(':'), 'hex')
    decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(key), iv)
    decrypted = decipher.update(encryptedText)
    decrypted = Buffer.concat([
      decrypted
      decipher.final()
    ])
    decrypted.toString()
  catch err
# if key error then return it
    if(err.toString().indexOf("Invalid key length") > -1)
      handler.invalidKeyLength()
# throw other errors
    else
      throw err

