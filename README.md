# jun-sisters-wiki-live

idk why i used "live", it was just in the book okay??

## TODO list

### hi-pri
#### todo
* review firewall configurations, disable public access on all resources except lb
  - disable public ips on resources where possible, not sure if it's very configurable though.
* monitoring 
  - https://www.digitalocean.com/community/tutorials/how-to-set-up-digitalocean-kubernetes-cluster-monitoring-with-helm-and-prometheus-operator
* manually create DO space for wiki backups and configure it as a storage target in admin panel
  - manual creation so it's not accidentally deleted along with the rest of the project if tf destroy gets run
#### done
~~* configure wiki permissions~~
  - groups: mods, discordmembers
  - permissions: 
    - mods can see/edit everything, minus some admin stuff
    - discordmembers can see/edit everything except scripts, anything user- or admin- related, and anything under /mods
    - guests can't do anything except read pages which ARENT under /members or /mods
~~* set up generic group home pages~~
~~* set up wiki discord authentication~~
~~* enable http => https redirection for the wiki~~
  - done in ingress with: https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/#server-side-https-enforcement-through-redirect
~~* migrate heroku jswiki app to k8s cluster~~
  - not done, just starting fresh on new wiki since there wasn't content on the old wiki anyway and it could be configured better
* ~~set up SSL/TLS for site~~
* ~~move k8s secret and ingress rules into terraform~~
* ~~move jswiki and nginx helm stuff into terraform~~
* ~~set up kubernetes provider in -modules~~
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
#### todo
* split out k8s certificate manifest from cert-manager chart tf module for easier deployments in the future from -live config
* set wiki replicas to 2
  - need to find out if helm can set HA_ACTIVE environment variable to "true" first, or if setting replicas in helm config enables that automatically
  - just for fun, really
* move DNS from namecheap to DO, manage w/ terraform
* move secrets to secrets store, for now secret-per-person
  - hashicorp vault?
  - sounds like work
  - http://external-secrets.io/v0.5.2/
* bastion droplet for db work
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
./tf_init.sh && terraform plan
terraform apply
```

## tf_init.sh
this is a small wrapper to allow us to easily pass in secrets from
environment variables instead of commiting them into a git repository (very bad!!)

## how to update modules
go to (jun-sisters-wiki-modules)[https://github.com/wismerite/jun-sisters-wiki-modules], clone it, and when you make any changes make sure to add an annotated tag to your commit and then open a pr.  once it's merged, you can submit a PR here too to update the source paths in main.tf for the env you want to modify to point to the correct module version.

## hosting outline

### single node k8s cluster for dev env
- 1x managed database (Postgres)
  - used by jswiki
- 1x 2-node k8s cluster
- 1x DO loadbalancer, managed by k8s ingress
- 2x "space"
  - tf remote state
  - wiki backups

### ~~three-node k8s cluster for prod env~~
** NOT DOING "PROD" ENV FOR NOW DUE TO COST **
- 1x managed database (Postgrest)
  - used by jswiki
- 1x 3-node k8s cluster
  - 1x k8s volume
  - 1x k8s loadbalancer
- 1x "space"
  - tf remote state


## Potential "gotchas"

### cert-manager

the k8s cluster is using cert-manager to get CA-approved tls certs for the site's SSL configuration.  the certificate itself is auto-generated from an annotation on the ingress configuration and a k8s manifest set up in the cert-manage config.  neither of those things can be created until the cert-manager helm chart itself is applied/deployed.  SO if you are deploying a new copy of this project or destroyed/wish-to-recreate-an-existing-copy, you will have to comment out the blocks in ingress and the k8s manifest until the cert-manager chart itself is applied.  alternatively, the author, ella, could have been smart and moved the manifest outside of the same resource as the cert-manager chart so you could just comment out the ingress and the manifest modules in -live.  live and learn.

