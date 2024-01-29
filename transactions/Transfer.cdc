import MyFungibleToken from 0x05
import FungibleToken from 0x05

transaction(recipient: Address, amount: UFix64) {

    let senderVaultRef: &MyFungibleToken.Vault

    prepare(signer: AuthAccount) {
        self.senderVaultRef = signer.borrow<&MyFungibleToken.Vault>(from: /storage/MyFungibleTokenVault)
            ?? panic("Failed to borrow reference to the sender's vault")
    }

    execute {
        let recipientAccount = getAccount(recipient)
        let recipientVaultRef = recipientAccount.getCapability(/public/MyFungibleTokenReceiver)
                                .borrow<&{FungibleToken.Receiver}>()
                                ?? panic("Could not borrow recipient's vault reference")

        let withdrawnVault <- self.senderVaultRef.withdraw(amount: amount)
        recipientVaultRef.deposit(from: <-withdrawnVault)
    }
}
