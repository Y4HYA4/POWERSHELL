$demosubnetConfig = New-AzVirtualNetworkSubnetConfig -Name default -AddressPrefix 10.3.0.0/24


$vnet = New-AzVirtualNetwork -ResourceGroupName eastgroup -Location EastUS -Name demonetworknew -AddressPrefix 10.3.0.0/16 -Subnet $demosubnetConfig



$demoip = New-AzPublicIpAddress -ResourceGroupName eastgroup -Location EastUS -Name "demo-ip" -AllocationMethod Dynamic


$RuleConfig = New-AzNetworkSecurityRuleConfig -Name RuleRDP -Protocol Tcp -Direction Inbound -Priority 300 -SourceAddressPrefix "2.49.112.48" -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow


$securitygroup = New-AzNetworkSecurityGroup -ResourceGroupName eastgroup -Location EastUS -Name demonsg -SecurityRules $RuleConfig


$nic = New-AzNetworkInterface -Name demonetworkcard123 -ResourceGroupName eastgroup -Location EastUS -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $demoip.Id -NetworkSecurityGroupId $securitygroup.Id

$cred = Get-Credential


$vmConfig = New-AzVMConfig -VMName demovm -VMSize Standard_D2s_v3 | Set-AzVMOperatingSystem -Windows -ComputerName demovm -Credential $cred | Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest | Add-AzVMNetworkInterface -Id $nic.Id


New-AzVM -ResourceGroupName eastgroup -Location EastUS -VM $vmConfig

