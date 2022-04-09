param storageaccountName string
param blobcontainerName string


resource storageaccount 'Microsoft.Storage/storageAccounts@2021-08-01' existing = {
  name: storageaccountName
}

// Create blob services
resource blobservices 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01' = {
  name: 'default'
  parent: storageaccount
}

//Create Blob Container
resource blobcontainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: blobcontainerName
  parent: blobservices
}
