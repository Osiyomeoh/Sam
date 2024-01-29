import MyFungibleToken from 0x05 
import FlowToken from 0x05 
import FungibleToken from 0x05

transaction(userId: Address, amount: UFix64) {
    // Local variables to store borrowed references and capabilities
    let userVaultRef: &MyFungibleToken.Vault{FungibleToken.Provider, FungibleToken.Receiver}
    let adminFlowVaultRef: &FlowToken.Vault
    let userFlowVaultCap: Capability<&{FungibleToken.Receiver}>

    prepare(signer: AuthAccount) {
        // Verify that the signer is the Admin
        assert(MyFungibleToken.isAdmin(addr: signer.address), message: "Unauthorized: Only the Admin can execute this transaction.")

        // Access and store the user's MyFungibleToken Vault reference
        self.userVaultRef = getAccount(userId)
            .getCapability(/public/MyFungibleTokenReceiver)
            .borrow<&MyFungibleToken.Vault{FungibleToken.Provider, FungibleToken.Receiver}>()
            ?? panic("Could not borrow reference to the user's MyFungibleToken Vault")

        // Access and store the Admin's FlowToken Vault reference
        self.adminFlowVaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/FlowTokenVault)
            ?? panic("Could not borrow reference to the Admin's FlowToken Vault")

        // Store the user's FlowToken Receiver capability
        self.userFlowVaultCap = getAccount(userId).getCapability<&{FungibleToken.Receiver}>(/public/FlowTokenReceiver)
    }

    execute {
        // Withdraw MyFungibleToken tokens from the user's Vault using the stored reference
        let myFungibleTokens <- self.userVaultRef.withdraw(amount: amount)

        // Withdraw $FLOW tokens from the Admin's Vault using the stored reference
        let flowTokens <- self.adminFlowVaultRef.withdraw(amount: amount)

        // Deposit $FLOW tokens into the user's FlowToken Vault using the stored capability
        let userFlowVaultRef = self.userFlowVaultCap.borrow()
            ?? panic("Could not borrow reference to the user's FlowToken Receiver")
        userFlowVaultRef.deposit(from: <- flowTokens)

        // Destroy the withdrawn MyFungibleTokens or handle them as necessary
        destroy myFungibleTokens
    }
}
