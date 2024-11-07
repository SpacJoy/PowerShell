$vm = "win10"
# 查看
Get-VMGpuPartitionAdapter -VMName $vm

# 获取可分区的GPU列表
# Get-VMHostPartitionableGpu

#4060:\\?\PCI#VEN_10DE&DEV_28A0
#\\?\PCI#VEN_10DE&DEV_28A0&SUBSYS_128A1D05&REV_A1#4&2986c445&0&0009#{064092b3-625e-43bf-9eb5-dc845897dd59}\GPUPARAV

<# 其他方法
# 指定GPU分区并分配给虚拟机
$gpupath = "\\?\PCI#VEN_10DE&DEV_28A0&SUBSYS_128A1D05&REV_A1#4&2986c445&0&0009#{064092b3-625e-43bf-9eb5-dc845897dd59}\GPUPARAV"
Add-VMGpuPartitionAdapter -VMName $vm -InstancePath $gpupath

# 添加
#Add-VMGpuPartitionAdapter -VMName $vm
Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionVRAM 80000000 -MaxPartitionVRAM 100000000 -OptimalPartitionVRAM 100000000 -MinPartitionEncode 80000000 -MaxPartitionEncode 100000000 -OptimalPartitionEncode 100000000 -MinPartitionDecode 80000000 -MaxPartitionDecode 100000000 -OptimalPartitionDecode 100000000 -MinPartitionCompute 80000000 -MaxPartitionCompute 100000000 -OptimalPartitionCompute 100000000
Set-VM -GuestControlledCacheTypes $true -VMName $vm
Set-VM -LowMemoryMappedIoSpace 1Gb -VMName $vm
Set-VM -HighMemoryMappedIoSpace 32GB -VMName $vm

# 删除
Remove-VMGpuPartitionAdapter -VMName $vm
#>