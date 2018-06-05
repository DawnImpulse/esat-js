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
  index

  @author Saksham
  @note Last Branch Update - 

  @note Created on 2018-06-05 by Saksham
  @note Updates :
  */
  var errorHandler, tokenHandler;

  tokenHandler = require('./handler/tokenHandler');

  errorHandler = require('./utils/errorHandler');

  /*
    generate a new token
    @param options - as name suggests this parameter contains all the extra options required for generating token
                     1. exp - token expiry (milliseconds) - default 1 year
                     2. rat - token refresh interval/at (milliseconds) - default 1 hour
                     3. aud - token audience
                     4. iss - token issuer
                     5. payload - additional json object/json array
    @param key - encryption key
    @param callback - not required in case of promise
  */
  exports.generate = function(options, key, callback) {
    if (callback) {
      if (!key) {
        return callback(errorHandler.keyNotProvided(), null);
      } else {
        return tokenHandler.generateToken(options.payload, key, options.exp, options.rat, options.iss, options.aud, callback);
      }
    } else {
      if (!key) {
        return new Promise(function(resolve, reject) {
          return reject(errorHandler.keyNotProvided());
        });
      } else {
        return tokenHandler.generateToken(options.payload, key, options.exp, options.rat, options.iss, options.aud);
      }
    }
  };

  /*
    verify a token
    @param token - the generated token
    @param key - encryption key
    @param audiences - provide a json array of audiences only if given during token generation
    @param callback - not required in case of promise
  */
  exports.verify = function(token, key, audiences, callback) {
    if (callback) {
      if (!key) {
        return callback(errorHandler.keyNotProvided(), null);
      } else {
        return tokenHandler.verifyToken(token, key, audiences, callback);
      }
    } else {
      if (!key) {
        return new Promise(function(resolve, reject) {
          return reject(errorHandler.keyNotProvided());
        });
      } else {
        return tokenHandler.verifyToken(token, key, audiences);
      }
    }
  };

}).call(this);

//# sourceMappingURL=index.js.map