# small wrapper to init terraform with backend creds
# make sure env vars for spaces access key and key secret are set up

# this sets the prefix in the space for the tf state
env=$(basename $(pwd))

# this lets you pass in an extra tf init arg, like: ./tf_init.sh -migrate-state
extra_arg=$1

terraform init $1 \
    -backend-config="access_key=$DO_SPACES_ACCESS_KEY" \
    -backend-config="secret_key=$DO_SPACES_SECRET_KEY" \
    -backend-config="key=$env/terraform.tfstate"

