# -----------------------------------------------------
# Name: Joshua Erwin
# Title: Security Audit Script
# Purpose: Performs a comprehensive local security audit on a Windows system.
# Outputs audit results to a timestamped text report.
# Created: April 2025
# -----------------------------------------------------

# Create timestamped output file
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$output = "audit_report_$timestamp.txt"

"Security Audit Report - $timestamp" > $output
"--------------------------------------------------`n" >> $output

# 1. Check Firewall Status
"Windows Firewall Status:" >> $output
Get-NetFirewallProfile | ForEach-Object {
    "$($_.Name): $($_.Enabled)" >> $output
}
"`n" >> $output

# 2. Windows Defender Status
"Windows Defender (Antivirus) Status:" >> $output
Try {
    $defender = Get-MpComputerStatus
    "Real-time Protection: $($defender.RealTimeProtectionEnabled)" >> $output
    "Antivirus Enabled: $($defender.AntivirusEnabled)" >> $output
} Catch {
    "Windows Defender not available or access denied." >> $output
}
"`n" >> $output

# 3. Open TCP Ports
"Listening TCP Ports:" >> $output
Get-NetTCPConnection -State Listen | Select-Object -ExpandProperty LocalPort | Sort-Object -Unique >> $output
"`n" >> $output

# 4. Admin Rights Check
"User Privilege Check:" >> $output
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrator")
"Running as Administrator: $isAdmin" >> $output
"`n" >> $output

# 5. Last 5 Failed Logon Attempts (with graceful fallback)
"Recent Failed Logon Attempts:" >> $output
Try {
    $logons = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -MaxEvents 5 -ErrorAction Stop
    if ($logons.Count -eq 0) {
        "No failed logon attempts found." >> $output
    } else {
        $logons | ForEach-Object {
            "Time: $($_.TimeCreated) | User: $($_.Properties[5].Value) | IP: $($_.Properties[19].Value)" >> $output
        }
    }
} Catch {
    "Could not access Security log. Try running as Administrator." >> $output
}
"`n" >> $output

# 6. Password Policy
"Password Policy:" >> $output
$policy = net accounts
$policy >> $output
"`n" >> $output

# 7. Guest / Disabled Accounts
"Inactive or Guest Accounts:" >> $output
Get-LocalUser | Where-Object { $_.Enabled -eq $false -or $_.Name -like "*guest*" } |
    ForEach-Object {
        "Account: $($_.Name) | Enabled: $($_.Enabled)" >> $output
    }
"`n" >> $output

# 8. Completion Message
"Security audit complete. Results saved to $output"
Start-Process notepad.exe $output
