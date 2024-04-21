# Helm Package and push to Google Cloud storage bucket

## Requirements
> 1. AWS CLI
> 3. Python
> 4. pip
> 5. Docker


## Instructions

### Setting up Google authentication
1. Setup workload_identity on google account 
2. Setup a service account with with required role to push to a cloud storage bucket
>  a. Create a json key from the service account 
>  b. Create a secret in github repo eg. `GOOGLE_CREDENTIALS`. Use the json key value from service account as value of the secret

### Setup Cloud storage bucket
1. Create a cloud storage bucket to recieve helm packages

### Configure Github workflow
1. Set the `charts_folder` environment variable to the folder the helm charts are located
2. Set the `cloud_storage_bucket` environment variable to name of the cloud storage bucket
3. 




