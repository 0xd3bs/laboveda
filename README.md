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

### El ERC20 que utiliza la bóveda corresponde a:
```bash
Contract address: 0x04e145f982a34800a64cf301e20e6a29ea38f759abc93247622209dce82edf81
Transaction hash: 0x3f58e47463b0e84b9108e3e45578397266cb1ba2e739398feb41b4f295c9ba0
```


### Al compilar con scarb build si bien generaba el .sierra.json sin problemas al intentar declarar el contrato se generaba el siguiente error:
```bash
Error: StarkException: (500, {'code': <StarknetErrorCode.COMPILATION_FAILED: 3>, 'message': "Compilation failed. Error: Libfunc u256_safe_divmod is not allowed in the libfuncs list '/home/debs/cairo_venv/lib/python3.9/site-packages/starkware/starknet/compiler/v1/testnet_libfuncs.json'.\n Run with '--allowed-libfuncs-list-name experimental_v0.1.0' to allow all libfuncs.\n"})
```

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
```bash
Error: StarkException: (500, {'code': <StarknetErrorCode.COMPILATION_FAILED: 3>, 'message': 'Compilation failed. Error: Invalid Sierra program.\n'})
```

### Declaración & Despliegue

```bash
declare --contract target/dev/basecamp_es_final_ERC20.sierra.json --account version_1077_test
```

#### Al declarar con el compilado generado por starknet-compile genera el siguiente error:
```bash
Error: StarkException: (500, {'code': <StarknetErrorCode.COMPILATION_FAILED: 3>, 'message': 'Compilation failed. Error: Invalid Sierra program.\n'})
```

### Versión operativa del contrato que no incluye
```bash
--allowed-libfuncs-list-name experimental_v0.1.0
```

### Template
```bash
starknet deploy --class_hash <> --inputs <> --account version_1077_test
```

```bash
starknet declare --contract target/dev/laboveda_BOVEDA.sierra.json --account version_1077_test

Sending the transaction with max_fee: 0.000022 ETH (21676123269686 WEI).
Declare transaction was sent.
Contract class hash: 0x314a448246e23af87e526529e9d5b8086e04d94cefdb03f688a381db6a83661
Transaction hash: 0x4877eb8e43e6bd727dd2e6f307a111ecad7fc6618963336688504fc22f875a0
```

### Template
```bash
starknet deploy --class_hash <> --inputs <> --account version_1077_test
```

```bash
starknet deploy --class_hash 0x314a448246e23af87e526529e9d5b8086e04d94cefdb03f688a381db6a83661 --inputs 0x04e145f982a34800a64cf301e20e6a29ea38f759abc93247622209dce82edf81 --account version_1077_test

Sending the transaction with max_fee: 0.000077 ETH (76700858605602 WEI).
Invoke transaction for contract deployment was sent.
Contract address: 0x03589cf235b136e84dd1ce0fd612f130f2d135b764b74be9fc8fc32118a869d8
Transaction hash: 0x7f6b8d4d59b88b6aca88fd92192e7a8f285c6756fb771010506ad94fa94f319
```