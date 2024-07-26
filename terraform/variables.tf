variable "hostname" {
  type	  = string
  default = "ubuntuvm01"
}

variable "username" {
  type	  = string
  default = "toor"
}

variable "user_password_hash" {
  type	  = string
  default = "$6$x7ru7Q46frz7H2S0$1vrpgX0RlO.yWgrEGoqVt01dRPxtkJiPpLSdYe7pZW642WocXAYOnoxjCvMa8SKggo0IvAakKF1.3Iq3oI3CA1"
}

variable "user_ssh_pub_key" {
  type	  = string
  default = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNKEtzxRf0JPPaCmbF8TnFNCk3ohhbnBuheDagLF36/CMMcMm8XmnalYJqWLHOeGWY8yKysyFnWxJmoe+wOlMEI= smak@splashbook"
}

variable "ext_ip_addr" {
  type	  = any
#  default = "192.168.122.146"
  default = "192.168.178.146"
}

variable "ext_ip_netmask" {
  type	  = any
  default = "24"
}

variable "ext_ip_gateway" {
  type	  = any
  default = "192.168.178.1"
}

variable "int_ip_addr" {
  type	  = string
  default = "10.200.16.98"
}

variable "int_ip_netmask" {
  type	  = string
  default = "29"
}

variable "int_ip_gateway" {
  type	  = string
  default = "10.200.16.97"
}
