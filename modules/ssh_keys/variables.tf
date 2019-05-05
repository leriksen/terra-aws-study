variable "name" {
  type        = "string"
  description = "key name prefix"
}

variable "path" {
  type        = "string"
  description = "location for local key storage"
}

variable "env" {
  type        = "string"
  description = "key name suffix"
}
