$env:path += "C:\Users\praveen\Documents\GitHub\COMP2101\powershell"

new-item -path alias:np -value notepad | out-null

function welcome {
write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."
}

function get-cpuinfo {
get-ciminstance cim_processor |Select-Object name ,model,manufacturer,currentclockspeed,maxclockspeed,numberofcores
}

function get-mydisks {
get-disk | Select-object FriendlyName ,Manufacturer , Size
}
welcome
get-cpuinfo 