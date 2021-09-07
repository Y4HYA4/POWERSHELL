$vm = Get-AzVM -ResourceGroupName azuredemo -VMName newvm

$vm.HardwareProfile.VmSize ="Standard_DS1_v2"

Update-AzVM -VM $vm -ResourceGroupName azuredemo
