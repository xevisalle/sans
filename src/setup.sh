snarkjs powersoftau new bn128 14 data/pot12_0000.ptau -v
snarkjs powersoftau contribute data/pot12_0000.ptau data/pot12_0001.ptau --name="First contribution" -v -e="random"
snarkjs powersoftau beacon data/pot12_0001.ptau data/pot12_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"
snarkjs powersoftau prepare phase2 data/pot12_beacon.ptau data/pot12_final.ptau -v
circom src/sans.circom --r1cs --wasm --sym -v
mv sans.wasm data/sans.wasm
mv sans.sym data/sans.sym
mv sans.r1cs data/sans.r1cs
snarkjs zkey new data/sans.r1cs data/pot12_final.ptau data/circuit_0000.zkey
snarkjs zkey contribute data/circuit_0000.zkey data/circuit_0001.zkey --name="First contribution" -v -e="random"
snarkjs zkey beacon data/circuit_0001.zkey data/circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
snarkjs zkey export verificationkey data/circuit_final.zkey data/verification_key.json
mv verification_key.json data/verification_key.json