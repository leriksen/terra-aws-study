package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
)

type testCase struct {
	Name       string                                   // Name of the test
	Func       func(*testing.T, string, string, string) // Function that runs test. Receives(t, amiId, awsRegion, sshUserName)
	Enterprise bool                                     // Run on ami with enterprise vault installed
}

type amiData struct {
	Name            string // Name of the ami
	PackerBuildName string // Build name of ami
	SshUserName     string // ssh user name of ami
	Enterprise      bool   // Install vault enterprise on ami
}

var testCases = []testCase{
	{
		"TestKeyPairExists",
		runKeyPAirExistsTest,
		false,
	},
	{
		"TestKeyPairFingerprint",
		runKeyPairFingerprintTest,
		true,
	},
}

func TestMainKeyPair(t *testing.T) {
	t.Parallel()

	test_structure.RunTestStage(t, "deploy_keypair", func() {
		awsRegion := aws.GetRandomRegion(t, nil, []string{"eu-north-1"})
		test_structure.SaveString(t, WORK_DIR, fmt.Sprintf("awsRegion-%s", ami.Name), awsRegion)

		// keyPairId = something.BuildKeyPair(....)
	})

	defer test_structure.RunTestStage(t, "delete_keypair", func() {
		for _, ami := range amisData {
			awsRegion := test_structure.LoadString(t, WORK_DIR, fmt.Sprintf("awsRegion-%s", ami.Name))
			// aws.DeleteKeyPair(t, awsRegion, keyPairId)
		}
	})

}
