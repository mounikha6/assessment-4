param location string = 'eastus'
param vnetName string = 'myVNet'
param subnet1Name string = 'subnet1'
param subnet2Name string = 'subnet2'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}
