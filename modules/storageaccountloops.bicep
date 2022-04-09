param storageaccountName string
param location string
param sku string
param kind string

// Create Storage Account
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-08-01' = [for i in range(0,3): {
  name: '${storageaccountName}${i}'
  location: location
  sku: {
    name: sku
  }
  kind: kind 
}]

output storageaccount array = [for i in range(0,3): {
  name: storageaccount[i].name
  resourceid: storageaccount[i].id
}]
