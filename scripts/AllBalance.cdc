import FungibleToken from 0x05 
import FlowToken from 0x05
import MyFungibleToken from 0x05

pub fun main(accountAddress: Address): [{String: AnyStruct}] {
    let account = getAccount(accountAddress)
    var tokenVaults: [{String: AnyStruct}] = []

    // Define the public paths to the token vault balances
    let paths: [PublicPath] = [
        /public/FlowTokenBalance,
        /public/MyFungibleTokenBalance

    ]

    // Iterate over each public path to access the vault balances
    for path in paths {
        // Use getCapability with PublicPath to fetch the capability
        let capability = account.getCapability<&{FungibleToken.Balance}>(path)

        // Attempt to borrow a reference from the capability
        if let vaultRef = capability.borrow() {
            // Construct the vault information dictionary
            let vaultInfo: {String: AnyStruct} = {
                "type": vaultRef.getType().identifier, 
                "balance": vaultRef.balance,
                "path": path.toString() 
            }

            // Add the constructed information to the array of vaults
            tokenVaults.append(vaultInfo)
        }
    }

    return tokenVaults
}
