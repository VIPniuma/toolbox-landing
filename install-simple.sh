#!/bin/bash
# ============================================
# NexusTool 部署工具安装脚本（简化版）
# ============================================

echo "========================================"
echo "  NexusTool 部署工具安装"
echo "========================================"
echo ""

# 下载 deploy 命令到 /usr/local/bin
INSTALL_DIR="/usr/local/bin"
DEPLOY_URL="https://raw.githubusercontent.com/VIPniuma/toolbox-landing/master/deploy-simple.sh"

echo "1. 下载部署工具..."

# 尝试下载
if command -v curl &> /dev/null; then
    sudo curl -fsSL $DEPLOY_URL -o $INSTALL_DIR/deploy
elif command -v wget &> /dev/null; then
    sudo wget -q $DEPLOY_URL -O $INSTALL_DIR/deploy
else
    echo "错误: 未找到 curl 或 wget"
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "下载失败，请检查网络连接"
    exit 1
fi

echo "2. 设置权限..."
sudo chmod +x $INSTALL_DIR/deploy

echo "3. 验证安装..."
if command -v deploy &> /dev/null; then
    echo ""
    echo "========================================"
    echo "  ✓ 安装成功！"
    echo "========================================"
    echo ""
    echo "使用方法:"
    echo "  deploy           # 一键部署/更新网站"
    echo "  deploy status    # 查看部署状态"
    echo "  deploy log       # 查看部署日志"
    echo "  deploy help      # 显示帮助"
    echo ""
    echo "特点:"
    echo "  • 自动检测并安装 Node.js 18+"
    echo "  • 自动检测并安装 Git"
    echo "  • 自动拉取最新代码并构建"
    echo "  • 支持重复执行（有更新才部署）"
    echo ""
else
    echo "安装失败，请手动检查"
    exit 1
fi
