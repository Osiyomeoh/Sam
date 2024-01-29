import Swap from 0x05 
import FlowToken from 0x05 

transaction(amount: UFix64) {
    let vaultRef: &FlowToken.Vault

    prepare(signer: AuthAccount) {
        // Borrow a reference to the signer's FlowToken.Vault
        self.vaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/FlowTokenVault)
            ?? panic("Could not borrow reference to the FlowToken.Vault")
    }

    execute {
        // Call the swapWithVaultRef function on the Swap contract
        Swap.swapWithVaultRef(vaultRef: self.vaultRef, amount: amount)
        
        log("Swapped $FLOW for custom tokens using swapWithVaultRef")
    }
}
