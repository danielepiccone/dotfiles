#!/usr/bin/env bash
ansible-playbook -b -K\
    playbook.yml \
    --extra-vars="user=dpi"
