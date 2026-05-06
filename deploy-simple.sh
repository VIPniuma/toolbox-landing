#!/bin/bash
# ============================================
# NexusTool 一键部署脚本（简化版）
# 用法: deploy [命令]
# ============================================

# 配置
REPO_URL="https://github.com/VIPniuma/toolbox-landing.git"
WEB_DIR="/www/wwwroot/nntool"
BACKUP_DIR="/www/backup"
LOG_FILE="/var/log/nntool-deploy.log"
NODE_VERSION="18"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 打印带颜色的信息
info() { echo -e "${BLUE}[INFO]${NC} $1" | tee -a $LOG_FILE; }
success() { echo -e "${GREEN}[✓]${NC} $1" | tee -a $LOG_FILE; }
error() { echo -e "${RED}[✗]${NC} $1" | tee -a $LOG_FILE; }
warn() { echo -e "${YELLOW}[!]${NC} $1" | tee -a $LOG_FILE; }
step() { echo -e "${CYAN}[→]${NC} $1"; }

# 检查并安装 Node.js
install_node() {
    step "检查 Node.js..."
    
    if command -v node &> /dev/null; then
        NODE_CURRENT=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_CURRENT" -ge "$NODE_VERSION" ]; then
            success "Node.js 已安装: $(node -v)"
            return 0
        else
            warn "Node.js 版本过低 ($(node -v))，需要升级..."
        fi
    else
        info "Node.js 未安装，开始安装..."
    fi
    
    # 安装 Node.js
    step "安装 Node.js ${NODE_VERSION}..."
    
    # 使用 nvm 安装
    if [ ! -d "$HOME/.nvm" ]; then
        step "安装 nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
    
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    nvm install $NODE_VERSION
    nvm use $NODE_VERSION
    nvm alias default $NODE_VERSION
    
    # 添加到 .bashrc
    if ! grep -q "NVM_DIR" ~/.bashrc; then
        echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
    fi
    
    success "Node.js 安装完成: $(node -v)"
}

# 检查并安装 Git
install_git() {
    step "检查 Git..."
    
    if command -v git &> /dev/null; then
        success "Git 已安装: $(git --version)"
        return 0
    fi
    
    step "安装 Git..."
    
    # 检测系统类型并安装
    if [ -f /etc/redhat-release ]; then
        # CentOS/RHEL
        sudo yum install -y git
    elif [ -f /etc/debian_version ]; then
        # Ubuntu/Debian
        sudo apt-get update
        sudo apt-get install -y git
    else
        error "无法识别系统类型，请手动安装 Git"
        exit 1
    fi
    
    success "Git 安装完成"
}

# 备份网站
backup_site() {
    step "备份当前网站..."
    
    mkdir -p $BACKUP_DIR
    BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    
    cd $WEB_DIR 2>/dev/null || return
    
    if [ "$(ls -A)" ]; then
        tar -czf $BACKUP_DIR/$BACKUP_NAME . 2>/dev/null
        if [ $? -eq 0 ]; then
            success "备份完成: $BACKUP_NAME"
            echo $BACKUP_NAME > $BACKUP_DIR/latest.txt
        else
            warn "备份失败，继续部署..."
        fi
    fi
}

