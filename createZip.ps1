function Get-FolderName($initialDirectory)
{   
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.SelectedPath = $initialDirectory
    $FolderBrowserDialog.Description = "Select a folder"
    
    if ($FolderBrowserDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $FolderBrowserDialog.SelectedPath
    }
    else {
        return $null
    }
}

# Prompt for the folder path with tab completion enabled
$FolderPath = Get-FolderName -initialDirectory $PSScriptRoot

$SecondToLastDirectory = (Get-Item (Split-Path $FolderPath -Parent)).Name

# Define the output directory relative to the script location
$OutputDirectory = Join-Path -Path $PSScriptRoot -ChildPath "output\$SecondToLastDirectory"

# Ensure that the output directory exists, and create it if not
if (-not (Test-Path -Path $OutputDirectory -PathType Container)) {
    New-Item -Path $OutputDirectory -ItemType Directory
}


if ($FolderPath) {
    # Extract the last directory from the path
    $LastDirectory = (Get-Item $FolderPath).Name

    # Convert the folder path to a DirectoryInfo object
    $FolderInfo = [System.IO.DirectoryInfo]::new($FolderPath)

    # Define the output zip file name with the desired path
    $ZipFileName = Join-Path -Path $OutputDirectory -ChildPath "$LastDirectory.zip"

    # Compress the folder using .NET's ZipFile class
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($FolderInfo.FullName, $ZipFileName)

    Write-Host "Zip file created: $ZipFileName"
}
else {
    Write-Host "No folder selected."
}

# Wait for user input to prevent the window from closing
# Read-Host "Press Enter to exit..."







