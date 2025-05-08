#!/bin/bash

set -e

echo "🔄 Updating and upgrading system without prompts..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" \
        upgrade -y

echo "🛠 Installing required packages..."
apt-get install -y curl wget git zsh net-tools

echo "📂 Creating Arsenal and Project directories..."
mkdir -p ~/Arsenal ~/Project

echo "📦 Installing Oh My Zsh (unattended)..."
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
PLUGINS_DIR="$ZSH_CUSTOM/plugins"

echo "🔌 Installing ZSH plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGINS_DIR/zsh-syntax-highlighting"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$PLUGINS_DIR/fast-syntax-highlighting"
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git "$PLUGINS_DIR/zsh-autocomplete"

echo "⚙️ Configuring .zshrc..."
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' ~/.zshrc

cat << 'EOF' >> ~/.zshrc

# Custom Aliases
alias arsenal='cd ~/Arsenal'
alias projects='cd ~/Project'
alias tools='cd ~/Arsenal'
EOF

echo "💻 Setting zsh as the default shell for current user..."
chsh -s "$(which zsh)" "$(whoami)"

echo "📁 Cloning and running OK-VPS..."
git clone https://github.com/mrco24/OK-VPS.git ~/Arsenal/OK-VPS
chmod +x ~/Arsenal/OK-VPS/okvps.sh
cd ~/Arsenal/OK-VPS && ./okvps.sh

echo "✅ Setup complete. Run this to start ZSH:"
echo "   exec zsh"
