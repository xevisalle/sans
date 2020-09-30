include "../circomlib/compconstant.circom";
include "../circomlib/poseidon.circom";
include "../circomlib/bitify.circom";
include "../circomlib/escalarmulany.circom";
include "../circomlib/escalarmulfix.circom";

template SANSVerifier() {
    signal input enabled;
    signal input Ax;
    signal input Ay;

    signal private input S;
    signal input R8x;
    signal input R8y;

    signal private input token;
    signal input texp;
    signal input c;
    signal output hashOut;

    var i;

    component snum2bits = Num2Bits(253);
    snum2bits.in <== S;

    component compConstant = CompConstant(2736030358979909402780800718157159386076813972158567259200215660948447373040);

    for (i=0; i<253; i++) {
        snum2bits.out[i] ==> compConstant.in[i];
    }
    compConstant.in[253] <== 0;
    compConstant.out*enabled === 0;

    component hash = Poseidon(5);

    hash.inputs[0] <== R8x;
    hash.inputs[1] <== R8y;
    hash.inputs[2] <== Ax;
    hash.inputs[3] <== Ay;
    hash.inputs[4] <== token*texp;

    component h2bits = Num2Bits_strict();
    h2bits.in <== hash.out;

    component dbl1 = BabyDbl();
    dbl1.x <== Ax;
    dbl1.y <== Ay;
    component dbl2 = BabyDbl();
    dbl2.x <== dbl1.xout;
    dbl2.y <== dbl1.yout;
    component dbl3 = BabyDbl();
    dbl3.x <== dbl2.xout;
    dbl3.y <== dbl2.yout;

    component isZero = IsZero();
    isZero.in <== dbl3.x;
    isZero.out*enabled === 0;

    component mulAny = EscalarMulAny(254);
    for (i=0; i<254; i++) {
        mulAny.e[i] <== h2bits.out[i];
    }
    mulAny.p[0] <== dbl3.xout;
    mulAny.p[1] <== dbl3.yout;

    component addRight = BabyAdd();
    addRight.x1 <== R8x;
    addRight.y1 <== R8y;
    addRight.x2 <== mulAny.out[0];
    addRight.y2 <== mulAny.out[1];

    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];
    component mulFix = EscalarMulFix(253, BASE8);
    for (i=0; i<253; i++) {
        mulFix.e[i] <== snum2bits.out[i];
    }

    component eqCheckX = ForceEqualIfEnabled();
    eqCheckX.enabled <== enabled;
    eqCheckX.in[0] <== mulFix.out[0];
    eqCheckX.in[1] <== addRight.xout;

    component eqCheckY = ForceEqualIfEnabled();
    eqCheckY.enabled <== enabled;
    eqCheckY.in[0] <== mulFix.out[1];
    eqCheckY.in[1] <== addRight.yout;

    component hashOne = Poseidon(2);
    hashOne.inputs[0] <== c;
    hashOne.inputs[1] <== token;

    hashOut <== hashOne.out;
}

component main = SANSVerifier();