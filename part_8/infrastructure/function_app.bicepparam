using 'function_app.bicep'

param existingApplicationInsightsName = 'cdc-func-workshop-appi'
param existingStorageAccountName = 'cdcfuncworkshopst'
param existingKeyVaultName = 'cdc-func-workshop-kv'
param existingManagedIdentityName = 'cdc-func-workshop-id'

param shortName = '<your-shortname>'
param apiKeySecretName = 'STUFF-API-KEY'

// cdc-function-app-workshop-app
var authorizationAppClientId = '1e5446b9-eeaf-41ee-a4f4-bf27067c34e8'
var tenantId = 'ddcbb446-9133-4dd3-812f-1b24bc4d762b'

param functionAppAuthSettings = {
  globalValidation: {
    requireAuthentication: true
    unauthenticatedClientAction: 'Return401'
  }
  httpSettings: {
    forwardProxy: {
      convention: 'NoProxy'
    }
    requireHttps: true
  }
  identityProviders: {
    azureActiveDirectory: {
      enabled: true
      login: {
        disableWWWAuthenticate: false
      }
      registration: {
        openIdIssuer: 'https://sts.windows.net/${tenantId}/v2.0'
        clientId: authorizationAppClientId
        clientSecretSettingName: 'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'
      }
      validation: {
        allowedAudiences: [
          'api://${authorizationAppClientId}'
        ]
      }
    }
  }
}
