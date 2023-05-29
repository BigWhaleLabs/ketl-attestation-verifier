pragma circom 2.0.4;

include "./templates/EdDSAValidator.circom";
include "./templates/MerkleTreeCheckerPoseidon.circom";

template PasswordChecker() {
  var attestationMessageLength = 2; // [attestation type, attestation]
  signal input attestationMessage[attestationMessageLength];
  // Export the attestation type
  signal output attestationType <== attestationMessage[0];
  // Entangle the password
  signal input password;

  component entanglementHasher = Poseidon(1 + attestationMessageLength);
  entanglementHasher.inputs[0] <== password;
  for (var i = 0; i < attestationMessageLength; i++) {
    entanglementHasher.inputs[1 + i] <== attestationMessage[i];
  }

  signal entanglement <== entanglementHasher.out;
  // Export the nullifier
  component nullifierHasher = Poseidon(4);
  nullifierHasher.inputs[0] <== password;
  nullifierHasher.inputs[1] <== attestationMessage[1];
  nullifierHasher.inputs[2] <== 69;
  nullifierHasher.inputs[3] <== 420;
  signal output nullifier <== nullifierHasher.out;
  // Check Merkle proof
  var levels = 20;
  signal input pathIndices[levels];
  signal input pathElements[levels];

  component merkleTreeChecker = MerkleTreeCheckerPoseidon(levels);
  merkleTreeChecker.leaf <== entanglement;
  for (var i = 0; i < levels; i++) {
    merkleTreeChecker.pathElements[i] <== pathElements[i];
    merkleTreeChecker.pathIndices[i] <== pathIndices[i];
  }

  signal output merkleRoot <== merkleTreeChecker.root;
}

component main = PasswordChecker();