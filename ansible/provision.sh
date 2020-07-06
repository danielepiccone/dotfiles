#!/usr/bin/env bash
ansible-playbook -b -K\
    -i inventory \
    playbook.yml \
    --extra-vars="user=dpi"
