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

echo "installing apt packages"
apt_packages=(
    "python3-venv"
    "make"
    "jq"
    "yq" 
    "gcc"
)
sudo apt install -y $apt_packages

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

brew_packages=(
    "tilt"
    "tilt-dev/tap/ctlptl"
    "go"
    "protobuf"
    "protoc-gen-go"
    "helm"
    "kubernetes-cli"
    "minikube"
    "kind"
    "k3d"
    "swagger-codegen"
    "nvm"
    "kubebuilder"
    "starship"
    "k9s"
    "dive"
)

brew install $brew_packages

# .bashrc
add_to_bash_rc "tilt" "source <(tilt completion bash)"
add_to_bash_rc "ctlptl" "source <(ctlptl completion bash)"
add_to_bash_rc "golang" 'export PATH=$PATH:$HOME/go/bin'
add_to_bash_rc "helm" "source <(helm completion bash)"
add_to_bash_rc "kubectl" "source <(kubectl completion bash)"
add_to_bash_rc "minikube" "source <(minikube completion bash)"
add_to_bash_rc "kind" "source <(kind completion bash)"
add_to_bash_rc "k3d" "source <(k3d completion bash)"
add_to_bash_rc "starship" 'eval "$(starship init bash)"'

NVM_SOURCE=$(cat << EOF
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
EOF
)
add_to_bash_rc "nvm" "$NVM_SOURCE"

# golang
go env -w CC=gcc CXX="g++" # setup CGO dependencies
go install github.com/norwoodj/helm-docs/cmd/helm-docs@v1.9.1
