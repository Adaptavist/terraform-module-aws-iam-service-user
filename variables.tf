variable "username" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "policy" {
  description = "policy to attach to the user so it can perform its actions"
  type        = string
}