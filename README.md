# esat-js
>Encrypted & Secure Authentication Token

- As name suggests **esat** is token like *jwt* although it always encrypt the information in the token providing more security even on the most basic level. **esat** is also very easy & straight forward to work with.

	> Note : It is not a good practise to store user's password or any other confidential information in the esat (token) itself.
	
- The tokens will be encrypted using **AES** hence providing a good level of encryption *(will also depend on key strength)*.
- If you need to use refresh tokens, the library provides a single unified solution by storing refresh token info inside the main token with refresh interval (more info below).

#### Current features (v1.0.0)

- The release has all the basic functionalities including generation, verification & refreshing token.

#### Deprecation Notice
- Since **crypto.createCipher** is deprecated by node to include more secure **crypto.createCipheriv** , the token earlier generated via esat won't be compatible with current & future releases (& vice-versa).


#### Notes
- The whole library supports both **callback** as well as **promises** although the documentation will be in callback to target larger audience. 

- The encryption key must be 256bit (32 chars). Try to use [random keygen](https://randomkeygen.com/) to generate strong keys.
- The time in the token will be **milliseconds since epoch**.

### Esat Generation
- (default) easy generation
~~~
var esat = require('esat');

/* 
	- first parameter is option (required)
	- second parameter is encryption key (required & must be 256 bit)
*/

esat.generate({}, key, function(err, result){ 
	//err will be undefined incase of result
})
~~~
> various error codes and their corresponding message / data is mentioned below. 
- generated **esat** will have
	- *token* : the token itself
	- *rtk* : the refreshing token

- **internally esat** will contain the following parameters 
	- *iat (token issued)* - time at which token is generated
	- *rat (refresh at)* - next time token should be refreshed
	- *exp (expire at)* - time at which token should be expired
	- *lrt (last refresh at)* - last time token was refreshed
	- *iss (issuer)* - token issuer (optional)
	- *rtk (refresh token)* - the refresh token unique id (uuid)
	- *payload* : any extra payload user specified / provided (default : {} )
 - **options** for generating esat (options parameter should be a json formatted object). 
    - *exp* : specify expire time in milliseconds from now, e.g. for expiry in 30 seconds provide `exp : 30000`
    - *rat* : specify refresh interval in milliseconds. 
    - *iss* : esat issuer ( can be string, number or json) 
    - *payload* : extra payload (can be string, number or json) 

### Esat Verification
~~~
esat.verify(esat,key,function(err, result){
 // result will contain all the details mentioned above (internal parameters in esat) 
});
~~~
> various error codes and their corresponding message / data is mentioned below. 
> 
#### Esat Refresh
- `rtk` will be returned when a token is needed to be refreshed while verifying esat. You can use it to perform verification or any other thing you wish before reissuing esat. 
~~~
esat.refresh(token,key,function(err, token){
 ...
}) 
~~~

#### Error Object
In case of any error following error object will be returned -
~~~
{
  "code" : 1,
  "message" : "..."
}
~~~
- various error codes will be 
	- **1** : invalid key
	- **2** : invalid token
	- **3** : token expired
	- **4** : token should be refreshed
	- **5** :  key not provided
	- **8** : invalid key length (if a 256 bit key not provided)
> Note : In case of error 4 , additional **rtk** field with refresh token id will be returned.

#### Releases
- v1.0.0
	- All basic token generation/ verification & refresh functionalities.
	- Using latest encryption method provided in node crypto module for security
	
> Pull requests are always welcomed (kindly sign commits with GPG keys. **THANKS**)

#### Contact

-   Twitter -  [@dawnimpulse](https://twitter.com/dawnimpulse)

#### License

```
ISC Licence

Copyright 2018-2019 Saksham (DawnImpulse)

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE
OR PERFORMANCE OF THIS SOFTWARE.
```