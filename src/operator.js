const field = require("ffjavascript").bn128.Fr;
const eddsa = require("../circomlib/eddsa.js");

const c = field.e(process.argv[2]);
const token = field.e(process.argv[3]);
const texp = field.e(process.argv[4]);
const prvKey = Buffer.from(process.argv[5], "hex");
const pubKey = eddsa.prv2pub(prvKey);
const signature = eddsa.signPoseidon(prvKey, field.e(token*texp));

const input =
'{\
  "c": "' + c + '",\
  "enabled": "1",\
  "Ax": "' + pubKey[0] + '",\
  "Ay": "' + pubKey[1] + '",\
  "R8x": "' + signature.R8[0] + '",\
  "R8y": "' + signature.R8[1] + '",\
  "S": "' + signature.S + '",\
  "token": "' + token + '",\
  "texp": "' + texp + '"\
}';

console.log(input);