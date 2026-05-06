#!/bin/bash
# ============================================
# NexusTool CLI 安装脚本
# ============================================

echo "========================================"
echo "  NexusTool CLI 安装"
echo "========================================"
echo ""

# 下载 CLI 工具
echo "1. 下载部署工具..."
curl -fsSL https://raw.githubusercontent.com/VIPniuma/toolbox-landing/master/deploy-cli.sh -o /usr/local/bin/nntool

if [ $? -ne 0 ]; then
    echo "下载失败，尝试使用 wget..."
    wget -q https://raw.githubusercontent.com/VIPniuma/toolbox-landing/master/deploy-cli.sh -O /usr/local/bin/nntool
fi

# 设置权限
echo "2. 设置权限..."
chmod +x /usr/local/bin/nntool

# 验证安装
echo "3. 验证安装..."
if command -v nntool &> /dev/null; then
    echo ""
    echo "✓ 安装成功！"
    echo ""
    echo "使用方法:"
    echo "  nntool deploy    # 部署/更新网站"
    echo "  nntool status    # 查看状态"
    echo "  nntool log       # 查看日志"
    echo "  nntool help      # 显示帮助"
    echo ""
else
    echo "✗ 安装失败"
    exit 1
fi
