try {
    $res = Invoke-RestMethod -Uri 'https://api.figma.com/v1/images/n6EXhfOWHbxNMtUzky1Iom?ids=101:936&format=png' -Method Get
    Write-Host "Success:"
    Write-Host ($res | ConvertTo-Json)
} catch {
    Write-Host "Error status:"
    Write-Host $_.Exception.Response.StatusCode.value__
    Write-Host $_.Exception.Message
}
