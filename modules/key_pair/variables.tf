variable "name" {
  type        = "string"
  description = "key pair name"
}

variable "path" {
  type        = "string"
  description = "location for storage of the local key in the pair"
  default     = "keys"
}

variable "env" {
  type        = "string"
  default     = "default"
  description = "key pair env, becomes key name suffix"
}
