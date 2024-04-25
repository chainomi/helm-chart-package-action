

resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "example-pool"
  display_name              = "Name of pool"
  description               = "Identity pool for automated test"
  disabled                  = true
}

