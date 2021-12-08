# Linkerd2 Terraform module

Terraform module for deploying Linkerd2 and Linkerd viz to the AWS EKS cluster by `helm_release`.

Benefits:
- Simple installation
- Automatic creation TLS certificate
- No any `values.yaml` files
- Change what you need before deploying with variables


## Usage

You can find desired example in examples folder. 

```
module "linkerd2" {
  source = "OuFinx/linkerd2/helm"

  # The Linkerd-Viz extension contains observability and visualization components for Linkerd.
  viz_create = true
}
```

**Note:** Don't use 2.11.1 VIZ version due to this PR [All linkerd-viz pods in CrashLoopBackOff](https://github.com/linkerd/linkerd2/issues/7233)


## Certificates

Certificates for deploying Linkerd2 will be created automatically by Terraform. You can change the number of hours after which the certificate will be invalidated. By default is 10 years for CA certificate and 1 year for Issuer certificate.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_validity_period_hours_ca"></a> [validity\_period\_hours\_ca](#input\_validity\_period\_hours\_ca) | The number of hours after initial issuing that the certificate will become invalid. Default is 10 years. | `number` | `87660` | no |
| <a name="input_validity_period_hours_issuer"></a> [validity\_period\_hours\_issuer](#input\_validity\_period\_hours\_issuer) | The number of hours after initial issuing that the certificate will become invalid. Default is 1 year. | `number` | `8760` | no |
| <a name="input_subject_common_name"></a> [subject\_common\_name](#input\_subject\_common\_name) | The domain name you wish to secure with your certificate. | `string` | `"identity.linkerd.cluster.local"` | no |
| <a name="input_subject_organization"></a> [subject\_organization](#input\_subject\_organization) | Organization name. | `string` | `null` | no |
| <a name="input_allowed_uses"></a> [allowed\_uses](#input\_allowed\_uses) | List of keywords each describing a use that is permitted for the issued certificate. | `list(any)` | <pre>[<br>  "crl_signing",<br>  "cert_signing",<br>  "server_auth",<br>  "client_auth"<br>]</pre> | no |
| <a name="input_linkerd_version"></a> [linkerd\_version](#input\_linkerd\_version) | The version of linkerd2 chart. | `string` | `"2.11.1"` | no |
| <a name="input_linkerd_variables"></a> [linkerd\_variables](#input\_linkerd\_variables) | You can provide extra varaibles to the linkerd chart | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_linkerd_production_enable"></a> [linkerd\_production\_enable](#input\_linkerd\_production\_enable) | Enable HA deploying for production environment. | `bool` | `false` | no |
| <a name="input_linkerd_services_resources"></a> [linkerd\_services\_resources](#input\_linkerd\_services\_resources) | This is default variables that will be added for all services. You can override it. | <pre>object({<br>    cpu_request    = string<br>    cpu_limit      = string<br>    memory_request = string<br>    memory_limit   = string<br>  })</pre> | <pre>{<br>  "cpu_limit": "500m",<br>  "cpu_request": "100m",<br>  "memory_limit": "250Mi",<br>  "memory_request": "50Mi"<br>}</pre> | no |
| <a name="input_viz_create"></a> [viz\_create](#input\_viz\_create) | n/a | `bool` | `false` | no |
| <a name="input_viz_variables"></a> [viz\_variables](#input\_viz\_variables) | You can provide extra varaibles to the linkerd-viz chart | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_viz_production_enable"></a> [viz\_production\_enable](#input\_viz\_production\_enable) | Enable HA deploying for production environment. | `bool` | `false` | no |
| <a name="input_viz_services_resources"></a> [viz\_services\_resources](#input\_viz\_services\_resources) | This is default variables that will be added for all services. You can override it. | <pre>object({<br>    cpu_request    = string<br>    cpu_limit      = string<br>    memory_request = string<br>    memory_limit   = string<br>  })</pre> | <pre>{<br>  "cpu_limit": "500m",<br>  "cpu_request": "100m",<br>  "memory_limit": "250Mi",<br>  "memory_request": "50Mi"<br>}</pre> | no |

## Outputs

No outputs.
