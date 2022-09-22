variable "do_token" {
  type        = string
  description = "Digital Ocean Token"
}

variable "domain_name" {
  type        = string
  description = "Domain Name"
  default     = ["wayofthesys.com"]
}
