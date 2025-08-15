# scripts/powershell/check-deps.ps1
# PowerShell script to check dependencies and display results in a formatted table

$checks = @()

# Packer check
if (Get-Command packer -ErrorAction SilentlyContinue) {
    $version = (packer --version) -replace '.*v(\d+\.\d+\.\d+).*', '$1'
    $status = '✅'
    $message = $version
}
else {
    $status = '❌'
    $message = 'Not Installed'
}
$checks += [PSCustomObject]@{
    Status  = $status
    Program = 'Packer'
    Version = $message
}

# curl check
if (Get-Command curl.exe -ErrorAction SilentlyContinue) {
    $version = (curl.exe --version | Select-Object -First 1) -replace '.*curl (\d+\.\d+\.\d+).*', '$1'
    $status = '✅'
    $message = $version
}
else {
    $status = '❌'
    $message = 'Not Installed'
}
$checks += [PSCustomObject]@{
    Status  = $status
    Program = 'curl'
    Version = $message
}

# ShellCheck check
if (Get-Command shellcheck -ErrorAction SilentlyContinue) {
    $version = (shellcheck --version | Select-String 'version:') -replace '.*version: (\d+\.\d+\.\d+).*', '$1'
    $status = '✅'
    $message = $version
}
else {
    $status = '❌'
    $message = 'Not Installed'
}
$checks += [PSCustomObject]@{
    Status  = $status
    Program = 'ShellCheck'
    Version = $message
}

# Docker check
if (Get-Command docker -ErrorAction SilentlyContinue) {
    $version = (docker --version) -replace '.*version (\d+\.\d+\.\d+).*', '$1'
    $status = '✅'
    $message = $version
}
else {
    $status = '❌'
    $message = 'Not Installed'
}
$checks += [PSCustomObject]@{
    Status  = $status
    Program = 'Docker'
    Version = $message
}

$checks | Format-Table -Property @{
    Label      = ' Status '
    Expression = { $_.Status }
    Align      = 'Center'
}, @{
    Label      = '  Program  '
    Expression = { "$($_.Program)" }
    Align      = 'Center'
}, @{
    Label      = ' Version '
    Expression = { $_.Version }
    Align      = 'Center'
} -AutoSize
