# ubuntu-22.04-scripts
Set up scripts for Ubuntu 22.04

## Install

```bash
./install.sh
```

## New Scripts

```bash
# +x to new scripts
./chmod.sh
```

## Multiple Versions

```bash
# install
sudo update-alternatives --install <link> <name> <path> priority

# choose version
sudo update-alternative --config <name>

# remove
sudo update-alternatives --remove <name> <path>
```

### kubectl

- Executables stored under `/opt/kubectl/`
- Configure with `KUBECTL_VERSIONS` and `DEFAULT_KUBECTL_VERSION` in `.env`

### helm

- Executables stored under `/opt/helm/`
- Configure with `HELM_VERSIONS` and `DEFAULT_HELM_VERSION` in `.env`
- See https://helm.sh/docs/topics/version_skew/ for helm-kubectl compatibility matrix
