# Starknet Basecamp ES

Basado en https://github.com/enitrat/cairo1-mocha/blob/7401f1ab0d88a3e7e9e76ef1ad567c43618f30f7/src/vault.cairo para el despliegue de esta versión personalizada de un Vault.


## Use Starknet testnet
```bash
export STARKNET_NETWORK=alpha-goerli
```

## Set the default wallet implementation to be used by the CLI 
```bash
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
```

## El ERC20 que utiliza la bóveda corresponde a:
### Contract address: 0x04e145f982a34800a64cf301e20e6a29ea38f759abc93247622209dce82edf81
### Transaction hash: 0x3f58e47463b0e84b9108e3e45578397266cb1ba2e739398feb41b4f295c9ba0


## Al compilar con scarb build si bien generaba el .sierra.json sin problemas al intentar declarar el contrato se generaba el siguiente error:
### Error: StarkException: (500, {'code': <StarknetErrorCode.COMPILATION_FAILED: 3>, 'message': "Compilation failed. Error: Libfunc u256_safe_divmod is not allowed in the libfuncs list '/home/debs/cairo_venv/lib/python3.9/site-packages/starkware/starknet/compiler/v1/testnet_libfuncs.json'.\n Run with '--allowed-libfuncs-list-name experimental_v0.1.0' to allow all libfuncs.\n"})

### Luego al intentar compilar con
```bash
starknet-compile src/boveda.cairo compilado/boveda.sierra.json --
allowed-libfuncs-list-name experimental_v0.1.0
```


### es quivalente a ejecutar:
```bash
cargo run --bin starknet-compile /home/debs/starknet/laboveda/src/boveda.cairo /home/debs/starknet/laboveda/outputs/boveda.sierra.json --allowed-libfuncs-list-name experimental_v0.1.0
IMPORTANTE: Previo a esto se debe hacer cd ~/.cargo/
```

### Al intentar declarar con el compilado generado por cargo run genera el suguiente error:
Error: StarkException: (500, {'code': <StarknetErrorCode.COMPILATION_FAILED: 3>, 'message': 'Compilation failed. Error: Invalid Sierra program.\n'})

## Declaración & Despliegue
```bash
starknet declare --contract target/dev/<TODO>.sierra.json --account version_1077_test
```

Al declarar con el compilado generado por starknet-compile genera el siguiente error:
Al ejecutar me dio este error:
Error: StarkException: (500, {'code': <StarknetErrorCode.COMPILATION_FAILED: 3>, 'message': 'Compilation failed. Error: Invalid Sierra program.\n'})

```bash
starknet deploy --class_hash <TODO> --inputs <TODO> --account version_1077_test
```