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
###

aes256 = require '../encryption/aes256'
errorH = require '../utils/errorHandler'

###
  Use to generate a new token
  @param payload - any data to save (string/number/json) - empty json by default
  @param key - the encryption key
  @param exp - the token expiry in milliseconds - 1 year by default
  @param rat - token refresh interval/at - 1 hour by default
  @param iss - token issuer
  @param aud - a single audience id
  @param callback - not needed in case of promise
###
exports.generateToken = (payload, key, exp = 31540000000, rat = 3600000, iss, aud, callback) ->
  currentMilli = (new Date).getTime() # current time in milli from epoch

  tokenData =
    aud: aud
    iss: iss
    iat: currentMilli
    rat: currentMilli + rat
    exp: currentMilli + exp
    lrt: currentMilli
    payload: payload

  if(callback)
    aes256.encrypt(JSON.stringify(tokenData), key, callback)
  else
    return aes256.encrypt(JSON.stringify(tokenData), key)

###
  verify authentication token
  @param token
  @param key - decryption key
  @param audiences - the audiences array
  @param callback - not needed in case of promise
###
exports.verifyToken = (token, key, audiences, callback) ->
  if(callback)
    tokenVerification(token, key, audiences).then((tokenData)->
      callback(undefined , tokenData)
    ).catch (error) ->
      callback(error, undefined )
  else
    return tokenVerification(token, key, audiences)

###
  refreshing authentication token
  @param oldToken - previous interval expired token
  @param key
  @param callback - not needed in case of promise
###
exports.refreshToken = (oldToken, key, callback) ->
  if callback
    tokenRefresh(oldToken, key).then((token)->
      callback(undefined , token)
    ).catch (error) ->
      callback(error, undefined )
  else
    return tokenRefresh(oldToken, key)

###
----- PRIVATE -----
###

tokenVerification = (token, key, audiences) ->
  new Promise((resolve, reject)->
    aes256.decrypt(token, key).then((data)->
      tokenData = JSON.parse(data)
      if(tokenData.exp <= (new Date()).getTime())
        reject errorH.tokenExpired()
      else if(tokenData.rat <= (new Date()).getTime())
        reject errorH.tokenRefresh()
      else if(tokenData.aud)
        if(!audiences)
          reject errorH.audiencesNotProvided()
        else if(audiences.indexOf(tokenData.aud) is -1)
          reject errorH.invalidAudience()
        else
          resolve tokenData
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
          aud: decoded.aud
          iss: decoded.iss
          iat: decoded.iat
          rat: currentMilli + (decoded.rat - decoded.iat)
          exp: decoded.exp
          lrt: currentMilli
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