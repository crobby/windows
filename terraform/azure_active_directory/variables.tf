variable "name" {
  type        = string
  description = "The name of the Active Directory instance you would like to provision."

  validation {
    condition     = endswith(var.name, "-ad")
    error_message = "Name must end with -ad"
  }
}

variable "standard_users" {
  type = list(object({
    name     = string
    password = string
  }))
  description = "The set of standard users to include in this ActiveDirectory instance"
  default = [
    {
      name     = "User1"
      password = "p@ssw0rd"
    },
    {
      name     = "User2"
      password = "p@ssw0rd"
    },
    {
      name     = "User3"
      password = "p@ssw0rd"
    },
    {
      name     = "User4"
      password = "p@ssw0rd"
    },{
      name     = "User5"
      password = "p@ssw0rd"
    },{
      name     = "User6"
      password = "p@ssw0rd"
    },
    {
      name     = "User7"
      password = "p@ssw0rd"
    },
    {
      name     = "User8"
      password = "p@ssw0rd"
    },
    {
      name     = "User9"
      password = "p@ssw0rd"
    },{
      name     = "User10"
      password = "p@ssw0rd"
    },
  ]
}

variable "default_password" {
  type        = string
  description = "The default password to use for all standard users"
  default     = "p@ssw0rd"
}

variable "gmsas" {
  type        = list(string)
  description = "The set of gMSAs to include in this ActiveDirectory instance"
  default     = ["GMSA1"]
}

variable "address_space" {
  type        = string
  description = "The address space of the virtual network this Active Directory instance resides in."
  default     = "10.0.0.0/16"
}

variable "ssh_public_key_path" {
  type        = string
  description = "The path to a public SSH key to be mounted on hosts."
  default     = "~/.ssh/id_rsa.pub"
}
