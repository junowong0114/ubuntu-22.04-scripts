# ubuntu-22.04-scripts
Set up scripts for Ubuntu 22.04

## Install

```bash
./install.sh
```
Restart bash shell afterwards

## New Scripts

```bash
# +x to new scripts
./chmod.sh
```

## Multiple Versions

### Node

- Managed with nvm: https://github.com/nvm-sh/nvm

```bash
# list local versions
nvm ls

# list remote versions
nvm ls-remote

# set default
nvm alias default <version>

# install new version
nvm install <version>

# choose a version to use
nvm use <version>
```

### Terraform

- Managed with tfenv: https://github.com/tfutils/tfenv
- By default use `latest` version

```bash
# list local versions
tfenv list

# list remote versions
tfenv list-remote

# install and use specific version
tfenv install <version>
tfenv use <version>

# upgrade to latest terraform version
tfenv install latest
tfenv use latest

# uninstall specific terraform version
tfenv uninstall <version>
```

### Managed by update-alternatives

`update-alternatives` is an Ubuntu built-in command for managing multiple versions of binaries by setting symbolic links from bin to respective binaries

```bash
# install
sudo update-alternatives --install <link> <name> <path> priority

# list versions
sudo update-alternatives --query <name>

# choose version
sudo update-alternative --config <name>

# remove
sudo update-alternatives --remove <name> <path>
```

#### kubectl

- Executables stored under `/opt/kubectl/`
- Configure with `KUBECTL_VERSIONS` and `DEFAULT_KUBECTL_VERSION` in `.env`
- See https://kubernetes.io/releases/version-skew-policy/ for kubectl version skew policy

#### helm

- Executables stored under `/opt/helm/`
- Configure with `HELM_VERSIONS` and `DEFAULT_HELM_VERSION` in `.env`
- See https://helm.sh/docs/topics/version_skew/ for helm-kubectl compatibility matrix
