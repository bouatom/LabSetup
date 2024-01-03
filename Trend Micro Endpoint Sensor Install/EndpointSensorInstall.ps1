 # Define the URL of the file you want to download
$url = "INSERT URL HERE"

# Define the local directory where you want to save the downloaded file
$destinationDirectory = "C:\TrendMicro"

# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $destinationDirectory -PathType Container)) {
    New-Item -Path $destinationDirectory -ItemType Directory -Force
}

# Define the full path including the filename
$destination = Join-Path -Path $destinationDirectory -ChildPath "EndpointBaseCamp.exe"

# Download the file using the Invoke-WebRequest cmdlet
Invoke-WebRequest -Uri $url -OutFile $destination