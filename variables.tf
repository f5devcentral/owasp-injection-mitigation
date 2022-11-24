variable "api_cert" {
	type = string
	default = "certificate.cert"
}
        
variable "api_key" {
  	type = string
  	default = "private_key.key"
}

variable "api_url" {
	type = string
	default = "https://<tenant>.console.ves.volterra.io/api"
}

variable "namespace" {
	type = string
	default = "automation-apisec"
}

variable "lbname" {
	type = string
	default = "automation-injection-httplb"
}

variable "domain" {
	type = string
	default = "<domain>"
}

variable "originname" {
	type = string
	default = "automation-injection-originpool"	
}

variable "originip" {
	type = string
	default = "15.206.170.72"	
}

variable "originport" {
	type = string
	default = "80"	
}
