Echo ############################################################################################## 	> output.txt
Echo                                    						              	                    >> output.txt
Echo. >> output.txt
Echo       			             IIS Server Hardening                                          >> output.txt
Echo ############################################################################################## 	>> output.txt
Echo. >> output.txt

Echo ##############################################################################################     >> output.txt

Echo 1: BASIC CONFIGURATIONS                                                                            >> output.txt
Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 1) Ensure Web Content Is on Non-System Partition:                                                  >> output.txt
%systemroot%\system32\inetsrv\appcmd.exe list vdir                                                      >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 2) Require Host Headers on all Sites                                                               >> output.txt
%systemroot%\system32\inetsrv\appcmd.exe list sites                                                     >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 3) Disable Directory Browsing                                                                      >> output.txt
%systemroot%\system32\inetsrv\appcmd.exe list config /section:directoryBrowse                           >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 4) Ensure Unique Application Pools for Sites                                                       >> output.txt
%systemroot%\system32\inetsrv\appcmd.exe list app                                                       >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 5) Configure Application Pools to Run As Application Pool Identity                                 >> output.txt
%systemroot%\system32\inetsrv\appcmd.exe list config /section:applicationPools                          >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 6) Use Only Strong Encryption Protocols                                                            >> output.txt
Echo A) Verify the PCT 1.0 protocol is disabled on SP2 (Expected Value = 0)                             >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\PCT 1.0\Server" /v Enabled >> output.txt
Echo. >> output.txt
Echo B) Verify the PCT 1.0 protocol is disabled on R2 (Expected Value = 0) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\PCT 1.0\Server" /v DisabledByDefault >> output.txt
Echo. >> output.txt
Echo C) Verify the SSL 2.0 protocol is disabled on SP2 and R2 (Expected Value = 0) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server" /v Enabled >> output.txt
Echo. >> output.txt
Echo D) Verify the SSL 3.0 protocol is enabled on R2 and SP2 (If Enabled Expected Value = ffffffff) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server" /v Enabled >> output.txt
Echo. >> output.txt
Echo E) Verify the TLS 1.0 protocol is enabled on R2 and SP2 (If Enabled Expected Value = ffffffff) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server" /v Enabled >> output.txt
Echo. >> output.txt
Echo F) Verify the TLS 1.1 protocol is enabled on R2 (If Enabled Expected Value = 0) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server" /v DisabledByDefault >> output.txt
Echo. >> output.txt
Echo G) Verify the TLS 1.2 protocol is enabled on R2 (If Enabled Expected Value = 0) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" /v DisabledByDefault” >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 7) Disable Weak Cipher Suites                                                                      >> output.txt
Echo A) Verify the cipher DES 56/56 has been disabled. If Enabled, (Expected value = 0)                   >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\DES 56/56” >> output.txt
Echo. >> output.txt
Echo B) Verify the cipher NULL has been disabled. If Enabled, (Expected value = 0) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\NULL\Enabled” >> output.txt
Echo. >> output.txt
Echo C) Verify the cipher RC2 40/128 has been disabled. If enabled (Expected value = 0) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC2 40/128\Enabled” >> output.txt
Echo. >> output.txt
Echo D) Verify the cipher RC4 40/128 has been disabled. If enabled (Expected value = 0) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\ RC4 40/128\Enabled”
Echo. >> output.txt
Echo E) Verify the cipher RC4 56/128 has been disabled. If enabled (Expected value = 0) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\ RC4 56/128\Enabled” >> output.txt
Echo. >> output.txt
Echo F) Verify the cipher RC4 64/128 has been disabled. If enabled (Expected value = 0) >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 64/128\Enabled” >> output.txt
Echo. >> output.txt
Echo G) Verify the cipher RC4 128/128 has been disabled. ensure the following key either does not exist on R2 or is set to ffffffff on SP2 and R2 >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128\Enabled” >> output.txt
Echo. >> output.txt
Echo H) Verify the cipher Triple DES 168/168 has been enabled, ensure the following key either does not exist on R2 or is set to ffffffff on SP2 and R2 >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 128/128\Enabled” >> output.txt
Echo. >> output.txt
Echo I) Verify the cipher AES 256/256 has been enabled on R2, ensure the following key is set to ffffffff >> output.txt
REG QUERY “HKLM\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\AEX 256/256\Enabled” >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 8) Enable FTP Logon Attempt Restrictions >> output.txt
Echo Manual Check >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 9) Enable Dynamic IP Address Restrictions >> output.txt
Echo Manual Check >> output.txt
Echo. >> output.txt

