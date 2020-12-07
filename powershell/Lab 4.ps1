function diskInfo{$diskdrives = Get-CIMInstance CIM_diskdrive
    $diskinfo = foreach ($disk in $diskdrives) { 
        $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition 
        foreach ($partition in $partitions) { 
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk 
            foreach ($logicaldisk in $logicaldisks) { 
                new-object -typename psobject -property @{ Drive=$logicaldisk.deviceid; 
                                                           Vendor=$disk.Manufacturer; 
                                                           Model=$disk.model; 
                                                           “Size(GB)”="{0:N2}" -f ($partition.size / 1gb); 
                                                           "Free Space(GB)"= "{0:N2}" -f (($logicaldisk.freespace) / 1gb)
                                                           "Space Uasge(%)" = "{0:N2}" -f (($logicaldisk.size-$logicaldisk.freespace) * 100 / $logicaldisk.size)
                                                          }}}}}

function Hdware_info {

Get-WmiObject win32_computersystem | Select Model, Manufacturer | fl

}

function os_info {

Get-WmiObject win32_operatingsystem | Select Name, Version | fl

}

function cpu_info{

Get-WmiObject win32_processor | Select NumberOfCores, MaxClockSpeed, @{n="L1 Cache Size";e={$_.L1CacheSize -as [int]}},@{n="L2 Cache Size";e={$_.L2CacheSize -as [int]}}, @{n="L3 Cache Size";e={$_.L3CacheSize -as [int]}}| fl

}
function ram_info{

Get-WmiObject win32_physicalmemory | Select Manufacture, Description,@{n= "Size(GB)" ; e={$_.Capacity / 1GB -as [int]}}, @{n="Bank";e={$_.BankLabel}} | ft -AutoSize  

}

function Disk_info {

Get-WmiObject win32_physicalmemory | Select Manufacture, Description,@{n= "Size(GB)" ; e={$_.Capacity / 1GB -as [int]}}, @{n="Bank";e={$_.BankLabel}} | ft -AutoSize  

}

function net_info {

get-ciminstance win32_networkadapterconfiguration | Where-Object {$_.IPEnabled -eq $True} | Select description, index, ipaddress, ipsubnet, dnsdomain, DnsServerSearchorder| Format-Table -AutoSize}


function video_card {
get-ciminstance win32_videocontroller | Select @{n= "Manufacturer Name" ;e = {$_.AdapterCompatibility}} , Description ,@{n= "Display Resolution "; e = {($_.CurrentHorizontalResolution.toString()) +" X " + ($_.CurrentVerticalResolution.toString())}} | fl
}
"Hardware Info >>> "

Hdware_info 

"______________________________________________________________________________________________ "

"Operating System Info >>> "

os_info
"______________________________________________________________________________________________ "

"Processor Info >>> "

cpu_info
"______________________________________________________________________________________________ "
" RAM Info >>> "
ram_info

"________________________________________________________________________________________________"
"Disk Info >>>"
                                                         
Disk_info  

"________________________________________________________________________________________________"
"NetWork Adapter >>> "

 net_info
"_________________________________________________________________________________________________"

"Video Card >>>"

video_card