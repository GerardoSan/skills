#!/bin/bash

# Setup script for Workload Identity Federation with GitHub Actions
# Run this script once to configure OIDC for your GCP project

set -e

# Configuration
PROJECT_ID="${1:-$(gcloud config get-value project)}"
POOL_NAME="github-actions-pool"
PROVIDER_NAME="github-provider"
SERVICE_ACCOUNT_NAME="terraform-sa"
REPO_OWNER="${2:-$(git config remote.origin.url | sed 's/.*github.com[:/]\([^/]*\)\/.*/\1/')}"
REPO_NAME="${3:-$(basename $(git rev-parse --show-toplevel))}"

echo "Setting up Workload Identity Federation for GitHub Actions"
echo "Project ID: $PROJECT_ID"
echo "Repository: $REPO_OWNER/$REPO_NAME"

# Enable required APIs
echo "Enabling required APIs..."
gcloud services enable iam.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudbuild.googleapis.com

# Create Workload Identity Pool
echo "Creating Workload Identity Pool..."
gcloud iam workload-identity-pools create "$POOL_NAME" \
  --location="global" \
  --display-name="GitHub Actions Pool"

# Get the full pool ID
POOL_ID=$(gcloud iam workload-identity-pools describe "$POOL_NAME" \
  --location="global" \
  --format="value(name)")

echo "Pool ID: $POOL_ID"

# Create Workload Identity Provider
echo "Creating Workload Identity Provider..."
gcloud iam workload-identity-pools providers create "$PROVIDER_NAME" \
  --location="global" \
  --workload-identity-pool="$POOL_NAME" \
  --display-name="GitHub Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.actor=assertion.actor,attribute.branch=assertion.ref" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# Get the provider ID
PROVIDER_ID=$(gcloud iam workload-identity-pools providers describe "$PROVIDER_NAME" \
  --location="global" \
  --workload-identity-pool="$POOL_NAME" \
  --format="value(name)")

echo "Provider ID: $PROVIDER_ID"

# Create Service Account
echo "Creating Service Account..."
gcloud iam service-accounts create "$SERVICE_ACCOUNT_NAME" \
  --display-name="Terraform Service Account" \
  --description="Service account for Terraform GitHub Actions"

# Grant necessary permissions to Service Account
echo "Granting permissions to Service Account..."
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/container.admin"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/cloudkms.admin"

# Allow GitHub Actions to impersonate the Service Account
echo "Setting up impersonation..."
gcloud iam service-accounts add-iam-policy-binding \
  "${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_ID}/locations/global/workloadIdentityPools/${POOL_NAME}/attribute.repository/${REPO_OWNER}/${REPO_NAME}" \
  --role="roles/iam.workloadIdentityUser"

# Create GCS bucket for Terraform state
echo "Creating GCS bucket for Terraform state..."
BUCKET_NAME="terraform-state-${PROJECT_ID}"
if ! gsutil ls "gs://$BUCKET_NAME" > /dev/null 2>&1; then
  gsutil mb -p "$PROJECT_ID" -l "us-central1" "gs://$BUCKET_NAME"
  gsutil versioning set on "gs://$BUCKET_NAME"
  gsutil iam ch "serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com:objectAdmin" "gs://$BUCKET_NAME"
  echo "Created bucket: gs://$BUCKET_NAME"
else
  echo "Bucket already exists: gs://$BUCKET_NAME"
fi

# Create KMS key for state encryption (optional)
echo "Creating KMS key ring and key..."
KEYRING_NAME="terraform-keyring"
KEY_NAME="terraform-state-key"

gcloud kms keyrings create "$KEYRING_NAME" --location="global" || true
gcloud kms keys create "$KEY_NAME" \
  --location="global" \
  --keyring="$KEYRING_NAME" \
  --purpose="encryption" \
  --rotation-period="90d" || true

# Grant KMS permissions
gcloud kms keyrings add-iam-policy-binding "$KEYRING_NAME" \
  --location="global" \
  --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/cloudkms.cryptoKeyEncrypterDecrypter"

# Get KMS key ID
KMS_KEY_ID=$(gcloud kms keys describe "$KEY_NAME" \
  --location="global" \
  --keyring="$KEYRING_NAME" \
  --format="value(name)")

echo "KMS Key ID: $KMS_KEY_ID"

# Output GitHub Secrets
echo ""
echo "=== GitHub Secrets Configuration ==="
echo "Add these secrets to your GitHub repository:"
echo ""
echo "GCP_PROJECT_ID: $PROJECT_ID"
echo "GCP_WORKLOAD_IDENTITY_PROVIDER: $PROVIDER_ID"
echo "GCP_SERVICE_ACCOUNT: ${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
echo "STATE_ENCRYPTION_KEY: $KMS_KEY_ID"
echo ""
echo "=== Setup Complete ==="
echo "Your GitHub Actions workflow can now authenticate to GCP using OIDC!"
echo ""
echo "Next steps:"
echo "1. Add the secrets to your GitHub repository"
echo "2. Push your code to trigger the workflow"
echo "3. Monitor the deployment in the Actions tab"
