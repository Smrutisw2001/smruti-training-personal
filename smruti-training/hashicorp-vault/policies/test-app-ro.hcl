# Example of a simple read-only policy for "test-app"
path "apps/data/test-app" {
  capabilities = ["read", "list"]
}
