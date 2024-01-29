import Swap from 0x05 
import FlowToken from 0x05 

transaction(amount: UFix64) {
    // Local variables to store the resources and references
    var payment: @FlowToken.Vault?
    var identity: @Swap.Identity?

    prepare(signer: AuthAccount) {
        // Create and save the Identity resource if it doesn't exist
        if signer.borrow<&Swap.Identity>(from: /storage/identityPath) == nil {
            let identityResource <- Swap.createIdentity(ownerId: signer.address)
            signer.save(<-identityResource, to: /storage/identityPath)
            signer.link<&Swap.Identity{Swap.IdentityPublic}>(/public/identityPath, target: /storage/identityPath)
        }

        // Borrow a reference to the signer's FlowToken.Vault and withdraw tokens
        let vaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/FlowTokenVault)
            ?? panic("Could not borrow reference to the FlowToken.Vault")
        self.payment  <- vaultRef.withdraw(amount: amount)

        // Load the Identity resource from storage
        self.identity <- signer.load<@Swap.Identity>(from: /storage/identityPath)
            ?? panic("Could not load the Identity resource")
    }

    execute {
    // Check if 'payment' is not nil
    if self.payment != nil {
        // Check if 'identity' is not nil
        if self.identity != nil {
            // Force-unwrap 'payment' and 'identity' since we've checked they are not nil
            let payment <- self.payment!
            let identity <- self.identity!

            // Execute the swap with the unwrapped resources
            Swap.swapWithIdentity(identity: <- identity, payment: <- payment)
            log("Swapped $FLOW for custom tokens using Identity.")
        } else {
            panic("Identity resource is missing.")
        }
    } else {
        panic("Payment resource is missing.")
    }
}

}
