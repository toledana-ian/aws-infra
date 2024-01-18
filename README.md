# Personal Terraform Setup

This repo contains my personal configuration and setup files for Terraform.

## Getting Started

Before running any Terraform commands, ensure you have installed Terraform.

## Using the Configuration

This setup has organized into several environment-specific directories:

- `production/` for production environment setup
- `development/` for development environment setup
- `staging/` for staging environment setup
- `testing/` for testing environment setup
- `global/` for resources and configurations that are shared across environments.

Each of the environment directories contains Terraform configurations specific to that environment.

To use this configuration:

1. Clone this repository.
2. Navigate into the directory of the environment you're working with (e.g., `cd production`).
3. Run `terraform init` to initialize your Terraform environment.
4. Review the plan with `terraform plan`.
5. Apply the configuration with `terraform apply`.

Please note that `global/` includes things that are available to and can be imported by other environments. Be cautious while making changes to `global/`, as these will be reflected across all environments.

## Contributing

Not currently accepting contributions.

## Disclaimer

This setup is tailored for my personal use and may not meet your specific requirements. Use with caution.