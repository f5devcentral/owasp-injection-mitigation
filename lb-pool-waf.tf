resource "volterra_origin_pool" "op-ip-internal" {
  name                   = var.originname
  //Name of the namespace where the origin pool must be deployed
  namespace              = var.namespace
   origin_servers {
    public_ip {
      ip= var.originip
    }
    labels= {}
  }
  no_tls = true
  port = var.originport
  endpoint_selection     = "LOCALPREFERED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}

//Definition of the WAAP WAF Policy
resource "volterra_app_firewall" "waap-tf" {
  name      = "automation-owasp-waf"
  namespace = var.namespace
  allow_all_response_codes = true
  default_anonymization = true
  use_default_blocking_page = true
  default_bot_setting = true
  default_detection_settings = true
  use_loadbalancer_setting = true
  blocking = true
  detection_settings {
	signature_selection_setting {
	  default_attack_type_settings = true
	  high_medium_low_accuracy_signatures = true
	}
	enable_suppression = true
	enable_threat_campaigns = true
	default_violation_settings = true
   }
}

resource "volterra_http_loadbalancer" "lb-http-tf" {
  depends_on = [volterra_origin_pool.op-ip-internal, volterra_app_firewall.waap-tf]
  //Mandatory "Metadata"
  name      = var.lbname
  //Name of the namespace where the origin pool must be deployed
  namespace              = var.namespace
  domains                = [var.domain]
  
  http {
    dns_volterra_managed = true
  }
  default_route_pools {
      pool {
        name = var.originname
        namespace = var.namespace
      }
      weight = 1
    }
	
  //Mandatory "VIP configuration"
  advertise_on_public_default_vip = true
  //End of mandatory "VIP configuration"
  //Mandatory "Security configuration"
  no_service_policies = true
  no_challenge = true
  disable_rate_limit = true
  app_firewall {
    name      = "automation-owasp-waf"
	namespace = var.namespace
  }
  multi_lb_app = true
  user_id_client_ip = true
  source_ip_stickiness = true
}
