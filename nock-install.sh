#!/bin/bash

set -e

echo -e "\n📦 正在更新系统并安装依赖..."
apt-get update && apt install sudo -y
sudo apt install -y screen curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip

echo -e "\n🦀 安装 Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup default stable

echo -e "\n📁 检查 nockchain 仓库..."
git clone https://github.com/zorp-corp/nockchain

cd nockchain
cp .env_example .env

echo -e "\n🔧 开始编译核心组件..."
make install-hoonc
export PATH="$HOME/.cargo/bin:$PATH"
make build
make install-nockchain-wallet
export PATH="$HOME/.cargo/bin:$PATH"
make install-nockchain
export PATH="$HOME/.cargo/bin:$PATH"

echo -e "\n✅ 编译完成，配置环境变量..."
echo 'export PATH="$PATH:/root/nockchain/target/release"' >> ~/.bashrc
echo 'export RUST_LOG=info' >> ~/.bashrc
echo 'export MINIMAL_LOG_FORMAT=true' >> ~/.bashrc
source ~/.bashrc

# === 生成钱包 ===
echo -e "\n🚀 手动输入生成钱包命令：nockchain-wallet keygen"
# === 启动指引 ===
echo -e "\n🚀 配置完成，启动命令如下："

echo -e "\n➡️ 启动 leader 节点："
echo -e "sh ./scripts/run_nockchain_miner.sh"

echo -e "\n🎉 部署完成，祝你挖矿愉快！"
