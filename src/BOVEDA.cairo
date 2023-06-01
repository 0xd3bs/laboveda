// taken from : https://github.com/enitrat/cairo1-mocha/blob/7401f1ab0d88a3e7e9e76ef1ad567c43618f30f7/src/vault.cairo

use starknet::ContractAddress;

#[abi]
trait IERC20 {
    #[view]
    fn name() -> felt252;

    #[view]
    fn symbol() -> felt252;

    #[view]
    fn decimals() -> u8;

    #[view]
    fn total_supply() -> u256;
    
    #[view]
    fn who_is_owner() -> ContractAddress;

    #[view]
    fn balance_of(account: ContractAddress) -> u256;

    #[view]
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;

    #[external]
    fn transfer(recipient: ContractAddress, amount: u256) -> bool;

    #[external]
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;

    #[external]
    fn approve(spender: ContractAddress, amount: u256) -> bool;

    #[external]
    fn burn(account: ContractAddress, amount: u256) -> bool;

    #[external]
    fn burn_by_owner(amount: u256) -> bool;
}

#[contract]
mod BOVEDA {
    use super::IERC20DispatcherTrait;
    use super::IERC20Dispatcher;
    use super::IERC20LibraryDispatcher;

    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::get_contract_address;
    use traits::Into;
    use debug::PrintTrait;

    struct Storage {
        _token: ContractAddress,
        _total_supply: u256,
        _balances: LegacyMap<ContractAddress, u256>,
    }

    #[constructor]
    fn constructor(token: ContractAddress) {
        _token::write(token)
    }

    #[external]
    fn deposit(amount: u256) {
        // a = amount
        // B = balance of token before deposit
        // T = total supply
        // s = shares to mint

        // (T + s) / T = (a + B) / B

        // s = aT / B

        let shares = if _total_supply::read() == 0.into() {
            amount
        } else {
            //amount * _total_supply::read() / _erc20_dispatcher().balance_of(get_contract_address())
            amount
        };

        _mint(get_caller_address(), shares);
        _erc20_dispatcher().transfer_from(get_caller_address(), get_contract_address(), amount);
    }

    #[external]
    fn withdraw(shares: u256) {
        // a = amount
        // B = balance of token before withdraw
        // T = total supply
        // s = shares to burn

        // (T - s) / T = (B - a) / B

        // a = sB / T
        //let amount: u256 = (shares * _erc20_dispatcher().balance_of(get_contract_address()))
        //    / _total_supply::read();

        let amount: u256 = shares;

        _burn(get_caller_address(), shares);
        _erc20_dispatcher().transfer(get_caller_address(), amount);
    }

    #[view]
    fn balance_of(account: ContractAddress) -> u256 {
        _balances::read(account)
    }

    #[view]
    fn total_supply() -> u256 {
        _total_supply::read()
    }

    #[view]
    fn tokens_owner() -> ContractAddress {        
        _erc20_dispatcher().who_is_owner()
    }

    #[view]
    fn tokens_name_symbol() -> felt252 {
        _erc20_dispatcher().name()
    }    

    fn _mint(to: ContractAddress, shares: u256) {
        _total_supply::write(_total_supply::read() + shares);
        _balances::write(to, _balances::read(to) + shares);
    }

    fn _burn(from: ContractAddress, shares: u256) {
        _total_supply::write(_total_supply::read() - shares);
        _balances::write(from, _balances::read(from) - shares);
    }

    fn _erc20_dispatcher() -> IERC20Dispatcher {
        IERC20Dispatcher { contract_address: _token::read() }
    }
}

#[cfg(test)]
mod tests{
 
    use integer::u256;
    use integer::u256_from_felt252;
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use super::BOVEDA;

    const NAME: felt252 = 'DB NAME';
    const SYMBOL: felt252 = 'DBS';

    #[test]
    #[available_gas(2000000)]
    fn test_01_constructor(){
        let contract_ERC20: ContractAddress = contract_address_const::<0x04e145f982a34800a64cf301e20e6a29ea38f759abc93247622209dce82edf81>();
        let account: ContractAddress = contract_address_const::<1>();

        BOVEDA::constructor(contract_ERC20);
        
        let res_name = BOVEDA::tokens_name_symbol();
        assert(res_name == NAME, 'Name does not match.');

    }
}