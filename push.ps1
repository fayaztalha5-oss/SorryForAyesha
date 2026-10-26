
$token = "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"
$owner = "fayaztalha5-oss"
$repo  = "Aisha-sorry-card"

$h = @{
    "Authorization"       = "Bearer $token"
    "Accept"              = "application/vnd.github+json"
    "X-GitHub-Api-Version"= "2022-11-28"
}

# Read and Base64 encode the HTML file
$bytes = [System.IO.File]::ReadAllBytes("d:\First Project\sorry-aisha.html")
$b64   = [Convert]::ToBase64String($bytes)

# Check if file already exists (need SHA to update)
$existing = $null
try {
    $existing = Invoke-RestMethod -Uri "https://api.github.com/repos/$owner/$repo/contents/sorry-aisha.html" -Headers $h -Method GET
    Write-Host "File exists, will update. SHA: $($existing.sha)"
} catch {
    Write-Host "File does not exist yet, will create."
}

# Build request body
$body = [ordered]@{
    message = "Add Aisha sorry website"
    content = $b64
}
if ($existing -and $existing.sha) {
    $body["sha"] = $existing.sha
}

$bodyJson = $body | ConvertTo-Json -Depth 5 -Compress

# Push to GitHub
try {
    $result = Invoke-RestMethod `
        -Uri "https://api.github.com/repos/$owner/$repo/contents/sorry-aisha.html" `
        -Method PUT `
        -Headers $h `
        -Body $bodyJson `
        -ContentType "application/json"

    Write-Host "SUCCESS! File pushed."
    Write-Host "Raw URL: https://raw.githubusercontent.com/$owner/$repo/main/sorry-aisha.html"
    Write-Host "GitHub Pages (after enable): https://$owner.github.io/$repo/sorry-aisha.html"
} catch {
    Write-Host "ERROR: $_"
    Write-Host $_.Exception.Response
}
