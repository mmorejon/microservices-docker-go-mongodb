##########################################################################
# DO NOT MODIFY
#
# THIS FILE SHOULD LIVE IN .github/workflows/terrateam.yml
#
# Looking for the Terrateam configuration file? .terrateam/config.yml.
#
# See https://docs.terrateam.io/configuration/overview for details
##########################################################################
name: 'Terrateam Workflow'
on:
  workflow_dispatch:
    inputs:
      # The work-token is automatically passed in by the Terrateam backend
      work-token:
        description: 'Work Token'
        required: true
      api-base-url:
        description: 'API Base URL'
jobs:
  terrateam:
    permissions: # Required to pass credentials to the Terrateam action
        id-token: write
        contents: read
    runs-on: ubuntu-latest
    name: Terrateam Action
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v0
        with:
          create_credentials_file: 'true'
          workload_identity_provider: 'projects/1037290380438/locations/global/workloadIdentityPools/terrateam/providers/terrateam'
          service_account: 'terrateam'
          project_id: '1037290380438'
      - name: Run Terrateam Action
        id: terrateam
        uses: terrateamio/action@v1 # Do not replace with a custom image. Doing so may cause Terrateam to not operate as intended.
        with:
          work-token: '${{ github.event.inputs.work-token }}'
          api-base-url: '${{ github.event.inputs.api-base-url }}'
        env:
          SECRETS_CONTEXT: ${{ toJson(secrets) }}
