let chai = require('chai');
let should = chai.should();
let assert = chai.assert;
let {generate, verify} = require('./index.js');
let {encrypt, decrypt} = require('./encryption/aes256.js');

it('1. pass : should encrypt & decrypt given string', () => {
    let data = "hello world is great";
    let key = "F4ys9OKxmy0V7p6sq2HadvNPCd05fZ2c";

    return encrypt(data, key, (err, txt) => {
        assert.equal(err, undefined);
        assert.include(txt, ':');
        assert.typeOf(txt, 'string');

        return decrypt(txt, key, (err, resp) => {
            console.log(resp);
            assert.equal(err, undefined);
            assert.typeOf(resp, 'string');
            assert.equal(resp, data);
            console.log(txt);
            console.log(resp)
        })
    })
});

it('2. pass : should generate & verify token', () => {
    let key = "F4ys9OKxmy0V7p6sq2HadvNPCd05fZ2c";
    let payload = "Hello World";

    return generate({payload}, key, (err, token) => {
        assert.equal(err, undefined);
        token.should.have.property('token');
        Object.keys(token).should.have.lengthOf(2);

        return verify(token.token, key, (err, resp) => {
            assert.equal(err, undefined);
            assert.equal(resp.payload, payload)
        })
    })
});

it('3. fail : assert invalid key length while generating', () => {
    let key = "abcndh";
    let payload = "Hello World";

    return generate({payload}, key, (err, token) => {
        assert.equal(token, undefined);
        Object.keys(err).should.have.lengthOf(2);
        err.should.have.property('code',8);
    })
});

it('4. fail : assert invalid key length while verifying', () => {
    let key = "abcndh";
    let token = "d94dab56a2699b18217f21d2a6dffe43:f9589c323fb588bd6d81805051e534a40f87056a7814ef433412b4c9dbfc8fd0";

    return verify(token, key, (err, token) => {
        assert.equal(token, undefined);
        Object.keys(err).should.have.lengthOf(2);
        err.should.have.property('code',8);
    })
});

it('5. fail : assert invalid key while verifying', () => {
    let key = "DEkfEpOzVNS6j8BqTD7kAPz8SKe7J6yF";
    let token = "d94dab56a2699b18217f21d2a6dffe43:f9589c323fb588bd6d81805051e534a40f87056a7814ef433412b4c9dbfc8fd0";

    return verify(token, key, (err, token) => {
        assert.equal(token, undefined);
        Object.keys(err).should.have.lengthOf(2);
        err.should.have.property('code',1);
    })
});

it('6. fail : assert invalid token while verifying', () => {
    let key = "F4ys9OKxmy0V7p6sq2HadvNPCd05fZ2c";
    let token = "sdfdfce";

    return verify(token, key, (err, token) => {
        assert.equal(token, undefined);
        Object.keys(err).should.have.lengthOf(2);
        err.should.have.property('code',2);
    })
});

