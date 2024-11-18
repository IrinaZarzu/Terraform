locals {
  common_tags = {
    company = var.company
    project = "${var.company}-${var.project}" # interpolation = referencing an input variable inside of a larger string/ turning a TF expression into a string
  }
}
