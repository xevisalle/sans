# SANS: Self-sovereign Authentication for Network Slices

This is a PoC implementation of SANS, a protocol based on zk-SNARKs for self-sovereign authentication in 5G network slices. Such implementation uses [snarkjs](https://github.com/iden3/snarkjs), a JavaScript and WASM framework for deploying zk-SNARK applications. Even when we focus on Network Slices, our protocol is scalable to other scenarios where a private and trustworthy authentication system is required. 

This work has been accepted to be published in the special issue *Trustworthy Networking for Beyond 5G Networks 2020* of the journal *Security and Communication Networks*. A preprint providing all the details regarding our protocol can be found [here](https://arxiv.org/pdf/2010.15867.pdf).

**DISCLAIMER:** this PoC implementation is currently **unstable**, it is not intended to be used in a production environment, only for academic purposes.

## Overview

Our protocol is currently using the Groth'16 zk-SNARK along with the elliptic curve BN128. Furthermore, the circuit used by SANS (which can be found at `src/sans.circom`) is depicted in the next image:

<p align="center">
<img src="./docs/circuit.png" width="40%"/>
</p>

Both hashing functions are Poseidon, and the signing algorithm is EdDSA. Overall, the number of constraints is 7565.

## Install dependencies

Both *snarkjs* and *circom* (a library for creating R1CS circuits) are required. Installation details can be found [here](https://github.com/iden3/snarkjs). The following dependencies are also required:

```
npm install ffjavascript@0.1.0 && npm install blake-hash
```

## Usage

We can get the help message by executing:

```
$ python sans.py   

USAGE:

python sans.py [OPTION]

Where 'OPTION' can be:
-s : Perform the setup.
-g : Generate the input providing the arguments [c] [token] [texp] [private_key].
-p : Generate a proof.
-v : Verify a proof.
-d : Deploys a web prover in port 8080.
-i : Print circuit information.
-w : Print the witness.
-c : Clear all generated data.
```

As such, in order to perform the setup we should simply execute:

```
python sans.py -s
```

This will generate all the required files (the CRS and the proving/verification keys) and will save them into the `data/` folder. Now, a Slice Operator (SO) may want to provide access to a user. In order to do so, it will select a set of values `[c] [token] [texp] [private_key]` and execute, for instance, the following command:

```
python sans.py -g 1234 5678 20240621 00112233445566778899
```

This will generate the `data/input.json` file, where in a real scenario, the `[c]` value should be changed by the user each time it wants to prove his right to access the service. Now, the user can prove such a right as follows:

```
python sans.py -p
```

This generates the files `data/proof.json` and `data/public.json`, along with the witness `data/witness.wtns`. Now, the verifier simply runs:

```
python sans.py -v
```

Furthermore, a webclient may be deployed simply by running:

```
python sans.py -d
```

After executing it, we have to open `http://localhost:8080` in a web browser and will get a basic interface where to test a prover/verifier.

## Benchmarks

<p align="center">
<img src="./docs/chart.png" width="70%"/>
</p>

## Authors

* **Xavier Salleras** - xavier.salleras@upf.edu
* **Vanesa Daza** - vanesa.daza@upf.edu
