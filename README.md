# HelloID-Task-SA-Target-Jira-UserCreate

## Prerequisites

- [ ] Pre-defined variables: `JiraUserName`, `JiraPassword` and `JiraBaseUrl` created in your HelloID portal.

## Description

This code snippet executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties necessary to create a user while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

```json
{
    "displayName": "John Doe",
    "emailAddress": "JDoe@example",
    "name": "JohnDoe",
    "notification": false
}
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hashtable is appropriately adjusted to match your form fields. [See the Jira API documentation](https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-users/#api-rest-api-3-user-post)

3. Create a new user using the: `Invoke-RestMethod` cmdlet. The hash table called: `$formObject` is passed to the body of the: `Invoke-RestMethod` cmdlet as a JSON object.
