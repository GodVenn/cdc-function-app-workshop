using 'function_app.bicep'

param existingApplicationInsightsName = 'cdc-func-workshop-appi'
param existingStorageAccountName = 'cdcfuncworkshopst'
param existingKeyVaultName = 'cdc-func-workshop-kv'
param existingManagedIdentityName = 'cdc-func-workshop-id'

param shortName = '<your-shortname>'
param apiKeySecretName = 'STUFF-API-KEY'
