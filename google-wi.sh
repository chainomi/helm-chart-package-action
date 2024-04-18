
#!/bin/bash

set -xe

PROJECT_ID=$1
PROJECT_NUMBER="976036132338"
service_account_email=$2
org="chainomi"
repo="helm-chart-package-action"


identity_pool_name="git-hub-pool"
identity_pool_provider_name="github-provider"

gcloud auth login 

gcloud iam workload-identity-pools create "$identity_pool_name" \
  --project="$PROJECT_ID" \
  --location="global" \
  --display-name="Github pool"


gcloud iam workload-identity-pools providers create-oidc "$identity_pool_provider_name" \
  --project="$PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="$identity_pool_name" \
  --display-name="$identity_pool_provider_name provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.aud=assertion.aud" \
  --issuer-uri="https://token.actions.githubusercontent.com"

gcloud iam service-accounts add-iam-policy-binding "$service_account_email" \
  --project="$PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$identity_pool_name/attribute.repository/$org/$repo"