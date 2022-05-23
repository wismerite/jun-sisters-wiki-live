# jun-sisters-wiki-live

idk why i used "live", it was just in the book okay??

## TODO list

### hi-pri

* move jswiki and nginx helm stuff into terraform
* move k8s secret and ingress rules into terraform
* migrate heroku jswiki app to k8s cluster
  - database export/import
  - make sure replicas is set to 1 at first, can bump to 2 afterwards
* monitoring 
  - https://www.digitalocean.com/community/tutorials/how-to-set-up-digitalocean-kubernetes-cluster-monitoring-with-helm-and-prometheus-operator
* set up SSL/TLS for site
  - passthrough to app
* review firewall configurations, disable public access on all resources possible
* ~~set up lb on k8s or something, check DO console it'll have instructions for it~~
  - ~~they want me to use kubectl for it~~
* ~~register jun-sisters.gay~~ - bought from namecheap by ella
* ~~set up wiki admin email account~~
* ~~ set up gateway droplet~~ 
  - ~~might just need the firewall here~~
  - ended up using an lb instead
* ~~remote backend~~
  - ~~use spaces~~
* ~~get vanilla jswiki working on DO cluster~~


### low-pri
* move secrets to secrets store, for now secret-per-person
  - hashicorp vault?
  - sounds like work
  - http://external-secrets.io/v0.5.2/
* linters


## digital ocean stuff for jun-sisters wiki 

* documentation for the digital-ocean terraform provider: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs

## git strategy
one branch, main.  envs are separated by dirs, backend is in its own dir.  modules are pulled in from jun-sisters-wiki-modules repo based on tag (tags use semantiv versioning), which also uses one branch.

## binaries you'll want
1. `kubectl` - official k8s cli tool. version must be v1.21.x, v1.22.x, or v1.23.x (cluster is running 1.22.x, kubectl must be within 1 minor version)
2. doctl - digital ocean cli tool.  any version.  https://docs.digitalocean.com/reference/doctl/how-to/install/
3. terraform - duh. https://www.terraform.io/downloads

## dev env setup
1. clone this repo
2. set up a digital ocean personal access token as an env var (talk to ella to get access or a token or whatever, she's not sure how she wants to handle that yet): 
  `export TF_VAR_do_token="bleep"`
3. get a Spaces access key and secret from ella, put those in env vars "DO_SPACES_ACCESS_KEY" and "DO_SPACES_SECRET_KEY" respectively
4. \o/ u did it (there's nothing else to do for setup rn)

## how to run
cd to the env of your choice, run init, plan, apply:

```
cd infra/dev
./tf_init.sh
terraform plan
terraform apply
```

## tf_init.sh
this is a small wrapper to allow us to pass in secrets from
environment variables instead of commiting them into a git repository (very bad!!)

## how to update modules
go to (jun-sisters-wiki-modules)[https://github.com/wismerite/jun-sisters-wiki-modules], clone it, and when you make any changes make sure to add an annotated tag to your commit and then open a pr.  once it's merged, you can submit a PR here too to update the source paths in main.tf for the env you want to modify to point to the correct module version.

## hosting outline

### single node k8s cluster for dev env
- 1x managed database (Postgres)
  - used by jswiki
- 1x 1-node k8s cluster
  - 1x k8s volume
- 1x "space"
  - tf remote state

### three-node k8s cluster for prod env
- 1x managed database (Postgrest)
  - used by jswiki
- 1x 3-node k8s cluster
  - 1x k8s volume
  - 1x k8s loadbalancer
- 1x "space"
  - tf remote state




