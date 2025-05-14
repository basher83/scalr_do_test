terraform {
  backend "remote" {
 
    hostname = "the-mothership.scalr.io"
    workspaces {
      name = "test-run"
    }
  }
}