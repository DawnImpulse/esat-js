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
###

aes256 = require '../encryption/aes256'

###
  Use to generate a new token
  @param payload - any data to save (string/number/json)
  @param audience - a single audience id
  @param key - the encryption key
  @param exp - the token expiry in milliseconds
  @param rint - token refresh interval
  @param iss - token issuer
  @param callback - not needed in case of promise
###
exports.generateToken = (payload, audience, key, exp, rint, iss, callback) ->
  currentMilli = (new Date).getTime() # current time in milli from epoch

  tokenData =
    aud: audience
    iss: iss
    iat: currentMilli
    rint: currentMilli + rint
    exp: currentMilli + exp
    rat: currentMilli
    payload: payload

  if(callback)
    aes256.encrypt(key, JSON.stringify(tokenData), callback)
  else
    return aes256.encrypt(key, JSON.stringify(tokenData))



