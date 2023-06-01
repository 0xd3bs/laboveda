// taken from : https://github.com/enitrat/cairo1-mocha/blob/7401f1ab0d88a3e7e9e76ef1ad567c43618f30f7/src/vault.cairo

use starknet::ContractAddress;

#[abi]
trait IBoveda {
    fn deposit(amount: u256);
    fn withdraw(shares: u256);
    fn balance_of(account: ContractAddress) -> u256;
    fn total_supply() -> u256;
    fn tokens_owner() -> ContractAddress;
}

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
mod Boveda {
    use super::IERC20DispatcherTrait;
    use super::IERC20Dispatcher;
    use super::IERC20LibraryDispatcher;

    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::get_contract_address;
    use traits::Into;

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
            amount * _total_supply::read() / _erc20_dispatcher().balance_of(get_contract_address())
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
        let amount: u256 = (shares * _erc20_dispatcher().balance_of(get_contract_address()))
            / _total_supply::read();
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