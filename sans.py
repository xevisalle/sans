import sys
import os
import time
import subprocess
from termcolor import colored

if (len(sys.argv) < 2):
    print("\nUSAGE:\n")
    print("python sans.py [OPTION]\n")
    print("Where 'OPTION' can be:")
    print("-s : Perform the setup.")
    print("-g : Generate the input providing the arguments [c] [token] [texp] [private_key].")
    print("-p : Generate a proof.")
    print("-v : Verify a proof.")
    print("-d : Deploys a web prover in port 8080.")
    print("-i : Print circuit information.")
    print("-w : Print the witness.")
    print("-c : Clear all generated data.")
    print("")

else:
    if (sys.argv[1] == '-s'):
        if not os.path.exists('data'):
            os.makedirs('data')

        print(colored("[SANS] :", "yellow") + " Performing setup...")
        start_time = time.time()
        os.system("sh src/setup.sh")
        setup_time = round(time.time() - start_time, 3)
        print(colored("[SANS] :", "yellow") + " Setup performed in " + str(setup_time) + " seconds.")

    elif (sys.argv[1] == '-g'):
        out = os.popen('node src/operator.js ' + sys.argv[2] + ' ' + sys.argv[3] + ' ' + sys.argv[4] + ' ' + sys.argv[5]).read()
        f = open("data/input.json", "w")
        f.write(out)
        f.close()

    elif (sys.argv[1] == '-p'):
        print(colored("[SANS] :", "yellow") + " Generating proof...")
        start_time = time.time()
        os.system("sh src/prove.sh")
        proving_time = round(time.time() - start_time, 3)
        print(colored("[SANS] :", "yellow") + " Proof generated in " + str(proving_time) + " seconds.")

    elif (sys.argv[1] == '-v'):
        print(colored("[SANS] :", "yellow") + " Verifying proof...")
        start_time = time.time()
        os.system("sh src/verify.sh")
        verifying_time = round(time.time() - start_time, 3)
        print(colored("[SANS] :", "yellow") + " Proof verified in " + str(verifying_time) + " seconds.")

    elif (sys.argv[1] == '-d'):
        os.system("cp data/circuit_final.zkey websans/circuit_final.zkey")
        os.system("cp data/sans.wasm websans/sans.wasm")
        os.system("cp data/input.json websans/input.json")
        os.system("cp data/verification_key.json websans/verification_key.json")
        os.system("cd websans && python -m http.server 8080")

    elif (sys.argv[1] == '-i'):
        os.system("snarkjs r1cs info data/sans.r1cs")

    elif (sys.argv[1] == '-w'):
        os.system("snarkjs wtns debug data/sans.wasm websans/input.json data/witness.wtns data/sans.sym --trigger --get --set")

    elif (sys.argv[1] == '-c'):
        os.system("rm -rf data")
        os.system("rm websans/circuit_final.zkey websans/sans.wasm websans/verification_key.json websans/input.json")