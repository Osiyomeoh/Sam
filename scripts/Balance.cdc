import MyFungibleToken from 0x05
import FungibleToken from 0x05

pub fun main(account: Address): UFix64 {
    let publicAccount = getAccount(account)

    // Method 1: Checking if the Capability is Correctly Set Up
    // This checks if there's a public capability for MyFungibleToken.Vault
    let capability = publicAccount.getCapability<&MyFungibleToken.Vault{FungibleToken.Balance}>(/public/MyFungibleTokenBalance)
    if !capability.check() {
        // If the capability is not set up, we can assume that the vault is not set up correctly
        return 0.0
    }

    // Borrow a reference to the vault, if possible
    if let vaultRef = capability.borrow() {
        
        return vaultRef.balance
    }

    
    return 0.0
}
