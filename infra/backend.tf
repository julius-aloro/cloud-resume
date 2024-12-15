terraform {
  backend "s3" {
    bucket = "tfstate-s3-backend-000"
    key    = "cloud-resume/tfstate"
    region = "ap-southeast-1"
  }
}