import { BigNumber } from 'ethers'
import eddsaSign from '../eddsa/eddsaSign'
import getMerkleTreeProof from '../getMerkleTreeProof'
import ids from '../ids'

export default async function (id = ids[0], allIds = ids) {
  const merkleProof = await getMerkleTreeProof(id, allIds)
  return {
    attestationMessage: (await eddsaSign([0, id])).attestationMessage,
    password: 69420,
    pathIndices: merkleProof.pathIndices,
    pathElements: merkleProof.siblings.map(([s]) =>
      BigNumber.from(s).toHexString()
    ),
  }
}
