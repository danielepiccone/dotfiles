#!/usr/bin/env bash
ansible-playbook -b -K ubuntu.yml  --extra-vars="user=dpi" $@
