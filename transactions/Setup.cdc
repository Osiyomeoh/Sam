import MyFungibleToken from 0x05 
import FlowToken from 0x05 
import FungibleToken from 0x05

transaction {

    prepare(signer: AuthAccount) {
        // Setup for MyFungibleToken Vault
        if signer.borrow<&MyFungibleToken.Vault>(from: /storage/MyFungibleTokenVault) == nil {
            log("No existing MyFungibleToken Vault found. Creating a new Vault.")
            let newMyFungibleTokenVault <- MyFungibleToken.createEmptyVault()
            signer.save(<-newMyFungibleTokenVault, to: /storage/MyFungibleTokenVault)
        } else {
            log("A MyFungibleToken Vault already exists.")
        }

        // Link public capabilities for MyFungibleToken
        signer.link<&MyFungibleToken.Vault{FungibleToken.Receiver, FungibleToken.Provider}>(
            /public/MyFungibleTokenReceiver,
            target: /storage/MyFungibleTokenVault
        )
        signer.link<&MyFungibleToken.Vault{FungibleToken.Balance}>(
            /public/MyFungibleTokenBalance,
            target: /storage/MyFungibleTokenVault
        )

        // Setup for FlowToken Vault
        if signer.borrow<&FlowToken.Vault>(from: /storage/FlowTokenVault) == nil {
            log("No existing FlowToken Vault found. Creating a new Vault.")
            let newFlowTokenVault <- FlowToken.createEmptyVault()
            signer.save(<-newFlowTokenVault, to: /storage/FlowTokenVault)
        } else {
            log("A FlowToken Vault already exists.")
        }

        // Link public capabilities for FlowToken
        signer.link<&FlowToken.Vault{FungibleToken.Receiver, FungibleToken.Provider}>(
            /public/FlowTokenReceiver,
            target: /storage/FlowTokenVault
        )
        signer.link<&FlowToken.Vault{FungibleToken.Balance}>(
            /public/FlowTokenBalance,
            target: /storage/FlowTokenVault
        )

        log("Public capabilities for FlowToken created or updated.")
    }

    execute {
        log("Vault setup or corrected for MyFungibleToken and FlowToken.")
    }
}
