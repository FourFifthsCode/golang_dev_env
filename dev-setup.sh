#!/bin/bash

echo "updating apt"
sudo apt update

# Add a comment and command at end of .bashrc 
# file if cmd doesn't exits
add_to_bash_rc() {
    if ! $(cat ~/.bashrc | grep -q "$2"); then
        echo -e "adding to ~/.bashrc:"
        echo -e "\n# $1\n$2" | tee -a ~/.bashrc
    else
         echo -e "found '$2' in ~/.bashrc... skipping"
    fi
}

# echo "installing starship prompt"
# curl -sS https://starship.rs/install.sh | sh
# add_to_bash_rc "starship" 'eval "$(starship init bash)"'

# echo "installing docker and docker-compose"
# sudo apt install -y docker.io docker-compose 

echo "installing python3-venv"
sudo apt install -y python3.8-venv

echo "installing make"
sudo apt install -y make

echo "installing jq"
sudo apt install -y jq

echo "installing homebrew"
if [[ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]]
then
    echo "installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else    
    echo "homebrew already installed"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
add_to_bash_rc "homebrew" 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'

echo "installing tilt"
brew install tilt
add_to_bash_rc "tilt" "source <(tilt completion bash)"

echo "installing ctptl"
sudo apt install gcc -y # required to compile ctlptl
brew install tilt-dev/tap/ctlptl
add_to_bash_rc "ctlptl" "source <(ctlptl completion bash)"

echo "installing golang"
brew install go
add_to_bash_rc "golang" 'export PATH=$PATH:$HOME/go/bin'
go env -w CC=gcc CXX="g++" # setup CGO dependencies

echo "installing protoc and protoc-gen-go"
brew install protobuf
brew install protoc-gen-go

echo "installing helm"
brew install helm
add_to_bash_rc "helm" "source <(helm completion bash)"

echo "installing kubectl"
brew install  kubernetes-cli
add_to_bash_rc "kubectl" "source <(kubectl completion bash)"

echo "installing minikube"
brew install minikube
add_to_bash_rc "minikube" "source <(minikube completion bash)"

echo "installing kind"
brew install kind
add_to_bash_rc "kind" "source <(kind completion bash)"

echo "installing k3d"
brew install k3d
add_to_bash_rc "k3d" "source <(k3d completion bash)"

echo "installing swagger-codegen"
brew install swagger-codegen

echo "installing nvm"
brew install nvm
NVM_SOURCE=$(cat << EOF
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
EOF
)
add_to_bash_rc "nvm" "$NVM_SOURCE"

echo "installing kubebuilder"
brew install kubebuilder

echo "installing k9s"
brew install k9s

echo "installing dive"
brew install dive

echo "installing helm-docs"
go install github.com/norwoodj/helm-docs/cmd/helm-docs@v1.9.1

read -p "setup ssh key? (y/n): " SETUP_SSH
if [[ $SETUP_SSH == "y" ]]
then
    read -p "email (y/n): " EMAIL
    ssh-keygen -t ed25519 -C $EMAIL 
fi

