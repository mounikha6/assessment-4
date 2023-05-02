targetScope = 'resourceGroup'
resource VirtualNetwork 'Microsoft.Network/virtualNetworks@2022-09-01'= { 
  name: 'BICEP-Vnet'
  location: string('eastus')
  properties:{
    addressSpace:{
      addressPrefixes:{
       '172.16.0.0/16'
      }
    }
  }
}
resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' = {
  name: '/BICEP-Subnet1'
  properties:{
    addressPrefixes:{
      '172.16.0.0/24'
    } 
  }
}
resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' = {
  name : '/BICEP-Subnet2'
  properties:{
    addressPrefixes:{
      '172.16.1.0/24'
    }
  }
}
resource networkinterface1 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: 'BICEP-NETINT1'
  location: string('eastus')
  dependsOn:[VirtualNetwork] 
  properties:{
    ipConfigurations:[
      {
        name: 'BICEP-ipconfig'
        properties:{
          subnet:{
            id: [concat(resourceId('microsoft.network/virtualNetworks','BICEP-Vnet')):VirtualNetwork]
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}
{
  resource Virtualmachines 'Microsoft.Compute/virtualMachines@2022-11-01' = {
    name: 'BICEP-Vm1'
    location: string('eastus')
    dependsOn:[
      (VirtualNetwork)
      (networkinterface1)
    ]
  properties:{
    hardwareProfile:{
      vmSize:'Standard_DS1_v2'
    }
    storageProfile:{
      imageReference:{
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku:'2022-datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption:'FromImage'
      }
    }
    osProfile:{
      computerName:'BICEP-Vm1'
#disable-next-line adminusername-should-not-be-literal
      adminUsername:'mounikha'
      adminPassword:'bicepvm1@'
    }
    networkProfile:{
      networkInterfaces:[
        {
          id:('BICEP-NETINT1')
        }
      ]
    }
  }
  }
{
resource networkinterface2 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: 'BICEP-NETINT2'
  location:string('eastus')
  dependsOn:[
    (VirtualNetwork)
  ]
  properties:{
    ipConfigurations:[
      {
        name:'ipconfig1'
        properties:{
          subnet:{
            id:[concat(Virtualmachines'BICEP-Vnet'),'/subnets/subnet2']
          }
          privateIPAllocationMethod:'Dynamic'

        }
      }
    ]
  }
}{
  resource virtualmachine2 'Microsoft.Compute/virtualMachines@2022-11-01' = {
    name: 'BICEP-Vm2'
    location: string('eastus')
    dependsOn:[
      (VirtualNetwork)
      (networkinterface2)
    ]
    properties:{
      hardwareProfile:{
        vmSize:'Standard_D1_v2'
      }
      storageProfile:{
        imageReference:{
          publisher:'canonical'
          offer:'UbuntuServer'
          sku:'18.04-LTS'
          version:'latest'
        }
        osDisk:{
          createOption:'FromImage'
        }
      }
      osProfile:{
        computerName:'BICEP-Vm2'
#disable-next-line adminusername-should-not-be-literal
        adminUsername:'mounikha'
        adminPassword:'bicepvm2@'
      }
      networkProfile:{
        networkInterfaces:[
          {
            id:[resourceId('microsoft.network.networkinterfaces',networkinterface2)]
          }
        ]
      }
    }
  }
}
