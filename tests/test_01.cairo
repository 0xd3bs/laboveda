use laboveda::BOVEDA::BOVEDA;
use starknet::contract_address_const;
use starknet::ContractAddress;
use starknet::testing::set_caller_address;
use integer::u256;
use integer::u256_from_felt252;
use debug::PrintTrait;

const NAME: felt252 = 'DB NAME';
const SYMBOL: felt252 = 'DBS';

// Helper function
fn setup() -> ContractAddress {
    let contract_ERC20: ContractAddress = contract_address_const::<0x04e145f982a34800a64cf301e20e6a29ea38f759abc93247622209dce82edf81>();
    let account: ContractAddress = contract_address_const::<1>();

    // Set account as default caller
    //set_caller_address(account);

    //BOVEDA::constructor(contract_ERC20);

    (contract_ERC20)
}

// Testing
#[test]
#[available_gas(2000000)]
fn test_deposit() {
    //let contract_ERC20: ContractAddress = setup();
    //let amount: u256 = u256_from_felt252(100);

    //let depositor: ContractAddress = contract_address_const::<3>();
    //set_caller_address(depositor);
    //BOVEDA::deposit(amount);

    //assert(BOVEDA::balance_of(depositor) == amount, 'Balance should eq amount');
    //assert(BOVEDA::total_supply() == BOVEDA::total_supply() - amount, 'Total supply should not change');
}

// Testing
#[test]
#[available_gas(2000000)]
fn test_withdraw() {
    //let contract_ERC20: ContractAddress = setup();
    //let amount: u256 = u256_from_felt252(100);

    //let withdrawer: ContractAddress = contract_address_const::<4>();
    //set_caller_address(withdrawer);
    //BOVEDA::withdraw(amount);

    //assert(BOVEDA::balance_of(withdrawer) == amount, 'Balance should eq amount');
    //assert(BOVEDA::total_supply() == BOVEDA::total_supply() - amount, 'Total supply should not change');
}