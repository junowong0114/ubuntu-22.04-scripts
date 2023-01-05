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
- Configure with `KUBECTL_VERSIONS` in `.env`
