import FlowToken from 0x05 

transaction(amount: UFix64) {
    // Local variable to store the borrowed Minter reference
    let minter: &FlowToken.Minter

    // Local variable to store the borrowed Admin's Vault reference
    let adminVaultRef: &FlowToken.Vault

    prepare(signer: AuthAccount) {
        // Borrow a reference to the Minter and store it
        self.minter = signer.borrow<&FlowToken.Minter>(from: /storage/FlowTokenMinter)
            ?? panic("Could not borrow reference to the minter")

        // Borrow a reference to the Admin's FlowToken Vault and store it
        self.adminVaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/FlowTokenVault)
            ?? panic("Could not borrow reference to the Admin's FlowToken Vault")
    }

    execute {
        // Mint tokens using the stored Minter reference
        let mintedTokens <- self.minter.mintToken(amount: amount)

        // Deposit the minted tokens into the Admin's Vault using the stored reference
        self.adminVaultRef.deposit(from: <- mintedTokens)
    }
}
