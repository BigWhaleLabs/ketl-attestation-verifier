import { IncrementalMerkleTree } from '@zk-kit/incremental-merkle-tree'
import { buildPoseidon } from 'circomlibjs'

export default async function (
  element: bigint | string | number,
  allElements: (bigint | string | number)[]
) {
  const poseidon = await buildPoseidon()
  const F = poseidon.F
  const tree = new IncrementalMerkleTree(
    (values) => BigInt(F.toString(poseidon(values))),
    20,
    BigInt(0),
    2
  )
  allElements.forEach((c) => tree.insert(c))
  return tree.createProof(tree.indexOf(element))
}
