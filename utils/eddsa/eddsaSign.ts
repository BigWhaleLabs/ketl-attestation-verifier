import { buildEddsa } from 'circomlibjs'
import { buildPoseidon } from 'circomlibjs'
import { utils } from 'ethers'
import eddsaPrivateKeyBytes from './eddsaPrivateKeyBytes'

export default async function (message: number[]) {
  const eddsa = await buildEddsa()
  const poseidon = await buildPoseidon()
  const F = poseidon.F
  const hash = poseidon(message)

  const privateKey = utils.arrayify(eddsaPrivateKeyBytes)
  const publicKey = eddsa.prv2pub(privateKey)
  const signature = eddsa.signPoseidon(privateKey, hash)
  return {
    attestationMessage: message,
    attestationPubKeyX: F.toObject(publicKey[0]).toString(),
    attestationPubKeyY: F.toObject(publicKey[1]).toString(),
    attestationR8x: F.toObject(signature.R8[0]).toString(),
    attestationR8y: F.toObject(signature.R8[1]).toString(),
    attestationS: signature.S.toString(),
  }
}
