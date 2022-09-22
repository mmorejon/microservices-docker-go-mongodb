variable "do_token" {
  type        = string
  description = "Digital Ocean Token"
}

variable "domain_name" {
  type        = list 
  description = "Domain Name"
  default     = ["wayofthesys.org"]
}
