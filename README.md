# FASRC OnDemand Loop Deployment Builds

This repository contains the configuration and automation pipeline used to manage **deployment builds** for the [OnDemand Loop](https://github.com/IQSS/ondemand-loop) application, tailored for the **Cannon** and **FASSE** clusters at FASRC.

The Harvard Dataverse landing page to inform users of the access requirements to use OnDemand Loop is managed in thus repo.
The landing page is deployed as a GitHub Page: https://hmdc.github.io/fasrc-ondemand-loop/dv_external_tools/landing.html

## Overview

- 🚀 **Deployment Build Management**  
  Orchestrates creation of QA and production-ready builds via GitHub Actions, based on issue commands and tags.

- ⚙️ **FASRC-Specific Configuration**  
  Hosts and maintains the environment-specific configuration needed to deploy OnDemand Loop as a Passenger application within FASRC.

- **Dataverse External Tools landing page**
  To improve the UX for Dataverse users without and FASRC account, this page will allow us to explain what is requiried o access OnDemand Loop.

- 🧩 **Separation of Concerns**  
  Application code lives in [`IQSS/ondemand-loop`](https://github.com/IQSS/ondemand-loop).  
  This repository is responsible for building and deploying that code into FASRC environments.

## Usage

Deployment builds are triggered by creating a **GitHub issue** and commenting specific slash commands:

### 1. Create a QA Deployment Build

Open an issue with a title like:
```
Deployment Build: version: v0.5.13+2025-07-01
```

Then comment:
```
/deployment_build env=QA
```

This will build and publish the specified version to the `iqss_qa` branch.

### 2. Approve QA and Promote to Production

Once the QA deployment is verified, comment:
```
build approved
```

Then publish to production with:
```
/deployment_build env=Production
```

This pushes the same build to a versioned production branch (e.g., `iqss_production_v0.5.13+2025-07-01`).

## Environment

This repository:

- Runs GitHub Actions to coordinate builds and deploy GitHub pages.
- Prepares the application with FASRC-specific configs.
- Publishes artifacts by pushing to appropriate deployment branches.
- **Does not deploy**—deployment is handled externally (e.g., via Puppet).

## Project Structure

- `.github/workflows/`: Build and deployment automation workflows.
- `.github/scripts/`: Shared utility scripts for workflow logic.
- `config/`: Contains FASRC-specific configuration.
- `dv_external_tools/`: Static HTML landing page to integrate with Harvard Dataverse.

## Requirements

- Only authorized users may run deployment commands via issue comments.
- Manual Puppet deployment picks up published branches.
