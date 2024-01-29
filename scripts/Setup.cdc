import MyFungibleToken from 0x05
import FungibleToken from 0x05
pub fun main(account: Address): Bool {
    return getAccount(account).getCapability<&MyFungibleToken.Vault{FungibleToken.Balance}>(
        /public/MyFungibleTokenBalance
    ).check()
}
