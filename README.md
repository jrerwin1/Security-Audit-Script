# Security Audit Script (PowerShell)

This PowerShell script performs a basic local security audit on a Windows system. It checks key system configurations such as firewall status, antivirus protection, open ports, admin privileges, and recent failed logon attempts. The results are then saved to a timestamped `.txt` file for further review.

## Features

- Checks if Windows Firewall is enabled
- Verifies Windows Defender status
- Lists open TCP ports
- Detects recent failed logon attempts
- Displays user privilege level
- Reports disabled or guest accounts
- Outputs all findings to a clear, timestamped report

## Requirements

- Windows 10 or later  
- PowerShell 5.1+  
- Run script with Administrator privileges

## How to Use

1. Clone this repo or download the script
2. Right-click PowerShell → **Run as Administrator**
3. Run the script from the same folder:

```powershell
.\security_audit.ps1

