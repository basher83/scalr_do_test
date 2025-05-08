terraform {
  backend "remote" {
 

// Enter your HOSTNAME (xxxxx.scalr.io)

    hostname = "the-mothership.scalr.io"
    workspaces {
      name = "test-run"
    }
  }
}