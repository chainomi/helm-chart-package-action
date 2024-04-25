
#!/bin/bash

set -xe

PROJECT_ID=$1
PROJECT_NUMBER=$2
service_account_email=$3

github_org="chainomi"
github_repo="helm-chart-package-action"

identity_pool_name="git-hub-pool-1"
identity_pool_display_name="github-actions-pool-1"
identity_pool_provider_name="github-provider-1"

gcloud auth login 

gcloud iam workload-identity-pools create "$identity_pool_name" \
  --project="$PROJECT_ID" \
  --location="global" \
  --display-name="$identity_pool_display_name"


gcloud iam workload-identity-pools providers create-oidc "$identity_pool_provider_name" \
  --project="$PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="$identity_pool_name" \
  --display-name="$identity_pool_provider_name" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.aud=assertion.aud,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"

gcloud iam service-accounts add-iam-policy-binding "$service_account_email" \
  --project="$PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$identity_pool_name/attribute.repository/$github_org/$github_repo"


echo "workload_identity_provider = $(gcloud iam workload-identity-pools providers describe $identity_pool_provider_name \
  --project="$PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="$identity_pool_name" \
  --format="value(name)")"