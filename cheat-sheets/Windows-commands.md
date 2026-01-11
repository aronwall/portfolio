# Windows Security & Administration Cheat Sheet

En samling användbara PowerShell- och CMD-kommandon för systeminventering, användargranskning och incidentrespons.

## Innehåll
* [Användare och Grupper](#användare-och-grupper)
* [Active Directory (AD)](#active-directory-ad)
* [Systeminformation och Status](#systeminformation-och-status)
* [Nätverk och Anslutningar](#nätverk-och-anslutningar)
* [Loggar och Historik](#loggar-och-historik)
* [Processer och Drivrutiner](#processer-och-drivrutiner)
* [Säkerhet och GPO](#säkerhet-och-gpo)

---

### Användare och Grupper
| Syfte | Kommando |
| :--- | :--- |
| Lista lokala användare | `Get-LocalUser \| Select-Object Name, PrincipalSource, AccountExpirationDate, LastLogonDate` |
| Visa inloggade användare | `quser` |
| Lista grupper och medlemmar | `Get-LocalGroup \| ForEach-Object { $_.Name; Get-LocalGroupMember $_.Name }` |

### Active Directory (AD)
| Syfte | Kommando |
| :--- | :--- |
| Hämta PW-policy | `Get-ADDefaultDomainPasswordPolicy` |
| Visa specifika gruppmedlemmar | `Get-ADGroupMember ('Domain users', 'Users', 'Domain administrators')` |
| Senaste inloggningar (Domän) | `Get-ADUser -Filter * -Properties lastLogonTimestamp \| Select-Object Name,@{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} \| Sort-Object LastLogon -Descending \| Select -First 20` |
| Info om specifik användare | `Get-ADUser $env:USERNAME -Properties *` |
| Visa gruppmedlemskap | `Get-ADUser -Filter * -Properties MemberOf` |
| Hämta AD-schema (Dump) | `ldifde -f C:\schema_dump.ldf -d (Get-ADRootDSE).schemaNamingContext -p subtree` |
| Info om Domänkontrollant | `ldifde -f C:\schema_dump.ldf -d (Get-ADRootDSE).schemaNamingContext -p subtree` |

### Systeminformation och Status
| Syfte | Kommando |
| :--- | :--- |
| Övergripande systeminfo | `systeminfo.exe` |
| Senaste omstart | `(get-date) - (gcim Win32_OperatingSystem).LastBootUpTime` |
| Sätt svenskt tangentbord | `Set-WinUserLanguageList -LanguageList “se-SE” -Force` |

### Nätverk och Anslutningar
| Syfte | Kommando |
| :--- | :--- |
| Se lyssnande portar | `Get-NetTCPConnection -State Listen` |
| Utgående TCP-anslutningar | `Get-NetTCPConnection \| Select-Object LocalPort, RemoteAddress, RemotePort, State, OwningProcess` |

### Loggar och Historik
| Syfte | Kommando |
| :--- | :--- |
| PowerShell-historik | `Get-Content '~\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt' -EA 0` |
| Senaste lyckade inloggningar | `Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624} -MaxEvents 10 \| Select TimeCreated, @{n='Account';e={$_.Properties[1].Value}}` |
| Senaste utloggningar | `Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4634} -MaxEvents 10 \| Select TimeCreated, @{n='Account';e={$_.Properties[1].Value}}` |
| Misslyckade inloggningar | `Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625}` |
| RDP-historik (Registry) | `reg query "HKCU\Software\Microsoft\Terminal Server Client\Servers"` |

### Processer och Drivrutiner
| Syfte | Kommando |
| :--- | :--- |
| Processer sorterat efter CPU-användning | `Get-Process \| Select-Object Name, Id, CPU, StartTime \| Sort-Object CPU -Descending` |
| Lista alla drivrutiner | `Get-WMIObject Win32_SystemDriver \| Select-Object Name, DisplayName, State, PathName` |

### Säkerhet och GPO
| Syfte | Kommando |
| :--- | :--- |
| Status på MS Defender | `Get-MpComputerStatus \| Select-Object AMServiceEnabled,AntispywareEnabled,RealTimeProtectionEnabled,QuickScanEndTime` |
| Applicerade policies (RSoP) | `gpresult /r` |
| Lista alla GPO:er | `Get-GPO -All` |
| Backa upp alla GPO:er | `Backup-GPO -All -Path 'C:\GPOBackup'` |

---
*Skapat för användning vid säkerhetsgranskning och systemadministration.*
