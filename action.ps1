# HelloID-Task-SA-Target-Jira-UserCreate
########################################
# Form mapping
$formObject = @{
    displayName  = $form.displayName
    name         = $form.userName
    emailAddress = $form.emailAddress
    notification = $true
}

try {
    Write-Information "Executing Jira action: [UserCreate] for: [$($formObject.DisplayName)]"
    $auth = $($JiraUserName) + ':' + $($JiraApiToken)
    $encoded = [System.Text.Encoding]::UTF8.GetBytes($auth)
    $authorization = [System.Convert]::ToBase64String($Encoded)
    $splatParams = @{
        Uri         = "$($JiraBaseUrl)/rest/api/latest/user"
        Method      = 'POST'
        ContentType = 'application/json'
        Body        = ([System.Text.Encoding]::UTF8.GetBytes(($formObject | ConvertTo-Json)))
        Headers     = @{
            'Authorization' = "Basic $($authorization)"
        }

    }
    $response = Invoke-RestMethod @splatParams

    $auditLog = @{
        Action            = 'CreateAccount'
        System            = 'Jira'
        TargetIdentifier  = $response.accountId
        TargetDisplayName = $response.displayName
        Message           = "Jira action: [UserCreate] for: [$($formObject.DisplayName)] executed successfully"
        IsError           = $false
    }
    Write-Information -Tags 'Audit' -MessageData $auditLog
    Write-Information "Jira action: [UserCreate] for: [$($formObject.DisplayName)] executed successfully"
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'CreateAccount'
        System            = 'Jira'
        TargetIdentifier  = ''
        TargetDisplayName = $formObject.displayName
        Message           = "Could not execute Jira action: [UserCreate] for: [$($formObject.DisplayName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    if ($($ex.Exception.GetType().FullName -eq "Microsoft.PowerShell.Commands.HttpResponseException")) {
        $auditLog.Message = "Could not execute Jira action: [CreateAccount] for: [$($formObject.DisplayName)], error: $($ex.ErrorDetails.Message)"
        Write-Error "Could not execute Jira action: [CreateAccount] for: [$($formObject.DisplayName)], error: $($ex.ErrorDetails.Message)"
    } else {
        Write-Information -Tags "Audit" -MessageData $auditLog
        Write-Error "Could not execute Jira action: [UserCreate] for: [$($formObject.DisplayName)], error: $($ex.Exception.Message)"
    }
}
########################################
