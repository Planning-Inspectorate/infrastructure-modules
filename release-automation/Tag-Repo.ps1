param (
    [String]$SourceBranch,
    [String]$SourceDirectory,
    [String]$Mode="plan"
)

$planModeValue = "plan"
write-host "Running in $Mode mode"
write-host "SourceBranch: $SourceBranch"
write-host "SourceDirectory: $SourceDirectory"

# Retrieve information from taginfo.json
$tagInfoJson = Get-Content (join-path -Path $SourceDirectory -ChildPath versioninfo.json) | ConvertFrom-Json
$tagInfoMajorVersion = [int]$tagInfoJson.major_version_number

# Only perform the automation if the current branch is master or a branch of the form "<digits>.x", e.g. 1.x, 14.x
if ( ($SourceBranch -match "^[\d]*\.x$") -or ($SourceBranch -eq "main" ) ) {
    # Derive latest existing minor version and increment
    $commits = $(git --no-pager log --format="%H %D")
    # write-host "Commits: $commits"

    $isLatestCommitTagged = ($commits[0] -like "*tag*") # string matches wildcard pattern
    write-host "IsLatestCommit? $isLatestCommitTagged" # This is where the error is happening in the pipeline - stating False and then jumping to line 37. It is not picking up the latest commit and the HEAD is detached.

    if ( $isLatestCommitTagged ) {
        write-output "Latest commit is already tagged - no work to do" # It is not the latest commit as this message would be read

############ From here
    } else {
        $commitCounter = 0
        foreach ($commit in $commits) {
            if ($commit -match "^.*tag:\s(?<tag>[\d\.]*).*") {
                $existingVersion = $Matches.tag # matches contains last match values
                break
            }
            $commitCounter++
        }
        if (! $existingVersion) {
            throw "There is no tagged commit on this branch. One needs to exist to derive next tag value" # can this error message be changed for the system to echo something itself?
        }
########## To here is where it is erroring...

        # Derive new version number
        write-host "ExistingVersion is $existingVersion"
        [int]$existingMajorVersion = (($existingVersion -split "\.")[0]).Trim() # get the first occurrence of a number
        [int]$existingMinorVersion = (($existingVersion -split "\.")[1]).Trim() # get the second occurrence of a number

        if ($tagInfoMajorVersion -gt $existingMajorVersion) {
            $newMajorVersion = $tagInfoMajorVersion
            $newMinorVersion = 0

            # Create branch from previous commit and push to remote
            $previousCommit = ($commits[$commitCounter] -split "\s+")[0] # Gets full commit hash
            $branchName = "$existingMajorVersion.x"
            if ($Mode -eq $planModeValue) {
                write-host "Running in plan mode. Would run: git branch $branchName $previousCommit; git push -u origin $branchName"
            } else {
                git branch $branchName $previousCommit
                git push -u origin $branchName
            }
        } else {
            $newMajorVersion = $existingMajorVersion
            $newMinorVersion = $existingMinorVersion + 1
        }
        $newVersion = "$newMajorVersion.$newMinorVersion"
        write-host "New version is $newVersion"

        # Tag latest commit with latest minor version tag
        write-host "Create tag and push to remote"
        if ($Mode -eq $planModeValue) {
            write-host "Running in plan mode. Would run: git tag $newversion; git push origin $newVersion"
        } else {
            $result = $(git tag $newversion)
            $result = $(git push origin $newVersion)
        }
    }
} else {
    write-host "No work to do - this is not a commit on a branch that should be tagged" # saying that this commmit is irrelevant because it's not on a branch that should be tagged
}
