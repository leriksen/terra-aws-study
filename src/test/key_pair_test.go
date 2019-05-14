package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/test-structure"
)

const VAULT_CLUSTER_S3_BACKEND_PATH = "examples/vault-s3-backend"

const VAR_ENABLE_S3_BACKEND = "enable_s3_backend"
const VAR_S3_BUCKET_NAME = "s3_bucket_name"
const VAR_FORCE_DESTROY_S3_BUCKET = "force_destroy_s3_bucket"

// Test the key_pair example by:
//
// 1. Copy the code in this repo to a temp folder so tests on the Terraform code can run in parallel without the
//    state files overwriting each other.
// 2. Deploy the key pair using the example Terraform code
// 4. verify the key pair exists using the AWS console
// 5. Run the tests
func runVerifyKeyPairTest(t *testing.T, amiId string, awsRegion, sshUserName string) {
	examplesDir := test_structure.CopyTerraformFolderToTemp(t, REPO_ROOT, VAULT_CLUSTER_S3_BACKEND_PATH)

	defer test_structure.RunTestStage(t, "teardown", func() {
		teardownResources(t, examplesDir)
	})

	defer test_structure.RunTestStage(t, "log", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, examplesDir)
		keyPair := test_structure.LoadEc2KeyPair(t, examplesDir)

		getVaultLogs(t, "vaultClusterWithS3Backend", terraformOptions, amiId, awsRegion, sshUserName, keyPair)
	})

	test_structure.RunTestStage(t, "deploy", func() {
		uniqueId := random.UniqueId()
		terraformVars := map[string]interface{}{
			VAR_ENABLE_S3_BACKEND:       boolToTerraformVar(true),
			VAR_S3_BUCKET_NAME:          s3BucketName(uniqueId),
			VAR_FORCE_DESTROY_S3_BUCKET: boolToTerraformVar(true),
		}
		deployCluster(t, amiId, awsRegion, examplesDir, uniqueId, terraformVars)
	})

	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, examplesDir)
		keyPair := test_structure.LoadEc2KeyPair(t, examplesDir)

		cluster := initializeAndUnsealVaultCluster(t, OUTPUT_VAULT_CLUSTER_ASG_NAME, sshUserName, terraformOptions, awsRegion, keyPair)
		testVaultUsesConsulForDns(t, cluster)
	})
}
