#==================================================================================================================
#
# Type : Compliance Audit Script
# Tech : ESXi 5.5                                                                                                                       
# 
# READ ME: 
# The script require VMware.PowerCLI Module to run. To Install Follow
# 1) Check is module already installed  
# Get-Module VMware* -ListAvailable
# 2) Find module
# Find-Module -Name VMware.PowerCLI
# 3) Install the module
# Install-Module -Name VMware.PowerCLI -Scope CurrentUser
#
# =================================================================================================================

# collect Command Line Arguments (hostname only)

if ($args.count -gt 1) {
  write-host "Too Many Arguments Specified"
  write-host "Syntax:  audit-esxi hostname OR fqdn OR ipaddress"
  return
  }
if ($args.count -eq 0) {
  write-host "no target host specified - please specify IP or hostname"
  write-host "Syntax:  audit-esxi hostname OR fqdn OR ipaddress"
  return
  }
else {
  $h = $args[0] 
  }


# ===============================================================================================================

# Is the specified host reachable?

if(!(Test-Connection -Cn $h -BufferSize 16 -Count 1 -ea 0 -quiet))
  {
  write-host "Specified Host "$h" is not reachable, please check hostname or IP address"
  return
  }

$outfile = "Report-"+$h+"-ESXi.html"

# ===============================================================================================================

# Check Login

$retry = 1
while ($retry -eq 1) {

$vicreds = get-credential $null
$login = connect-viserver -server $h -credential $vicreds

if ($login.name.length -eq 0) {
    write-host "Login failed, please retry or press Ctrl-C to exit"
    # short pause gives the chance for Ctrl-C
    start-sleep 2
    }
else {
    write-host "Login Successful"
    $login | ft
    $retry=0
    }
}



# Get List of ESXi hosts from initial vSphere or ESXi connection
# ================================================================================================================

$esxhosts = get-vmhost -server $h

                                                                                      
# GLOBAL VARIABLES 
# =================================================================================================================

$h1 =  "<h1>"
$eh1 = "</h1>"
$h2 = "<h2>"
$eh2 = "</h2>"
$pre = "<pre>"
$epre = "</pre>"
$p = "<p>"
$b = "<b>"
$eb = "</b>"
$usecli = "<b> = Use ESXi CLI Script</b><p>"
$man = "<b> = Manual</b><p>" 

$compliant = "<font color=lime>COMPLIANT</font>"
$notcompliant = "<font color=red>NONCOMPLIANT</font>"
$results= "<b>Results:</b><p>"
$rawdata = "<b> --------------------------------------- </b><p>" 

$TableCSS = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
.odd  { background-color:#ffffff; }
.even { background-color:#dddddd; }
</style>
"@



# FUNCTION: Print section header for each check to output file
# ================================================================================================================

function Print-Header
{
param ( [string]$sectionname )
out-file -filepath $outfile -inputobject $epre -append
# Progress Bar
# write-host -nonewline "."
write-host "Check Completed: ",$sectionname
}


# FUNCTION: Fix HTML Converted text back to tags
# =================================================================================================================

function fixhtml
{
param ( [string]$htmlcode)

$htmlcode = $htmlcode -replace "&lt;font color=lime&gt;COMPLIANT&lt;/font&gt;" , "<font color=lime>COMPLIANT</font>"
$htmlcode = $htmlcode -replace "&lt;font color=red&gt;NONCOMPLIANT&lt;/font&gt;" , "<font color=red>NONCOMPLIANT</font>"
$htmlcode = $htmlcode -replace "&lt;pre;&gt;" , "<pre>"
$htmlcode = $htmlcode -replace "&lt;/pre;&gt" , "</pre>"
$htmlcode = $htmlcode -replace "&lt;br;&gt" , "<br>"
$htmlcode = $htmlcode -replace "&lt;/br;&gt" , "</br>"

$htmlcode
}



# FUNCTION: MD5SUM a file
# =================================================================================================================

function md5sum
{
param ( [string]$filespec)

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($Filespec)))
return $hash
}



# FUNCTION: SHA1SUM a file                          
# ================================================================================================================

function sha1sum
{
param ( [string]$filespec)

$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider
$hash = [System.BitConverter]::ToString( $sha1.ComputeHash([System.IO.File]::ReadAllBytes($filespec)))
return $hash
}


