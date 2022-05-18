# jun-sisters-wiki-live

idk why i used "live", it was just in the book okay??

## TODO list

* set up gateway droplet
  - ???
* remote backend
  - use spaces
* move secrets to secrets store, for now secret-per-person
  - hashicorp vault?
* set up lb on k8s or something, check DO console it'll have instructions for it
  - they want me to use kubectl for it
* believe we'll need a volume for jswiki
* deploy vanilla jswiki app to k8s cluster
* attempt to restore the backups from the backups repo to vanilla jswiki

## digital ocean stuff for jun-sisters wiki 

* documentation for the digital-ocean terraform provider: https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs

## git strategy
one branch, main.  envs are separated by dirs, backend is in its own dir.  modules are pulled in from jun-sisters-wiki-modules repo based on tag (tags use semantiv versioning), which also uses one branch.

## dev env setup
1. get a terraform binary somehow: https://www.terraform.io/downloads
2. suggested to move terraform binary into path (`~/.local/bin` is good, may need to make it first: `mkdir ~/.local/bin`)
2. clone this repo
3. set up a digital ocean personal access token: export DO_PAT="bleep"
4. \o/ u did it (there's nothing else to do for setup rn)

## how to run

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



