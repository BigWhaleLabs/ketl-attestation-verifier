import { BigNumber } from 'ethers'
import eddsaSign from '../eddsa/eddsaSign'
import getMerkleTreeProof from '../getMerkleTreeProof'
import ids from '../ids'

export default async function (id = ids[0], allIds = ids) {
  const merkleProof = await getMerkleTreeProof(id, allIds)
  return {
    ...(await eddsaSign([0, id])),
    pathIndices: merkleProof.pathIndices,
    pathElements: merkleProof.siblings.map(([s]) =>
      BigNumber.from(s).toHexString()
    ),
    password: 69420,
  }
}
