---
name: Deployment Build
about: Follow these steps to prepare and publish a deployment build for QA and Production
title: "Deployment Build: version: "
labels: deployment_build
assignees: ''
---

Follow the steps below to prepare a deployment build of OnDemand Loop.

> This process creates and publishes build artifacts to environment branches. **Deployment itself is performed externally (e.g., by Puppet).**

1. **Prepare the issue**
    - Ensure the title starts with `Deployment Build: version: <tag>`.  
      Example:
      ```
      Deployment Build: version: v0.5.13+2025-07-01
      ```
    - Assign at least one maintainer to this issue.
    - Add the label `deployment_build`

2. **Create a QA deployment build**
    - Comment the following slash command on this issue:
      ```
      /deployment_build_candidate
      ```
    - This builds the specified version and pushes it to the `iqss_qa` branch.

3. **Test and approve**
    - Test the deployment in the QA environment.
    - When ready, approve the deployment by commenting:
      ```
      build approved
      ```

4. **Create a Production deployment build**
    - After approval, publish to production by commenting:
      ```
      /deployment_build_release type=<patch|minor|major>
      ```
    - Creates a GitHub release based on the `VERSION` file.
    - Pushes the same version to a new production branch (e.g., `iqss_production_<version>`).

5. **Mark release as deployed**
    - Once the production deployment is completed and verified (via external system like Puppet), mark the release as deployed by commenting:
      ```
      /deployment_build_deployed
      ```
    - This updates the release issue with:
        - A `production_deployed` label
        - A moving Git tag `production_deployed` pointing to the deployed release
        - A confirmation comment

6. **Finish up**
    - The workflow will comment with the result of the build publication and deployment marking, including a link to the workflow run.
    - Close this issue once the production deployment is complete and verified.

_Only authorized users can execute the slash commands above._
