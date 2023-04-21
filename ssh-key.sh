#!/bin/bash
read -p "email (y/n): " EMAIL
ssh-keygen -t ed25519 -C $EMAIL 
