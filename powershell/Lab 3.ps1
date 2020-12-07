get-ciminstance win32_networkadapterconfiguration -Filter ipenabled=true | Select description, index, ipaddress, ipsubnet, dnsdomain, DnsServerSearchorder| Format-Table -AutoSize
