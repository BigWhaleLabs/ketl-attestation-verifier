import { wasm as wasmTester } from 'circom_tester'
import getPasswordInputs from '../utils/inputs/getPasswordInputs'

describe('PasswordChecker circuit', function () {
  before(async function () {
    this.circuit = await wasmTester('circuits/PasswordChecker.circom')
    this.baseInputs = await getPasswordInputs()
  })
  it('should generate the witness successfully', async function () {
    const witness = await this.circuit.calculateWitness(this.baseInputs)
    await this.circuit.assertOut(witness, {})
  })
})
