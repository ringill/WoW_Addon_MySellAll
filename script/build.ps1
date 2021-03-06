$distFolderName = "dist"
$srcFolderName = "mySellAll"
$versionLineBase = "## Version: "
$versionStub = "x.x.x"
$tocFileName = "mySellAll.toc"
# root path
$rootPath = Split-Path $PSScriptRoot -Parent

# recreate build folder
$distFolderPath = Join-Path -Path $rootPath -childpath $distFolderName
$FileExists = Test-Path $distFolderPath
if ( $FileExists) {
    Remove-Item -Path $distFolderPath -Recurse
}
New-Item -Path $distFolderPath -ItemType directory -Force

# copy source to dist
$srcFolderPath = Join-Path -Path $rootPath -childpath $srcFolderName
Copy-Item -Path $srcFolderPath -Recurse -Destination $distFolderPath -Container

# read build version from enviroment variables
$buildNumberString = $env:MSA_BUILD

# replace version line in souce file in dist folder
$versionStubLine = $versionLineBase + $versionStub
$versionLine = $versionLineBase + $buildNumberString
$filePath = Join-Path -Path $rootPath -childpath $distFolderName | Join-Path -childpath $srcFolderName | Join-Path -childpath $tocFileName
(Get-Content $filePath) | ForEach-Object {
    $_ -Replace $versionStubLine, $versionLine 
} | Set-Content $filePath

# zip-file name
$distFileName = $srcFolderName + ".zip"
# path to final zip-file
$finalZipPath = Join-Path -Path $distFolderPath -childpath $distFileName
# source in distr
$sourceInDistrFolder = Join-Path -Path $distFolderPath -childpath $srcFolderName
# path to source folder in dist folder
$sourceForZipPath = $sourceInDistrFolder
Compress-Archive $sourceForZipPath -DestinationPath $finalZipPath

# delete unneeded folder
Remove-Item -Path $sourceInDistrFolder -Recurse