Echo 2: CONFIGURE AUTHENTICATION                                                                        >> output.txt
Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 1) Configure Global Authorization Rule to restrict access >> output.txt
Echo Refer Web.config file and Check system.webServer Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 2) Ensure Access to Sensitive Site Features Is Restricted To Authenticated Principals Only >> output.txt
Echo Refer Web.config file and Check Authentication Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 3) Require SSL in Forms Authentication >> output.txt
Echo Refer Web.config file and Check Authentication Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 4) Configure Cookie Protection Mode for Forms Authentication >> output.txt
Echo Refer Web.config file and Check Authentication Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 5) Ensure password Format Credentials Element Not Set to Clear >> output.txt
Echo Refer Web.config file and Check system.web Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 6) Configure SSL for Basic Authentication >> output.txt
Echo Manual Check (Make http Request - Expected:403 Forbidden Error) >> output.txt
Echo. >> output.txt

Echo 3: ASP.NET CONFIGURATION RECOMMENDATIONS                                                           >> output.txt
Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 1) Set Deployment Method to Retail >> output.txt
Echo Refer Machine.config file and Check system.web Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 2) Ensure Custom Error Messages are not off >> output.txt
Echo Refer Web.config file and Check CustomErrorMode >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 3) ASP.NET stack tracing is Not Enabled >> output.txt
Echo Refer Web.config and Machine.config file and Check system.web Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 4) Configure Use Cookies Mode for Session State >> output.txt
Echo Refer Web.config file and Check system.web Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 5) Ensure Cookies Are Set With HttpOnly Attribute >> output.txt
Echo Refer Web.config file and Check httpcookie only >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 6) Configure MachineKey Validation Method >> output.txt
Echo Manual Check >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 7) Configure Global .NET Trust Level >> output.txt
Echo Manual Check >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 8) Hide IIS HTTP Detailed Errors from Displaying Remotely >> output.txt
Echo Refer Web.config file and Check system.web Section >> output.txt
Echo. >> output.txt

Echo 4: REQUEST FILTERING AND RESTRICTIONS                                                              >> output.txt
Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 1) Configure MaxAllowedContentLength Request Filter >> output.txt
Echo Refer Web.config file and Check system.webserber security Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 2) Configure maxURL Request Filter >> output.txt
Echo Refer Web.config file and Check system.webserber security Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 3) Configure MaxQueryString Request Filter >> output.txt
Echo Refer Web.config file and Check system.webserber security Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 4) Do Not Allow non-ASCII Characters in URLs >> output.txt
Echo Refer Web.config file and Check system.webserber security Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 5) Ensure Double-Encoded Requests will be Rejected >> output.txt
Echo Refer Web.config file and Check system.webserber security Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 6) Disallow Unlisted File Extensions >> output.txt
Echo Refer Web.config file and Check system.webserber security Section >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 7) Ensure Handler is not granted Write and Script/Execute >> output.txt
Echo Refer administration.config file
Echo. >> output.txt

Echo. >> output.txt
Echo 8) Ensure Configuration Attribute notListedIsapisAllowed Set To false >> output.txt
Echo Refer ApplicationHost.config file >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 9) Ensure Configuration Attribute notListedCgisAllowed is Set To false >> output.txt
Echo Refer ApplicationHost.config file >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 10) Disable HTTP Trace Method >> output.txt
Echo Refer Web.config file and Check system.webserber security Section >> output.txt
Echo. >> output.txt

Echo 5: IIS LOGGING RECOMMENDATIONS                                                                     >> output.txt
Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 1) Move Default IIS Web Log Location >> output.txt
Echo Manual Check >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 2) Enable Advanced IIS Logging >> output.txt
Echo Manual Check >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 3) ETW Logging >> output.txt
Echo Manual Check >> output.txt
Echo. >> output.txt

Echo 6: FTP REQUESTS                                                                                    >> output.txt
Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo 1) Encrypt FTP Requests >> output.txt
Echo Manual Check >> output.txt
Echo. >> output.txt
Echo. >> output.txt
Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt

Echo Drive Permissions and Details >> output.txt
FOR /F "usebackq skip=4 tokens=1" %s IN (`NET SHARE`) DO (NET SHARE %s) >> output.txt
Echo. >> output.txt

Echo. >> output.txt
Echo. >> output.txt
Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt
Echo The Web.config File Contents >> output.txt
type C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config >> output.txt
Echo. >> output.txt
Echo. >> output.txt

Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt
Echo The Machine.config File Contents >> output.txt
type C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config >> output.txt
Echo. >> output.txt
Echo. >> output.txt

Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt
Echo The administration.config File Contents >> output.txt
type C:\Windows\system32\inetsrv\config\administration.config >> output.txt
Echo. >> output.txt
Echo. >> output.txt

Echo ----------------------------------------------------------------------------------------------     >> output.txt
Echo. >> output.txt
Echo. >> output.txt
Echo The applicationHost.config File Contents >> output.txt
type C:\Windows\system32\inetsrv\config\applicationHost.config >> output.txt
Echo. >> output.txt
Echo. >> output.txt


Echo -END- >> output.txt
