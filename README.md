# gnosis

Welcome to gnosis!
This is a Redmine Plugin with the goal of making your development process easier to keep an overview of.

## What does this plugin do?
Gnosis is able to show you GitHub Pull Requests and Deployments that belong to a Redmine issue, all in its "details" page.  
To make this magic work there are only a few steps you have to follow and certain conventions to keep in mind.

### GitHub Webhooks configuration

### SemaphoreCI Webhooks configuration

### Conventions you need to keep
The plugin needs information on which Pull Requests belong to which issues, which is why there are set conventions for branch
naming. When you create a branch that is connected to a certain Issue it should be named as follows:
something/issue_number-description. The only important part of this is the /issue_number as that's how
the plugin is able to connect PRs to issues.

