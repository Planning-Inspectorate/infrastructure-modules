package tests

import (
	"log"
	"os"
	"os/exec"
	"runtime"
	"testing"

	terraform "github.com/gruntwork-io/terratest/modules/terraform"
	util "github.com/hiscox/terratestutilities"
)

func TestApplicationGateway(t *testing.T) {
	//* Log into the Azure-Cli as it is required by some local-exec types
	cSecret, cID, tenID, _, err := util.AzCliAuth()
	if err != nil {
		log.Fatal(err)
	}
	// execute differently depnding on OS
	args := []string{}
	c := "Undefined terminal"
	switch os := runtime.GOOS; os {
	case "windows":
		c = "cmd"
		args = []string{"login", "--service-principal", "--%",
			"-p", "\"" + cSecret + "\"",
			"-u", "\"" + cID + "\"",
			"--tenant", "\"" + tenID + "\""}
	case "linux":
		c = "/usr/bin/az"
		args = []string{"login", "--service-principal",
			"-p", cSecret,
			"-u", cID,
			"--tenant", tenID}
	default:
		log.Fatal("Unsupported OS")
	}
	cmd := exec.Command(c, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err = cmd.Run()
	if err != nil {
		log.Printf("Unable to log into Azure through the cli")
		log.Fatal(err)
	}

	t.Parallel()

	varFileName := "aag_ne"
	// varFile := os.Getenv("VARFILE")
	// if len(varFile) == 0 {
	// 	log.Fatal("Env var VARFILE not set")
	// }
	// // backend vars
	// url, u, p, repo, subpath, err := util.TfBackendArtifactory()
	// if err != nil {
	// 	log.Fatal(err)
	// }

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		// Vars: map[string]interface{}{
		// 	"example": expectedText,

		// We also can see how lists and maps translate between terratest and terraform.
		// 	"example_list": expectedList,
		// 	"example_map":  expectedMap,
		// },
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"tests/" + varFileName + ".tfvars"},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
		// Upgrade providers during init
		Upgrade: true,
		// set up backend config
		BackendConfig: map[string]interface{}{
			"resource_group_name":  os.Getenv("STATE_RESOURCE_GROUP_NAME"),
			"storage_account_name": os.Getenv("STATE_STORAGE_ACCOUNT_NAME"),
			"container_name":       "tfstate",
			"key":                  varFileName + ".tfstate",
		},
	}

	destroy, plan, apply, err := util.TfModes()
	if err != nil {
		log.Fatal(err)
	}
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	if destroy == "true" {
		defer terraform.Destroy(t, terraformOptions)
	}
	// This will run `terraform` under a designated mode(s) and fail the test if there are any errors
	terraform.Init(t, terraformOptions)
	if plan == "true" {
		terraform.Plan(t, terraformOptions)
	}
	if apply == "true" {
		terraform.Apply(t, terraformOptions)
	}
	// Run `terraform output` to get the values of output variables
	// storageWebEndpoint := terraform.Output(t, terraformOptions, "storage_web_endpoint")
	// actualExampleList := terraform.OutputList(t, terraformOptions, "example_list")
	// actualExampleMap := terraform.OutputMap(t, terraformOptions, "example_map")

	// config parameters for resty
	//client.SetTLSClientConfig(&tls.Config{InsecureSkipVerify: true})

	// Send a GET request to the endpoint
	// client := resty.New()
	// resp, err := client.R().
	// 	EnableTrace().
	// 	Get(storageWebEndpoint)

	// if err != nil {
	// 	log.Printf("Error: %v", err)
	// 	log.Printf("Trace info: %v", resp.Request.TraceInfo())
	// }

	// Tests
	// t.Run("expected return code of root path", func(t *testing.T) {
	// 	got := resp.StatusCode()
	// 	if got != 200 {
	// 		t.Errorf("got %v, expected %v", got, 200)
	// 	}
	// })

	// t.Run("expected content of root path", func(t *testing.T) {
	// 	got := resp.String()
	// 	if strings.Contains(got, "Greetings") {
	// 		t.Errorf("got %v, expected %v", got, 200)
	// 	}
	// })

	// Verify we're getting back the outputs we expect
	// assert.Equal(t, expectedText, actualTextExample)
	// assert.Equal(t, expectedText, actualTextExample2)
	// assert.Equal(t, expectedList, actualExampleList)
	// assert.Equal(t, expectedMap, actualExampleMap)
}
