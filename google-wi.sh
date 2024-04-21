
#!/bin/bash

set -xe

PROJECT_ID=$1
PROJECT_NUMBER=$2
service_account_email=$3
org="chainomi"
repo="helm-chart-package-action"


identity_pool_name="git-hub-pool-1"
identity_pool_provider_name="github-provider-1"

gcloud auth login 

gcloud iam workload-identity-pools create "$identity_pool_name" \
  --project="$PROJECT_ID" \
  --location="global" \
  --display-name="github-actions-pool-1"


gcloud iam workload-identity-pools providers create-oidc "$identity_pool_provider_name" \
  --project="$PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="$identity_pool_name" \
  --display-name="$identity_pool_provider_name" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.aud=assertion.aud" \
  --issuer-uri="https://token.actions.githubusercontent.com"

gcloud iam service-accounts add-iam-policy-binding "$service_account_email" \
  --project="$PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/$identity_pool_name/providers/$identity_pool_provider_name"


#976036132338

gcloud iam service-accounts add-iam-policy-binding "terraform-52@useful-circle-358120.iam.gserviceaccount.com" \
--project="useful-circle-358120" \
--role="roles/iam.workloadIdentityUser" \
--member="principalSet://iam.googleapis.com/projects/976036132338/locations/global/workloadIdentityPools/git-hub-pool-1/attribute.repository/chainomi/helm-chart-package-action"


gcloud iam workload-identity-pools providers describe "github-provider-1" \
  --project="useful-circle-358120" \
  --location="global" \
  --workload-identity-pool="git-hub-pool-1" \
  --format="value(name)"