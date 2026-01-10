param (
    [Parameter(Mandatory = $true)]
    [string]$SolutionName,

    [Parameter(Mandatory = $true)]
    [string]$RepoName,

    [Parameter(Mandatory = $true)]
    [string]$Tags,

    [Parameter(Mandatory = $true)]
    [string]$Description,

    [string]$RootPath = "../"
)

# --- MAPA TOKENÓW ---
$replacements = @{
    "#SOLUTION_NAME" = $SolutionName
    "#REPO_NAME"     = $RepoName
    "#TAGS"          = $Tags
    "#DESCRIPTION"   = $Description
}

Write-Host "Start: $RootPath"

# =========================
# 1️⃣ ZMIANA TREŚCI PLIKÓW
# =========================
Get-ChildItem -Path $RootPath -Recurse -File | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content) { return }

    $updated = $content
    foreach ($key in $replacements.Keys) {
        $updated = $updated -replace [regex]::Escape($key), $replacements[$key]
    }

    if ($updated -ne $content) {
        Set-Content $_.FullName -Value $updated -Encoding UTF8
        Write-Host "Treść: $($_.FullName)"
    }
}

# =========================
# 2️⃣ ZMIANA NAZW PLIKÓW
# =========================
Get-ChildItem -Path $RootPath -Recurse -File | ForEach-Object {
    $newName = $_.Name

    foreach ($key in $replacements.Keys) {
        $newName = $newName -replace [regex]::Escape($key), $replacements[$key]
    }

    if ($newName -ne $_.Name) {
        Rename-Item -Path $_.FullName -NewName $newName
        Write-Host "Plik: $($_.Name) → $newName"
    }
}

# =========================
# 3️⃣ ZMIANA NAZW KATALOGÓW (BOTTOM-UP)
# =========================
Get-ChildItem -Path $RootPath -Recurse -Directory |
    Sort-Object FullName -Descending |
    ForEach-Object {

        $newName = $_.Name

        foreach ($key in $replacements.Keys) {
            $newName = $newName -replace [regex]::Escape($key), $replacements[$key]
        }

        if ($newName -ne $_.Name) {
            Rename-Item -Path $_.FullName -NewName $newName
            Write-Host "Folder: $($_.Name) → $newName"
        }
    }

Write-Host "Zakonczono."

