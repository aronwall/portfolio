# Linux Security & Administration Cheat Sheet

En samling användbara kommandon för systeminventering, användargranskning och felsökning i Linux-miljöer.

## Innehåll
* [Användare och Grupper](#användare-och-grupper)
* [System och Paket](#system-och-paket)
* [Nätverk och Anslutningar](#nätverk-och-anslutningar)
* [Loggar och Historik](#loggar-och-historik)
* [Säkerhet och Rättigheter](#säkerhet-och-rättigheter)

---

### Användare och Grupper
| Syfte | Kommando |
| :--- | :--- |
| Lista alla användare | `cat /etc/passwd` |
| Visa inloggade användare just nu | `who` |
| Lista grupper och medlemmar | `getent group` |

### System och Paket
| Syfte | Kommando |
| :--- | :--- |
| Hitta paket utifrån kommando | `apt-file search bin/*kommando*` |
| Hitta paket utifrån service-fil | `dpkg -S /path/to/service.service` |

### Nätverk och Anslutningar
| Syfte | Kommando |
| :--- | :--- |
| Se lyssnande portar (TCP/UDP) | `ss -lntu` |

### Loggar och Historik
| Syfte | Kommando |
| :--- | :--- |
| Visa kommando-historik | `history` |
| Senaste inloggningar | `last -a \| head -n 10` |
| Senaste utloggningar | `last -x \| grep “still logged in” -v \| head -n 10` |
| Visa misslyckade inloggningar | `grep "failure" /var/log/auth.log` |

### Säkerhet och Rättigheter
| Syfte | Kommando |
| :--- | :--- |
| Upptäck SUID-binärer (riskabla) | `find / -perm -4000 2>/dev/null` |

---
*Skapat för användning vid säkerhetsgranskning och systemadministration.*
