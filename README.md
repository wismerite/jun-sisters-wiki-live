# jun-sisters-wiki-live

idk why i used "live", it was just in the book okay??

## TODO list

### hi-pri
* set up gateway droplet
  - might just need the firewall here
* remote backend
  - use spaces
* ella thinks we'll need a volume for jswiki
* deploy vanilla jswiki app to k8s cluster
* attempt to restore the backups from the backups repo to vanilla jswiki

### low-pri
* move secrets to secrets store, for now secret-per-person
  - hashicorp vault?
  - sounds like work
* set up lb on k8s or something, check DO console it'll have instructions for it
  - they want me to use kubectl for it
  - wont need this for 1-node kube cluster probably

## digital ocean stuff for jun-sisters wiki 

* documentation for the digital-ocean terraform provider: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs

## git strategy
one branch, main.  envs are separated by dirs, backend is in its own dir.  modules are pulled in from jun-sisters-wiki-modules repo based on tag (tags use semantiv versioning), which also uses one branch.

## dev env setup
1. get a terraform binary somehow: https://www.terraform.io/downloads
2. suggested to move terraform binary into path (`~/.local/bin` is good, may need to make it first: `mkdir ~/.local/bin`)
2. clone this repo
3. set up a digital ocean personal access token as an env var (talk to ella to get access or a token or whatever, she's not sure how she wants to handle that yet): 
  `export TF_VAR_do_token="bleep"`
4. \o/ u did it (there's nothing else to do for setup rn)

## how to run
cd to the env of your choice, run init, plan, apply:

```
cd infra/dev
terraform init
terraform plan
terraform apply
```

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




