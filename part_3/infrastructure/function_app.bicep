param existingStorageAccountName string
param existingApplicationInsightsName string

param shortName string
var functionAppName = '${shortName}-workshop-function-app'

// Reference to existing resources
resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: existingStorageAccountName
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: existingApplicationInsightsName
}

// App service plan created per function app because it is consumption plan
module appServicePlan 'br/public:avm/res/web/serverfarm:0.2.3' = {
  name: '${uniqueString(deployment().name)}-${shortName}-asp'
  scope: resourceGroup()
  params: {
    name: '${shortName}-workshop-asp'
    skuName: 'Y1'
    kind: 'Linux'
    reserved: true
  }
}

module functionApp 'br/public:avm/res/web/site:0.9.0' = {
  name: '${uniqueString(deployment().name)}-${shortName}'
  scope: resourceGroup()
  params: {
    kind: 'functionapp,linux'
    name: functionAppName
    appInsightResourceId: applicationInsights.id
    storageAccountResourceId: existingStorageAccount.id
    serverFarmResourceId: appServicePlan.outputs.resourceId
    siteConfig: {
      httpsOnly: true
    }
    appSettingsKeyValuePairs: {
      AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${existingStorageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${existingStorageAccount.listKeys().keys[0].value}'
      WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=${existingStorageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${existingStorageAccount.listKeys().keys[0].value}'
      WEBSITE_CONTENTSHARE: toLower(functionAppName)
      FUNCTIONS_EXTENSION_VERSION: '~4'
      WEBSITE_NODE_DEFAULT_VERSION: '~14'
      FUNCTIONS_WORKER_RUNTIME: 'python'
    }
    diagnosticSettings: [
      {
        workspaceResourceId: applicationInsights.properties.WorkspaceResourceId
        storageAccountResourceId: existingStorageAccount.id
        logCategoriesAndGroups: [
          {
            category: 'FunctionAppLogs'
          }
        ]
      }
    ]
  }
}
