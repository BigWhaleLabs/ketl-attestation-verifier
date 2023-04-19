import { wasm as wasmTester } from 'circom_tester'
import getAttestationInputs from '../utils/inputs/getAttestationInputs'

describe('AttestationChecker circuit', function () {
  before(async function () {
    this.circuit = await wasmTester('circuits/AttestationChecker.circom')
    this.baseInputs = await getAttestationInputs()
  })
  it('should generate the witness successfully', async function () {
    const witness = await this.circuit.calculateWitness(this.baseInputs)
    await this.circuit.assertOut(witness, {})
  })
})
