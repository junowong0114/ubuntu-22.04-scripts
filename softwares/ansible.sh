#/bin/bash
set -eo pipefail

print_title.sh "Installing Ansible"

sudo apt install --yes software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install --yes ansible
