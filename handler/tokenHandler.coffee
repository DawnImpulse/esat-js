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
tokenHandler

@author Saksham
@note Last Branch Update - master
     
@note Created on 2018-06-02 by Saksham
@note Updates :
  Saksham - 2018 06 05 - master - token refresh handling
  Saksham - 2018 06 18 - master - adding refresh token
###

aes256 = require '../encryption/aes256'
errorH = require '../utils/errorHandler'
utils = require '../utils/utilities'

###
  Use to generate a new token
  @param payload - any data to save (string/number/json) - empty json by default
  @param key - the encryption key
  @param exp - the token expiry in milliseconds - 1 year by default
  @param rat - token refresh interval/at - 1 hour by default
  @param iss - token issuer
  @param callback - not needed in case of promise
###
exports.generateToken = (payload, key, exp = 86400000, rat = 3600000, iss, callback) ->
  currentMilli = (new Date).getTime() # current time in milli from epoch

  rtk = utils.uuid()

  tokenData =
    iat: currentMilli
    rat: currentMilli + rat
    exp: currentMilli + exp
    lrt: currentMilli
    iss: iss
    rtk: rtk
    payload: payload

  if(callback)
    aes256.encrypt(JSON.stringify(tokenData), key).then((token)->
      callback(null, {token: token, rtk: rtk})
    ).catch (error) ->
      callback(error, null)
  else
    return new Promise((resolve, reject) ->
      aes256.encrypt(JSON.stringify(tokenData), key).then((token) ->
        resolve({token: token, rtk: rtk})
      ).catch (error) ->
        reject(error)
    )

###
  verify authentication token
  @param token
  @param key - decryption key
  @param callback - not needed in case of promise
###
exports.verifyToken = (token, key, callback) ->
  if(callback)
    tokenVerification(token, key).then((tokenData)->
      callback(undefined, tokenData)
    ).catch (error) ->
      callback(error, undefined)
  else
    return tokenVerification(token, key)

###
  refreshing authentication token
  @param oldToken - previous interval expired token
  @param key
  @param callback - not needed in case of promise
###
exports.refreshToken = (oldToken, key, callback) ->
  if callback
    tokenRefresh(oldToken, key).then((token)->
      callback(undefined, token)
    ).catch (error) ->
      callback(error, undefined)
  else
    return tokenRefresh(oldToken, key)

###
----- PRIVATE -----
###

tokenVerification = (token, key) ->
  new Promise((resolve, reject)->
    aes256.decrypt(token, key).then((data)->
      tokenData = JSON.parse(data)
      if(tokenData.exp <= (new Date()).getTime())
        reject errorH.tokenExpired()
      else if(tokenData.rat <= (new Date()).getTime())
        reject errorH.tokenRefresh(tokenData.rtk)
      else
        resolve tokenData
# catch for decryption
    ).catch (error) ->
      if(error.toString().indexOf("06065064") > -1)
        reject errorH.invalidKey()
      else
        reject errorH.invalidToken()
  )

tokenRefresh = (token, key) ->
  new Promise((resolve, reject)->
    aes256.decrypt(token, key).then((decoded)->
      currentMilli = (new Date).getTime() # current time in milli from epoch

      decoded = JSON.parse(decoded)
      if(decoded.exp <= currentMilli)
        reject errorH.tokenExpired()
      else
        tokenData =
          iat: decoded.iat
          rat: currentMilli + (decoded.rat - decoded.iat)
          exp: decoded.exp
          lrt: currentMilli
          iss: decoded.iss
          rtk: decoded.rtk
          payload: decoded.payload

        aes256.encrypt(JSON.stringify(tokenData), key).then((tokenR)->
          resolve tokenR
        )
    ).catch (error)->
      if(error.toString().indexOf("06065064") > -1)
        reject errorH.invalidKey()
      else
        reject errorH.invalidToken()
  )