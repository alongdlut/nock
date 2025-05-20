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
if [ -d "nockchain" ]; then
  echo "⚠️ 已存在 nockchain 目录，是否删除重新克隆（必须选 y ）？(y/n)"
  read -r confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    rm -rf nockchain
    git clone https://github.com/zorp-corp/nockchain
  else
    echo "➡️ 使用已有目录 nockchain"
  fi
else
  git clone https://github.com/zorp-corp/nockchain
fi

cd nockchain

echo -e "\n🔧 开始编译核心组件..."
make install-hoonc
make build
make install-nockchain-wallet
make install-nockchain

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
echo -e "screen -S leader\nmake run-nockchain-leader"

echo -e "\n➡️ 启动 follower 节点："
echo -e "screen -S follower\nmake run-nockchain-follower"

echo -e "\n📄 查看日志方法："
echo -e "screen -r leader   # 查看 leader 日志"
echo -e "screen -r follower # 查看 follower 日志"
echo -e "Ctrl+A 再按 D 可退出 screen 会话"

echo -e "\n🎉 部署完成，祝你挖矿愉快！"
