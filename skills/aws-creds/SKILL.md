---
name: aws-creds
description: Authenticate to AWS using doormat for the agentic_experience_dev account.
compatibility: opencode
metadata:
  audience: engineers
  scope: aws-authentication
  style: concise
---

## What I do
- Authenticate to AWS via doormat and export credentials into the current shell session.

## When to use me
Use this skill when you need AWS credentials to run commands against the agentic_experience_dev account (e.g., before running Terraform, AWS CLI commands, or deploying infrastructure).

## Process
1. Run `doormat login` to authenticate.
2. Run `eval $(doormat aws --account agentic_experience_dev)` to export AWS credentials into the shell environment.
3. Verify credentials are working with `aws sts get-caller-identity`.
