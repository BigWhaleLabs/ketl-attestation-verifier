pragma circom 2.0.4;

include "./templates/EdDSAValidator.circom";
include "./templates/MerkleTreeCheckerPoseidon.circom";

template AttestationChecker() {
  var attestationMessageLength = 2; // [attestation type, attestation]
  signal input attestationMessage[attestationMessageLength];
  // Export attestation type
  signal output attestationType <== attestationMessage[0];
  // Check if the EdDSA signature is valid
  signal input attestationPubKeyX;
  signal input attestationPubKeyY;
  signal input attestationR8x;
  signal input attestationR8y;
  signal input attestationS;

  component attestationEdDSAValidator = EdDSAValidator(attestationMessageLength);
  attestationEdDSAValidator.pubKeyX <== attestationPubKeyX;
  attestationEdDSAValidator.pubKeyY <== attestationPubKeyY;
  attestationEdDSAValidator.R8x <== attestationR8x;
  attestationEdDSAValidator.R8y <== attestationR8y;
  attestationEdDSAValidator.S <== attestationS;
  for (var i = 0; i < attestationMessageLength; i++) {
    attestationEdDSAValidator.message[i] <== attestationMessage[i];
  }
  // Check Merkle proof
  var levels = 20;
  signal input pathIndices[levels];
  signal input pathElements[levels];

  component merkleTreeChecker = MerkleTreeCheckerPoseidon(levels);
  merkleTreeChecker.leaf <== attestationMessage[1];
  for (var i = 0; i < levels; i++) {
    merkleTreeChecker.pathElements[i] <== pathElements[i];
    merkleTreeChecker.pathIndices[i] <== pathIndices[i];
  }

  signal output merkleRoot <== merkleTreeChecker.root;
  // Export a nullifier so that the proof can be used only once
  signal input nullifier;
}

component main{public [attestationPubKeyX, nullifier]} = AttestationChecker();