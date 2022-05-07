# jun-sisters-do

## digital ocean stuff for jun-sisters wiki 

* documentation for the digital-ocean terraform provider: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs

## git strategy
honestly, may just stick with one branch.  workspaces in TF should allow deployments to a dev/staging and prod env

## dev env setup
1. get a terraform binary somehow: https://www.terraform.io/downloads
2. suggested to move terraform binary into path (`~/.local/bin` is good, may need to make it first: `mkdir ~/.local/bin`)
2. clone this repo
3. set up a digital ocean personal access token: export DO_PAT="bleep"
4. \o/ u did it (there's nothing else to do for setup rn)

## how to run
### **NOTE:** pass env via "-var" cli option:
`terraform -var"env=dev"`

## hosting outline

### Single node k8s cluster
- 1x managed database (Postgres)
    - used by jswiki
- 1x 1-node k8s cluster

### three-node k8s cluster
- 1x managed database (Postgrest)
    - used by jswiki
    - used by terraform (remote state)
- 1x 3-node k8s cluster


## useful commands for this project
- put in .[bash|zsh|whatever]rc
```
export TF_VAR_do_token="$YOUR_DO_TOKEN"
export TF_VAR_env="dev"
```

## TODO list

* set up gateway droplet
* remote backend
  - use postgres
* move secrets to secrets store, for now secret-per-person
  - hashicorp vault?

* just using ubuntu for now, but other, container-oriented OS would probably be better
* terragrunt?
  - not for now

