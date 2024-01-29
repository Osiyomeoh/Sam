import MyFungibleToken from 0x05
import FungibleToken from 0x05

transaction(recipient: Address, amount: UFix64) {

    let minter: &MyFungibleToken.Minter

    prepare(signer: AuthAccount) {
        self.minter = signer.borrow<&MyFungibleToken.Minter>(from: /storage/MyFungibleTokenMinter)
            ?? panic("Could not borrow a reference to the minter")
    }

    execute {
        let recipientAccount = getAccount(recipient)
        let recipientVault = recipientAccount.getCapability(/public/MyFungibleTokenReceiver)
                               .borrow<&{FungibleToken.Receiver}>()
                               ?? panic("Could not borrow recipient's vault reference")

        let mintedVault <- self.minter.mintToken(amount: amount)
        recipientVault.deposit(from: <-mintedVault)
    }
}
