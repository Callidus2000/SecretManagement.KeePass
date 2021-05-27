function Unlock-SecretVault {
    param (
        [Parameter(Mandatory)][SecureString]$Password,
        [Parameter(Mandatory)][Alias('Vault')][Alias('Name')][String]$VaultName,
        [Alias('VaultParameters')][hashtable]$AdditionalParameters
    )

    $vault = Get-SecretVault -Name $vaultName -ErrorAction Stop
    $vaultName = $vault.Name
    if ($vault.ModuleName -ne 'SecretManagement.KeePass') {throw "$vaultName was found but is not a Keepass Vault."}
    Set-Variable -Name "Vault_${vaultName}_MasterPassword" -Scope Script -Value $Password -Force
    #Force a reconnection
    Remove-Variable -Name "Vault_${vaultName}" -Scope Script -Force -ErrorAction SilentlyContinue
    if (-not (Test-SecretVault -Name $vaultName -AdditionalParameters $AdditionalParameters)) { throw "${vaultName}: Failed to unlock the vault" }
}