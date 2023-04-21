#!/bin/bash
read -p "Enter email: " EMAIL
ssh-keygen -t ed25519 -C $EMAIL 
