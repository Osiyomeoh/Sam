import FungibleToken from 0x05 
import FlowToken from 0x05 

pub fun main(accountAddress: Address): UFix64 {
    // Get the account's public capability for the FlowToken Vault's Balance interface
    let balanceCapability = getAccount(accountAddress).getCapability<&FlowToken.Vault{FungibleToken.Balance}>(/public/FlowTokenBalance)

    // Borrow a reference to the Vault from the capability
    let vaultRef = balanceCapability.borrow()
        ?? panic("Could not borrow a reference to the balance capability")

    // Return the balance of the Vault
    return vaultRef.balance
}
