#!/bin/bash
# ============================================
# NexusTool 部署工具 - 直接安装版
# 复制粘贴执行即可
# ============================================

echo "========================================"
echo "  NexusTool 部署工具安装"
echo "========================================"
echo ""

# 创建 deploy 命令
cat > /usr/local/bin/deploy << 'DEPLOY_EOF'
#!/bin/bash
REPO_URL="https://github.com/VIPniuma/toolbox-landing.git"
WEB_DIR="/www/wwwroot/nntool"
NODE_VERSION="18"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
step() { echo -e "${CYAN}[→]${NC} $1"; }

install_node() {
    step "检查 Node.js..."
    if command -v node &> /dev/null; then
        NODE_CURRENT=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_CURRENT" -ge "$NODE_VERSION" ]; then
            success "Node.js 已安装: $(node -v)"
            return 0
        fi
    fi
    step "安装 Node.js ${NODE_VERSION}..."
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    fi
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install $NODE_VERSION
    nvm use $NODE_VERSION
    nvm alias default $NODE_VERSION
    success "Node.js 安装完成"
}

install_git() {
    step "检查 Git..."
    if command -v git &> /dev/null; then
        success "Git 已安装"
        return 0
    fi
    step "安装 Git..."
    if [ -f /etc/redhat-release ]; then
        yum install -y git
    else
        apt-get update && apt-get install -y git
    fi
    success "Git 安装完成"
}

deploy_site() {
    echo ""
    echo "========================================"
    echo "  NexusTool 网站部署"
    echo "========================================"
    echo ""
    step "开始部署..."
    mkdir -p $WEB_DIR
    cd $WEB_DIR
    if [ -d ".git" ]; then
        step "更新代码..."
        git fetch origin
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/master)
        if [ "$LOCAL" = "$REMOTE" ]; then
            success "已经是最新版本"
            return 0
        fi
        git reset --hard origin/master
    else
        step "首次部署，克隆仓库..."
        rm -rf * .[^.]* 2>/dev/null
        git clone $REPO_URL .
    fi
    step "安装依赖..."
    npm install
    step "构建项目..."
    npm run build
    if [ -d "dist" ]; then
        cp -r dist/* .
    fi
    chown -R www:www $WEB_DIR 2>/dev/null || true
    chmod -R 755 $WEB_DIR
    echo ""
    echo "========================================"
    success "部署成功！"
    echo "========================================"
    echo ""
}

show_status() {
    echo ""
    echo "========================================"
    echo "  NexusTool 部署状态"
    echo "========================================"
    echo ""
    if [ -d "$WEB_DIR/.git" ]; then
        cd $WEB_DIR
        echo -e "Git 仓库: ${GREEN}✓ 已初始化${NC}"
        COMMIT=$(git rev-parse --short HEAD 2>/dev/null)
        echo -e "当前版本: ${CYAN}$COMMIT${NC}"
    else
        echo -e "Git 仓库: ${RED}✗ 未初始化${NC}"
    fi
    if command -v node &> /dev/null; then
        echo -e "Node.js: ${GREEN}✓ $(node -v)${NC}"
    else
        echo -e "Node.js: ${RED}✗ 未安装${NC}"
    fi
    echo ""
}

show_help() {
    echo ""
    echo "用法: deploy [命令]"
    echo ""
    echo "命令:"
    echo "  deploy    部署/更新网站（默认）"
    echo "  status    查看部署状态"
    echo "  help      显示帮助"
    echo ""
}

case "${1:-deploy}" in
    deploy|update|install|""|up)
        install_git
        install_node
        deploy_site
        ;;
    status|st|s)
        show_status
        ;;
    help|-h|--help)
        show_help
        ;;
    *)
        error "未知命令: $1"
        show_help
        exit 1
        ;;
esac
DEPLOY_EOF

chmod +x /usr/local/bin/deploy

echo ""
echo "========================================"
echo "  ✓ 安装成功！"
echo "========================================"
echo ""
echo "现在可以直接输入: deploy"
echo ""