# TITLE                                                                                                                                                      
# ================================================================================================================

# out-file -filepath $outfile -inputobject $pre
out-file -filepath $outfile -inputobject "<title>ESXi 5.5 Audit Report - ",$h," </title>"
out-file -filepath $outfile -inputobject $h1, "ESXi 5.5 Compliance Audit - ESXi Hosts",$eh1,$br -append

out-file -filepath $outfile -inputobject "XXXXX",$p -append

out-file -filepath $outfile -inputobject $h2, "Target Host: ", $h, $eh2 ,$p -append

out-file -filepath $outfile -inputobject (get-date) -append
out-file -filepath $outfile -inputobject $p,"<b>ESXi Host:</b>" -append

out-file -filepath $outfile -inputobject ($esxhosts |Select Name, ConnectionState, PowerState `
       | Convertto-html -fragment -precontent $TableCSS ) -append



# AUDIT CHECKS START HERE                                                                                                                                                    #
# =================================================================================================================
  
  $esxhosts = get-vmhost -server $h

# =================================================================================================================

  #Check 1
  $check1 = "1: ESXi System Properly Patched"
  print-header "1: ESXi System Properly Patched"
  
  $patches = Foreach ($VMHost in Get-VMHost ) { 
          $ESXCli = Get-EsxCli -VMHost $VMHost; 
          $ESXCli.software.vib.list() | Select-Object @{N="VMHost";E={$VMHost}}, Name, 
          AcceptanceLevel, CreationDate, ID, InstallDate, Status, Vendor, Version; 
          }
      Out-File -filepath $outfile -inputobject $epre, $rawdata, $check1 -append
      Out-File -filepath $outfile -inputobject ($patches | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 2
  $check2 = "2: Verify Image Profile and VIB Acceptance Levels"
  Print-Header "2: Verify Image Profile and VIB Acceptance Levels"

  # List the Software AcceptanceLevel for each host 
  $vib = Foreach ($VMHost in Get-VMHost ) { 
    $ESXCli = Get-EsxCli -VMHost $VMHost 
    $VMHost | Select Name, @{N="AcceptanceLevel";E={$ESXCli.software.acceptance.get()}} 
    } 
    # List only the vibs which are not at "VMwareCertified" or "VMwareAccepted" or "PartnerSupported" acceptance level 
    Foreach ($VMHost in Get-VMHost ) { 
    $ESXCli = Get-EsxCli -VMHost $VMHost 
    $ESXCli.software.vib.list() | Where { ($_.AcceptanceLevel -ne "VMwareCertified") -and 
    ($_.AcceptanceLevel -ne "VMwareAccepted") -and ($_.AcceptanceLevel -ne 
    "PartnerSupported") } 
    }

    Out-File -filepath $outfile -inputobject $epre, $rawdata, $check2 -append
    Out-File -filepath $outfile -inputobject ($vib | Convertto-html -fragment -precontent $TableCSS) -append

# ==================================================================================================================

  #Check 3
  $check3 = "3: Configure NTP time synchronization" 
  Print-Header "3: Configure NTP time synchronization" 

  # List the NTP Settings for all hosts 
  $ntp = Get-VMHost | Select Name, @{N="NTPSetting";E={$_ | Get-VMHostNtpServer}}

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check3 -append
  Out-File -filepath $outfile -inputobject ($ntp | Convertto-html -fragment -precontent $TableCSS) -append

# ==================================================================================================================

  #Check 4
  $check4 = "4: Configure the ESXi host firewall to restrict access to services running on the host" 
  Print-Header "4: Configure the ESXi host firewall to restrict access to services running on the host" 
  
  # List all services for a host 
  $firewall1 = Get-VMHost | Get-VMHostService 
  # List the services which are enabled and have rules defined for specific IP ranges to access the service 
  $firewall2 = Get-VMHost | Get-VMHostFirewallException | Where {$_.Enabled -and (-not $_.ExtensionData.AllowedHosts.AllIP)} 
  # List the services which are enabled and do not have rules defined for specific IP ranges to access the service 
  $firewall3 = Get-VMHost | Get-VMHostFirewallException | Where {$_.Enabled -and ($_.ExtensionData.AllowedHosts.AllIP)}

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check4 -append
  Out-File -filepath $outfile -inputobject ($firewall1 | Convertto-html -fragment -precontent $TableCSS) -append
  Out-File -filepath $outfile -inputobject ($firewall2 | Convertto-html -fragment -precontent $TableCSS) -append
  Out-File -filepath $outfile -inputobject ($firewall3 | Convertto-html -fragment -precontent $TableCSS) -append

# ==================================================================================================================

  #Check 5
  $check5 = "5: Disable Managed Object Browser (MOB)"  
  Print-Header "5: Disable Managed Object Browser (MOB)" 

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check5 -append
  Out-File -filepath $outfile -inputobject $epre, $usecli -append

# ==================================================================================================================
 
  #Check 6
  $check6 = "6: Do not use default self-signed certificates for ESXi communication"  
  Print-Header "6: Do not use default self-signed certificates for ESXi communication" 

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check6 -append
  Out-File -filepath $outfile -inputobject $erpe, $man -append

# =================================================================================================================
  
  #Check 7
  $check7 = "7: Ensure proper SNMP configuration" 
  Print-Header "7: Ensure proper SNMP configuration"  
  $snmp = Get-VMHostSnmp

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check7 -append
  Out-File -filepath $outfile -inputobject ($snmp | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 8
  $check8 = "8: Prevent unintended use of dvfilter network APIs" 
  Print-Header "8: Prevent unintended use of dvfilter network APIs"

  # List Net.DVFilterBindIpAddress for each host
  $dvfilter = Get-VMHost | Select Name, @{N="Net.DVFilterBindIpAddress";E={$_ | Get-
  AdvancedSettings Net.DVFilterBindIpAddress | Select -ExpandProperty 
  Values}}

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check8 -append
  Out-File -filepath $outfile -inputobject ($dvfilter | Convertto-html -fragment -precontent $TableCSS) -append
  
# =================================================================================================================

  #Check 9
  $check9 = "9: Remove expired or revoked SSL certificates from the ESXi server" 
  Print-Header "9: Remove expired or revoked SSL certificates from the ESXi server"  
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check9 -append
  Out-File -filepath $outfile -inputobject $epre, $man -append

# =================================================================================================================

  #Check 10
  $check10 = "10: Configure a centralized location to collect ESXi host core dumps"
  Print-Header "10: Configure a centralized location to collect ESXi host core dumps"

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check10 -append
  Out-File -filepath $outfile -inputobject $epre, $usecli -append

# =================================================================================================================
  
  #Check 11
  $check11 = "11: Configure persistent logging for all ESXi host"
  Print-Header "11: Configure persistent logging for all ESXi host"

  # List Syslog.global.logDir for each host
  $logg = Get-VMHost | Select Name, @{N="Syslog.global.logDir";E={$_ | Get-
  VMHostAdvancedSetting Syslog.global.logDir| Select -ExpandProperty Values}}
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check11 -append
  Out-File -filepath $outfile -inputobject ($logg | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================
  
  #Check 12
  $check12 = "12: Configure remote logging for ESXi hosts"
  Print-Header "12: Configure remote logging for ESXi hosts"

  # List Syslog.global.logHost for each host
  $remlogg = Get-VMHost | Select Name, @{N="Syslog.global.logHost";E={$_ | Get-
  VMHostAdvancedSetting Syslog.global.logHost | Select -ExpandProperty Values}} 

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check12 -append
  Out-File -filepath $outfile -inputobject ($remlogg | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================

  #Check 13
  $check13 = "13: Create a non-root user account for local admin access"
  Print-Header "13: Create a non-root user account for local admin access"
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check13 -append
  Out-File -filepath $outfile -inputobject $epre, $man -append

# ================================================================================================================

  #Check 14
  $check14 = "14: Establish a password policy for password complexity"
  Print-Header "14: Establish a password policy for password complexity"

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check14 -append
  Out-File -filepath $outfile -inputobject $epre, $usecli -append

# ================================================================================================================

  #Check 15
  $check15 = "15: Use Active Directory for local user authentication"
  Print-Header "15: Use Active Directory for local user authentication"

  # Check each host and their domain membership status 
  $adauth = Get-VMHost | Get-VMHostAuthentication | Select VmHost, Domain, DomainMembershipStatus

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check15 -append
  Out-File -filepath $outfile -inputobject ($adauth | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================

  #Check 16
  $check16 = "16: Verify Active Directory group membership for the 'ESX Admins' group"
  Print-Header "16: Verify Active Directory group membership for the 'ESX Admins' group"

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check16 -append
  Out-File -filepath $outfile -inputobject $epre, $man -append

# ===============================================================================================================

  #Check 17
  $check17 = "17: Disable DCUI to prevent local administrative control"
  Print-Header "17: Disable DCUI to prevent local administrative control"

  # List DCUI settings for all hosts 
  $dcui = Get-VMHost | Get-VMHostService | Where { $_.key -eq "DCUI" }

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check17 -append
  Out-File -filepath $outfile -inputobject ($dcui | Convertto-html -fragment -precontent $TableCSS) -append

# ===============================================================================================================

  #Check 18
  $check18 = "18: Disable SSH" 
  Print-Header "18: Disable SSH"

  # Check if SSH is running and set to start 
  $dssh = Get-VMHost | Get-VMHostService | Where { $_.key -eq "TSM-SSH" } | Select VMHost, Key, Label, Policy, Running, Required

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check18 -append
  Out-File -filepath $outfile -inputobject ($dssh | Convertto-html -fragment -precontent $TableCSS) -append

# ==============================================================================================================

  #Check 19
  $check19 = "19: Limit CIM Access"
  Print-Header "19: Limit CIM Access"

  # List all user accounts on the Host -Host Local connection required- 
  $cim = Get-VMHostAccount

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check19 -append
  Out-File -filepath $outfile -inputobject ($cim | Convertto-html -fragment -precontent $TableCSS) -append

# ===============================================================================================================

  #Check 20
  $check20 = "20: Enable lockdown mode to restrict remote access" 
  Print-Header "20: Enable lockdown mode to restrict remote access" 

  # To check if Lockdown mode is enabled 
  $lockdownmode = Get-VMHost | Select Name,@{N="Lockdown";E={$_.Extensiondata.Config.adminDisabled}}

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check20 -append
  Out-File -filepath $outfile -inputobject ($lockdownmode | Convertto-html -fragment -precontent $TableCSS) -append  

# ================================================================================================================

  #Check 21
  $check21 = "21: Remove keys from SSH authorized keys file"
  Print-Header "21: Remove keys from SSH authorized keys file"
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check21 -append
  Out-File -filepath $outfile -inputobject $epre, $usecli -append

# =================================================================================================================

  #Check 22
  $check22 = "22: Set a timeout to automatically terminate idle ESXi Shell and SSH sessions"
  Print-Header "22: Set a timeout to automatically terminate idle ESXi Shell and SSH sessions"

  # List UserVars.ESXiShellInteractiveTimeOut for each host 
  $settimeout = Get-VMHost | Select Name, @{N="UserVars.ESXiShellInteractiveTimeOut";E={$_ | Get-VMHostAdvancedConfiguration UserVars.ESXiShellInteractiveTimeOut | Select -ExpandProperty Values}}

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check22 -append
  Out-File -filepath $outfile -inputobject ($settimeout | Convertto-html -fragment -precontent $TableCSS) -append 

# ==================================================================================================================

  #Check 23
  $check23 = "23: Set a timeout for Shell Services"
  Print-Header "23: Set a timeout for Shell Services"

  # List UserVars.ESXiShellTimeOut in minutes for each host 
  $toutshell = Get-VMHost | Select Name, @{N="UserVars.ESXiShellTimeOut";E={$_ | Get-VMHostAdvancedConfiguration UserVars.ESXiShellTimeOut | Select -ExpandProperty Values}}
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check23 -append
  Out-File -filepath $outfile -inputobject ($toutshell | Convertto-html -fragment -precontent $TableCSS) -append 

# =================================================================================================================

  #Check 24
  $check24 = "24: Set DCUI.Access to allow trusted users to override lockdown mode"
  Print-Header "24: Set DCUI.Access to allow trusted users to override lockdown mode"

  $setdcui = Get-VMHost | Get-AdvancedSetting -Name DCUI.Access

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check24 -append
  Out-File -filepath $outfile -inputobject ($setdcui | Convertto-html -fragment -precontent $TableCSS) -append 

# ================================================================================================================

  #Check 25
  $check25 = "25: Verify contents of exposed configuration files"
  Print-Header "25: Verify contents of exposed configuration files"
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check25 -append
  Out-File -filepath $outfile -inputobject $epre, $man -append

# ================================================================================================================

  #Check 26
  $check26 = "26: Enable bidirectional CHAP authentication for iSCSI traffic."
  Print-Header "26: Enable bidirectional CHAP authentication for iSCSI traffic."

  # List Iscsi Initiator and CHAP Name if defined 
  $bichap = Get-VMHost | Get-VMHostHba | Where {$_.Type -eq "Iscsi"} | Select VMHost, Device, ChapType, @{N="CHAPName";E={$_.AuthenticationProperties.ChapName}}

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check26 -append
  Out-File -filepath $outfile -inputobject ($bichap | Convertto-html -fragment -precontent $TableCSS) -append 

# ================================================================================================================

  #Check 27
  $check27 = "27: Ensure uniqueness of CHAP authentication secrets"
  Print-Header "27: Ensure uniqueness of CHAP authentication secrets"

  # List Iscsi Initiator and CHAP Name if defined 
  $chapauth = Get-VMHost | Get-VMHostHba | Where {$_.Type -eq "Iscsi"} | Select VMHost, Device, ChapType, @{N="CHAPName";E={$_.AuthenticationProperties.ChapName}}

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check27 -append
  Out-File -filepath $outfile -inputobject ($chapauth | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 28
  $check28 = "28: Mask and zone SAN resources appropriately"
  Print-Header "28: Mask and zone SAN resources appropriately"
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check28 -append
  Out-File -filepath $outfile -inputobject $epre, $man -append

# =================================================================================================================

  #Check 29
  $check29 = "29: Zero out VMDK files prior to deletion"
  Print-Header "29: Zero out VMDK files prior to deletion"
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check29 -append
  Out-File -filepath $outfile -inputobject $epre, $man -append

# =================================================================================================================

  #Check 30
  $check30 = "30: Ensure that the vSwitch Forged Transmits policy is set to reject"
  Print-Header "30: Ensure that the vSwitch Forged Transmits policy is set to reject"

  # List all vSwitches and their Security Settings
  $forged = Get-VirtualSwitch -Standard | Select VMHost, Name, ` @{N="MacChanges";E={if ($_.ExtensionData.Spec.Policy.Security.MacChanges) { "Accept" } Else { "Reject"} }}, ` @{N="PromiscuousMode";E={if ($_.ExtensionData.Spec.Policy.Security.PromiscuousMode) { "Accept" } Else { "Reject"} }}, ` @{N="ForgedTransmits";E={if ($_.ExtensionData.Spec.Policy.Security.ForgedTransmits) { "Accept" } Else { "Reject"} }}

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check30 -append
  Out-File -filepath $outfile -inputobject ($forged | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================
  $ch30 = "<b> = Check Control 30 Output</b><p>"
  $ch32 = "<b> = Check Control 32 Output</b><p>"
# =================================================================================================================
  
  #Check 31
  $check31 = "31: Ensure that the vSwitch Promiscuous Mode policy is set to reject"
  Print-Header "31: Ensure that the vSwitch Promiscuous Mode policy is set to reject"
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check31 -append
  Out-File -filepath $outfile -inputobject $epre, $ch30 -append
 
# =================================================================================================================

  #Check 32
  $check32 = "32: Ensure that port groups are not configured to the value of the native VLAN"
  Print-Header "32: Ensure that port groups are not configured to the value of the native VLAN"

  # List all vSwitches, their Portgroups and VLAN IDs
  $vlanid = Get-VirtualPortGroup -Standard | Select virtualSwitch, Name, VlanID

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check32 -append
  Out-File -filepath $outfile -inputobject ($vlanid | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 33
  $check33 = "33: Ensure that port groups are not configured to VLAN values reserved by upstream physical switches"
  Print-Header "33: Ensure that port groups are not configured to VLAN values reserved by upstream physical switches"
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check33 -append
  Out-File -filepath $outfile -inputobject $epre, $ch32 -append

# =================================================================================================================

  #Check 34
  $check34 = "34: Ensure that port groups are not configured to VLAN 4095 except for Virtual Guest Tagging (VGT)"
  Print-Header "34: Ensure that port groups are not configured to VLAN 4095 except for Virtual Guest Tagging (VGT)"
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check34 -append
  Out-File -filepath $outfile -inputobject $epre, $ch32 -append

# =================================================================================================================

  #Check 35
  $check35 = "35: Limit informational messages from the VM to the VMX file"
  Print-Header "35: Limit informational messages from the VM to the VMX file"

  # List the VMs and their current settings 
  $vmxfile = Get-VM | Get-AdvancedSetting -Name "tools.setInfo.sizeLimit" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check35 -append
  Out-File -filepath $outfile -inputobject ($vmxfile | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 36
  $check36 = "36: Limit sharing of console connections"
  Print-Header "36: Limit sharing of console connections"

  # List the VMs and their current settings 
  $limitshar = Get-VM | Get-AdvancedSetting -Name "RemoteDisplay.maxConnections" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check36 -append
  Out-File -filepath $outfile -inputobject ($limitshar | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 37
  $check37 = "37: Disconnect unauthorized devices - Floppy Devices"
  Print-Header "37: Disconnect unauthorized devices - Floppy Devices"

  # Check for Floppy Devices attached to VMs
  $floppy = Get-VM | Get-FloppyDrive | Select Parent, Name, ConnectionState

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check37 -append
  Out-File -filepath $outfile -inputobject ($floppy | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 38
  $check38 = "38: Disconnect unauthorized devices - CD/DVD Devices"
  Print-Header "38: Disconnect unauthorized devices - CD/DVD Devices"

  # Check for CD/DVD Drives attached to VMs 
  $cddrive = Get-VM | Get-CDDrive

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check38 -append
  Out-File -filepath $outfile -inputobject ($cddrive | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 39
  $check39 = "39: Disconnect unauthorized devices - Parallel Devices"
  Print-Header "39: Disconnect unauthorized devices - Parallel Devices"
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check39 -append
  Out-File -filepath $outfile -inputobject $epre, $man -append

# =================================================================================================================

  #Check 40
  $check40 = "40: Disconnect unauthorized devices - Serial Devices"
  Print-Header "40: Disconnect unauthorized devices - Serial Devices"
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check40 -append
  Out-File -filepath $outfile -inputobject $epre, $man -append

# =================================================================================================================

  #Check 41
  $check41 = "41: Disconnect unauthorized devices - USB Devices"
  Print-Header "41: Disconnect unauthorized devices - USB Devices"

  # Check for USB Devices attached to VMs 
  $usbdevice = Get-VM | Get-USBDevice

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check41 -append
  Out-File -filepath $outfile -inputobject ($usbdevice | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 42
  $check42 = "42: Prevent unauthorized removal and modification of devices."
  Print-Header "42: Prevent unauthorized removal and modification of devices."

  # List the VMs and their current settings 
  $modidevice = Get-VM | Get-AdvancedSetting -Name "isolation.device.edit.disable" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check42 -append
  Out-File -filepath $outfile -inputobject ($modidevice | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 43
  $check43 = "43: Disable Auto logon"
  Print-Header "43: Disable Auto logon"

  # List the VMs and their current settings 
  $autologon = Get-VM | Get-AdvancedSetting -Name "isolation.tools.ghi.autologon.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check43 -append
  Out-File -filepath $outfile -inputobject ($autologon | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 44
  $check44 = "44: Disable BIOS BBS"
  Print-Header "44: Disable BIOS BBS"

  # List the VMs and their current settings 
  $biosbbs = Get-VM | Get-AdvancedSetting -Name "isolation.bios.bbs.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check44 -append
  Out-File -filepath $outfile -inputobject ($biosbbs | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 45
  $check45 = "45: Disable Guest Host Interaction Protocol Handler"
  Print-Header "45: Disable Guest Host Interaction Protocol Handler"

  # List the VMs and their current settings 
  $dprotohand = Get-VM | Get-AdvancedSetting -Name "isolation.tools.ghi.protocolhandler.info.disable" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check45 -append
  Out-File -filepath $outfile -inputobject ($dprotohand | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 46
  $check46 = "46: Disable Unity Taskbar"
  Print-Header "46: Disable Unity Taskbar"

  # List the VMs and their current settings 
  $unitytaskbar = Get-VM | Get-AdvancedSetting -Name "isolation.tools.unity.taskbar.disable" | Select Entity, Name, Value
  
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check46 -append
  Out-File -filepath $outfile -inputobject ($unitytaskbar | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 47
  $check47 = "47: Disable Unity Active"
  Print-Header "47: Disable Unity Active"

  # List the VMs and their current settings 
  $unityactive = Get-VM | Get-AdvancedSetting -Name "isolation.tools.unityActive.disable" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check47 -append
  Out-File -filepath $outfile -inputobject ($unityactive | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 48
  $check48 = "48: Disable Unity Window Contents"
  Print-Header "48: Disable Unity Window Contents"

  # List the VMs and their current settings 
  $unitywindow = Get-VM | Get-AdvancedSetting -Name "isolation.tools.unity.windowContents.disable" | Select Entity, Name, Value
 
  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check48 -append
  Out-File -filepath $outfile -inputobject ($unitywindow | Convertto-html -fragment -precontent $TableCSS) -append
 
# =================================================================================================================

  #Check 49
  $check49 = "49: Disable Unity Push Update"
  Print-Header "49: Disable Unity Push Update"

  # List the VMs and their current settings 
  $unitypush = Get-VM | Get-AdvancedSetting -Name "isolation.tools.unity.push.update.disable" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check49 -append
  Out-File -filepath $outfile -inputobject ($unitypush | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 50
  $check50 = "50: Disable Drag and Drop Version Get"
  Print-Header "50: Disable Drag and Drop Version Get"

  # List the VMs and their current settings 
  $dragdrop = Get-VM | Get-AdvancedSetting -Name "isolation.tools.vmxDnDVersionGet.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check50 -append
  Out-File -filepath $outfile -inputobject ($dragdrop | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 51
  $check51 = "51: Disable Shell Action"
  Print-Header "51: Disable Shell Action"

  # List the VMs and their current settings 
  $dshell = Get-VM | Get-AdvancedSetting -Name "isolation.ghi.host.shellAction.disable" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check51 -append
  Out-File -filepath $outfile -inputobject ($dshell | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 52
  $check52 = "52: Disable Request Disk Topology"
  Print-Header "52: Disable Request Disk Topology"

  # List the VMs and their current settings 
  $dreqdisk = Get-VM | Get-AdvancedSetting -Name "isolation.tools.dispTopoRequest.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check52 -append
  Out-File -filepath $outfile -inputobject ($dreqdisk | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 53
  $check53 = "53: Disable Trash Folder State"
  Print-Header "53: Disable Trash Folder State"

  # List the VMs and their current settings 
  $dtrash = Get-VM | Get-AdvancedSetting -Name "isolation.tools.trashFolderState.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check53 -append
  Out-File -filepath $outfile -inputobject ($dtrash | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 54
  $check54 = "54: Disable Guest Host Interaction Tray Icon"
  Print-Header "54: Disable Guest Host Interaction Tray Icon"

  # List the VMs and their current settings 
  $dtrayicon = Get-VM | Get-AdvancedSetting -Name "isolation.tools.ghi.trayicon.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check54 -append
  Out-File -filepath $outfile -inputobject ($dtrayicon | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 55
  $check55 = "55: Disable Unity"
  Print-Header "55: Disable Unity"

  # List the VMs and their current settings 
  $dunity = Get-VM | Get-AdvancedSetting -Name "isolation.tools.unity.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check55 -append
  Out-File -filepath $outfile -inputobject ($dunity | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 56
  $check56 = "56: Disable Unity Interlock"
  Print-Header "56: Disable Unity Interlock"

  # List the VMs and their current settings 
  $unityinterlock = Get-VM | Get-AdvancedSetting -Name "isolation.tools.unityInterlockOperation.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check56 -append
  Out-File -filepath $outfile -inputobject ($unityinterlock | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================

  #Check 57
  $check57 = "57: Disable Host Guest File System Server"
  Print-Header "57: Disable Host Guest File System Server"

  # List the VMs and their current settings 
  $dfilesystem = Get-VM | Get-AdvancedSetting -Name "isolation.tools.hgfsServerSet.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check57 -append
  Out-File -filepath $outfile -inputobject ($dfilesystem | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================

  #Check 58
  $check58 = "58: Disable Guest Host Interaction Launch Menu"
  Print-Header "58: Disable Guest Host Interaction Launch Menu"

  # List the VMs and their current settings 
  $dinteraction = Get-VM | Get-AdvancedSetting -Name "isolation.tools.ghi.launchmenu.change" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check58 -append
  Out-File -filepath $outfile -inputobject ($dinteraction | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 59
  $check59 = "59: Disable memSchedFakeSampleStats"
  Print-Header "59: Disable memSchedFakeSampleStats"

  # List the VMs and their current settings 
  $dmem = Get-VM | Get-AdvancedSetting -Name "isolation.tools.memSchedFakeSampleStats.disable" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check59 -append
  Out-File -filepath $outfile -inputobject ($dmem | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 60
  $check60 = "60: Disable VM Console Copy operations"
  Print-Header "60: Disable VM Console Copy operations"

  # List the VMs and their current settings 
  $consolecopy = Get-VM | Get-AdvancedSetting -Name "isolation.tools.copy.disable" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check60 -append
  Out-File -filepath $outfile -inputobject ($consolecopy | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 61
  $check61 = "61: Disable VM Console Drag and Drop operations"
  Print-Header "61: Disable VM Console Drag and Drop operations"

  # List the VMs and their current settings 
  $consoledrag = Get-VM | Get-AdvancedSetting -Name "isolation.tools.dnd.disable" | Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check61 -append
  Out-File -filepath $outfile -inputobject ($consoledrag | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================

  #Check 62
  $check62 = "62: Avoid using nonpersistent disks"
  Print-Header "62: Avoid using nonpersistent disks"

  #List the VM's and their disk types 
  $nonperdisk = Get-VM | Get-HardDisk | Select Parent, Name, Filename, DiskType, Persistence

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check62 -append
  Out-File -filepath $outfile -inputobject ($nonperdisk | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================

  #Check 63
  $check63 = "63: Disable virtual disk shrinking"
  Print-Header "63: Disable virtual disk shrinking"

  # List the VMs and their current settings 
  $diskshrink = Get-VM | Get-AdvancedSetting -Name "isolation.tools.diskShrink.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check63 -append
  Out-File -filepath $outfile -inputobject ($diskshrink | Convertto-html -fragment -precontent $TableCSS) -append

# =================================================================================================================

  #Check 64
  $check64 = "64: Disable virtual disk wiping"
  Print-Header "64: Disable virtual disk wiping"

  # List the VMs and their current settings 
  $diskwipe = Get-VM | Get-AdvancedSetting -Name "isolation.tools.diskWiper.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check64 -append
  Out-File -filepath $outfile -inputobject ($diskwipe | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================

  #Check 65
  $check65 = "65: Disable VIX messages from the VM"
  Print-Header "65: Disable VIX messages from the VM"

  # List the VMs and their current settings 
  $vixmessage = Get-VM | Get-AdvancedSetting -Name "isolation.tools.vixMessage.disable"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check65 -append
  Out-File -filepath $outfile -inputobject ($vixmessage | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================

  #Check 66
  $check66 = "66: Limit number of VM log files"
  Print-Header "66: Limit number of VM log files"

  # List the VMs and their current settings 
  $vmlog = Get-VM | Get-AdvancedSetting -Name "log.keepOld"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check66 -append
  Out-File -filepath $outfile -inputobject ($vmlog | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================

  #Check 67
  $check67 = "67: Do not send host information to guests"
  Print-Header "67: Do not send host information to guests"

  # List the VMs and their current settings 
  $hostinfog = Get-VM | Get-AdvancedSetting -Name "tools.guestlib.enableHostInfo"| Select Entity, Name, Value

  Out-File -filepath $outfile -inputobject $epre, $rawdata, $check67 -append
  Out-File -filepath $outfile -inputobject ($hostinfog | Convertto-html -fragment -precontent $TableCSS) -append

# ================================================================================================================
  
  # Disconnect to ESXi Host
  Disconnect-VIServer
  
  Print-Header "All Checks Are Completed"

  # ==============================================================================================================