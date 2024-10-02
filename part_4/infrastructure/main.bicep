param keyVaultName string
param managedIdentityName string
param logAnalyticsWorkspaceName string
param applicationInsightsName string
@maxLength(24)
@minLength(3)
@description('Lowercase letters and numbers ONLY (will be transformed to lowercase)')
param storageAccountName string
//

module runtimeManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.3.0' = {
  name: '${uniqueString(deployment().name)}-runtime-Identity'
  scope: resourceGroup()
  params: {
    name: managedIdentityName
  }
}

module appStorage 'br/public:avm/res/storage/storage-account:0.13.3' = {
  name: '${uniqueString(deployment().name)}-storage'
  scope: resourceGroup()
  params: {
    name: toLower(storageAccountName)
    skuName: 'Standard_LRS'
    diagnosticSettings: [
      {
        workspaceResourceId: modLogAnalyticsWorkspace.outputs.resourceId
      }
    ]
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices, Logging, Metrics'
    }
  }
}

module modLogAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.3.0' = {
  name: '${uniqueString(deployment().name)}-logAnalyticsWorkspace'
  params: {
    name: logAnalyticsWorkspaceName
    dataRetention: 30
    managedIdentities: {
      userAssignedResourceIds: [
        '${runtimeManagedIdentity.outputs.resourceId}'
      ]
    }
    skuName: 'PerGB2018'
  }
}

module applicationInsights 'br/public:avm/res/insights/component:0.1.2' = {
  name: '${uniqueString(deployment().name)}-applicationInsights'
  params: {
    name: applicationInsightsName
    workspaceResourceId: modLogAnalyticsWorkspace.outputs.resourceId
  }
}

module modKeyVault 'br/public:avm/res/key-vault/vault:0.3.4' = {
  name: '${uniqueString(deployment().name)}-keyVault'
  params: {
    name: keyVaultName
    enableTelemetry: true
    enableRbacAuthorization: true
    privateEndpoints: null
    diagnosticSettings: [
      {
        workspaceResourceId: modLogAnalyticsWorkspace.outputs.resourceId
      }
    ]
    roleAssignments: [
      {
        principalId: runtimeManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: subscriptionResourceId(
          'Microsoft.Authorization/roleDefinitions',
          '4633458b-17de-408a-b874-0445c86b69e6'
        ) // Key Vault Secrets User
        principalType: 'ServicePrincipal'
        description: 'Runtime Managed Identity read secrets access to KeyVault'
      }
    ]
  }
}
