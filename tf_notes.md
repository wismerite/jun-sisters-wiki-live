## TF learning notes

### terminology notes
- workspace == "environment"

### some notes on the commands
- **terraform init** 
  - grabs and uses "backend" libraries
  - backend is, i think, usually:
    - a provider
    - tf state
- **terraform plan**
  -  not stricly necessary, but as good as for sanity-checking
- **terraform apply**
  - run plan before this
- **terraform graph**
  - cool, but not stricly necessary to run
- **setting vars from cmdline**
  - (using the -var option)
  - a file (using the -var-file option), 
  - or via an environment variable
    - (Terraform looks for environment variables of the name TF_VAR_<variable_name>).

### notes on HCL
- **tf docstring syntax:**
```
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p 8080 &
                EO
```

- **tf variable syntax:**
```
  variable "NAME" {
    [CONFIG ...]
  }
```

- **reference a var:**
```
  var.<VARIABLE_NAME>
```
-  **tf types:**
  - [ string, number, bool, list, map, set, object, tuple, any ]

-  **tf maps:**
```
    variable "map_example" {
        description = "An example of a map in Terraform"
        type = map(string)
        default = {
            key1 = "value1"
            key2 = "value2"
            key3 = "value3"
        }
    }
```

- **interpolation syntax:**
  - "Hello my name is ${var.my_name}!"


### interesting quotes
> Providers should be configured by the user of the
module and not by the module itself.

> In general, embedding one programming language
inside another makes it more difficult to maintain each
one, so let’s pause here for a moment to externalize the embedded language.



### terraform_remote_state
- **NOTE:** "data_source" versus "data_store"

- remote state very important for collaboration!
  - we'll be using postgres since we'll already have a db server

- **example usage in tf module** 
```
  ${data.terraform_remote_state.db.outputs.address}
```

## random junk
- list of possible resource types that can belong to a project:
  `resource types must be one of the following: AppPlatformApp Bucket Database Domain DomainRecord Droplet Firewall FloatingIp Image Kubernetes LoadBalancer MarketplaceApp Saas Volume`
- terraform_remote_state

## open questions
is using two different repos common?  i like the idea of versioning modules, but unsure.