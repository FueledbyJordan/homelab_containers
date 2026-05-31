# to run:
```
nix run
```

# for developing
```
# inject secrets
ansible-playbook bootstrap.yml -i 'helium,'
op run --no-masking --env-file .secrets --env-file homelab_containers_private/.secrets -- docker compose up -d
```
