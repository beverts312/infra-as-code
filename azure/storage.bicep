// from https://github.com/Azure/bicep/blob/main/docs/tutorial/04-using-symbolic-resource-name.md
param location string = resourceGroup().location
param namePrefix string

param globalRedundancy bool = true

var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  kind: 'Storage'
  sku: {
    name: globalRedundancy ? 'Standard_GRS' : 'Standard_LRS'
  }
}

resource blob 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccount.name}/default/logs'
}

output storageId string = storageAccount.id