# 部署网站
deploy_site() {
    echo ""
    echo "========================================"
    echo "  NexusTool 网站部署"
    echo "========================================"
    echo ""
    
    step "开始部署..."
    info "目标目录: $WEB_DIR"
    
    # 创建目录
    sudo mkdir -p $WEB_DIR
    sudo chown -R $(whoami):$(whoami) $WEB_DIR
    cd $WEB_DIR
    
    # 检查是否已部署
    if [ -d ".git" ]; then
        step "检测到已有部署，执行更新..."
        
        git fetch origin
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/master)
        
        if [ "$LOCAL" = "$REMOTE" ]; then
            success "已经是最新版本，无需更新"
            return 0
        fi
        
        git reset --hard origin/master
        success "代码已更新"
    else
        step "首次部署，克隆仓库..."
        
        # 备份现有文件
        if [ "$(ls -A)" ]; then
            backup_site
            rm -rf *
        fi
        
        git clone $REPO_URL .
        success "仓库克隆完成"
    fi
    
    # 安装依赖
    step "安装依赖..."
    npm install
    if [ $? -ne 0 ]; then
        error "依赖安装失败"
        return 1
    fi
    success "依赖安装完成"
    
    # 构建项目
    step "构建项目..."
    npm run build
    if [ $? -ne 0 ]; then
        error "构建失败"
        return 1
    fi
    success "构建完成"
    
    # 复制构建文件
    if [ -d "dist" ]; then
        step "复制构建文件..."
        cp -r dist/* .
        success "文件复制完成"
    fi
    
    # 设置权限
    sudo chown -R www:www $WEB_DIR
    sudo chmod -R 755 $WEB_DIR
    
    echo ""
    echo "========================================"
    success "部署成功！"
    echo "========================================"
    echo ""
    info "网站目录: $WEB_DIR"
    info "访问地址: http://你的域名"
    echo ""
}

# 查看状态
show_status() {
    echo ""
    echo "========================================"
    echo "  NexusTool 部署状态"
    echo "========================================"
    echo ""
    
    if [ -d "$WEB_DIR" ]; then
        echo -e "网站目录: ${GREEN}✓ 存在${NC} ($WEB_DIR)"
    else
        echo -e "网站目录: ${RED}✗ 不存在${NC}"
        return
    fi
    
    if [ -d "$WEB_DIR/.git" ]; then
        cd $WEB_DIR
        echo -e "Git 仓库: ${GREEN}✓ 已初始化${NC}"
        
        COMMIT=$(git rev-parse --short HEAD 2>/dev/null)
        DATE=$(git log -1 --format=%cd --date=short 2>/dev/null)
        echo -e "当前版本: ${CYAN}$COMMIT${NC} ($DATE)"
        
        git fetch origin 2>/dev/null
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/master 2>/dev/null || echo "$LOCAL")
        
        if [ "$LOCAL" != "$REMOTE" ]; then
            echo -e "更新状态: ${YELLOW}⚡ 有新版本可用${NC}"
        else
            echo -e "更新状态: ${GREEN}✓ 已是最新${NC}"
        fi
    else
        echo -e "Git 仓库: ${RED}✗ 未初始化${NC}"
    fi
    
    if command -v node &> /dev/null; then
        echo -e "Node.js: ${GREEN}✓ $(node -v)${NC}"
    else
        echo -e "Node.js: ${RED}✗ 未安装${NC}"
    fi
    
    DISK=$(df -h $WEB_DIR 2>/dev/null | tail -1 | awk '{print $5}')
    echo -e "磁盘使用: $DISK"
    
    echo ""
}

# 查看日志
show_log() {
    echo ""
    if [ -f "$LOG_FILE" ]; then
        echo "========================================"
        echo "  最近 30 条部署日志"
        echo "========================================"
        echo ""
        tail -n 30 $LOG_FILE
        echo ""
    else
        echo "暂无日志"
    fi
}

# 显示帮助
show_help() {
    echo ""
    echo "========================================"
    echo "  NexusTool 部署工具"
    echo "========================================"
    echo ""
    echo "用法: deploy [命令]"
    echo ""
    echo "命令:"
    echo "  deploy    部署/更新网站（默认）"
    echo "  status    查看部署状态"
    echo "  log       查看部署日志"
    echo "  help      显示帮助"
    echo ""
    echo "示例:"
    echo "  deploy           # 一键部署/更新"
    echo "  deploy status    # 查看状态"
    echo "  deploy log       # 查看日志"
    echo ""
}

# 主函数
main() {
    # 创建日志文件
    sudo mkdir -p /var/log
    sudo touch $LOG_FILE 2>/dev/null || LOG_FILE="/tmp/nntool-deploy.log"
    sudo chown $(whoami):$(whoami) $LOG_FILE 2>/dev/null || true
    
    case "${1:-deploy}" in
        deploy|update|install|""|up)
            install_git
            install_node
            deploy_site
            ;;
        status|st|s)
            show_status
            ;;
        log|logs|l)
            show_log
            ;;
        help|-h|--help|h)
            show_help
            ;;
        *)
            error "未知命令: $1"
            show_help
            exit 1
            ;;
    esac
}

# 运行
main "$@"
