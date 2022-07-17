param ([String] $carelink_exe_name)

$data = @{platform=@{azure_active_directory=0; enterprise_mdm_win=4}}
$edge_dir = "$Env:LOCALAPPDATA\Microsoft\Edge\User Data"
$edge_state = "$edge_dir\Local State"
$json = $null
if (Test-Path $edge_state)
{
    $contents = Get-Content -Path $edge_state
    $json = ConvertFrom-Json $contents
    if ($json.management -eq $null)
    {
        $json | Add-Member -MemberType NoteProperty -Name management -Value $data
    }
    elseif ($json.management -ne $data)
    {
        $json.management = $data
    }
    else {
        $json = $null
    }
} else {
    New-Item $edge_dir -ItemType Directory -ea 0
    $json = $data
}
if ($json -ne $null)
{
    $json_string = ConvertTo-Json $json -Depth 100 -Compress
    $json_string | Out-File $edge_state -Encoding utf8 -NoNewline
}

reg import "C:\vagrant\MDM-FakeEnrollment.reg"
reg import "C:\vagrant\MSEdgeSettings.reg"
gpupdate /force /target:computer
tzutil /s "Central European Standard Time"

& "C:\vagrant\$carelink_exe_name" --mode unattended
