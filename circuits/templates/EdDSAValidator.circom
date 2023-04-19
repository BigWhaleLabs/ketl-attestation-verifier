pragma circom 2.0.4;

include "../../node_modules/circomlib/circuits/eddsaposeidon.circom";

// Check if the EdDSA signature is valid
template EdDSAValidator(messageLength) {
  // Get all inputs
  signal input pubKeyX;
  signal input pubKeyY;
  signal input R8x;
  signal input R8y;
  signal input S;
  signal input message[messageLength];
  // Hash message
  component poseidon = Poseidon(messageLength);
  for (var i = 0; i < messageLength; i++) {
    poseidon.inputs[i] <== message[i];
  }
  // Verify the signature
  component verifier = EdDSAPoseidonVerifier();
  verifier.enabled <== 1;
  verifier.Ax <== pubKeyX;
  verifier.Ay <== pubKeyY;
  verifier.R8x <== R8x;
  verifier.R8y <== R8y;
  verifier.S <== S;
  verifier.M <== poseidon.out;
}