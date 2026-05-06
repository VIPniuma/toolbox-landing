#!/bin/bash
# ============================================
# NexusTool 一键部署脚本
# 用法: ./deploy-cli.sh [命令]
# ============================================

# 配置
REPO_URL="https://github.com/VIPniuma/toolbox-landing.git"
WEB_DIR="/www/wwwroot/nntool"
BACKUP_DIR="/www/backup"
LOG_FILE="/var/log/nntool-deploy.log"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1" | tee -a $LOG_FILE
}

success() {
    echo -e "${GREEN}[✓]${NC} $1" | tee -a $LOG_FILE
}

error() {
    echo -e "${RED}[✗]${NC} $1" | tee -a $LOG_FILE
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1" | tee -a $LOG_FILE
}

# 显示帮助
show_help() {
    echo ""
    echo "========================================"
    echo "  NexusTool 部署工具"
    echo "========================================"
    echo ""
    echo "用法: nntool [命令]"
    echo ""
    echo "命令:"
    echo "  deploy    部署/更新网站（默认）"
    echo "  status    查看部署状态"
    echo "  log       查看部署日志"
    echo "  backup    备份当前网站"
    echo "  restore   恢复到上次备份"
    echo "  clean     清理日志和缓存"
    echo "  help      显示帮助"
    echo ""
    echo "示例:"
    echo "  nntool deploy     # 部署或更新网站"
    echo "  nntool status     # 查看当前状态"
    echo "  nntool log        # 查看部署日志"
    echo ""
}

# 检查依赖
check_deps() {
    log "检查依赖..."
    
    # 检查 git
    if ! command -v git &> /dev/null; then
        error "Git 未安装，正在安装..."
        yum install -y git || apt-get install -y git
    fi
    
    # 检查 node
    if ! command -v node &> /dev/null; then
        error "Node.js 未安装"
        echo "请先安装 Node.js 18+"
        exit 1
    fi
    
    success "依赖检查完成"
}

# 备份网站
backup_site() {
    log "备份当前网站..."
    
    mkdir -p $BACKUP_DIR
    BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    
    cd $WEB_DIR
    tar -czf $BACKUP_DIR/$BACKUP_NAME . 2>/dev/null
    
    if [ $? -eq 0 ]; then
        success "备份完成: $BACKUP_NAME"
        echo $BACKUP_NAME > $BACKUP_DIR/latest.txt
    else
        warn "备份失败，继续部署..."
    fi
}

# 部署网站
deploy_site() {
    log "开始部署 NexusTool..."
    log "目标目录: $WEB_DIR"
    
    # 创建目录
    mkdir -p $WEB_DIR
    cd $WEB_DIR
    
    # 检查是否已部署
    if [ -d ".git" ]; then
        log "检测到已有部署，执行更新..."
        
        # 保存当前分支
        CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
        log "当前分支: $CURRENT_BRANCH"
        
        # 拉取最新代码
        git fetch origin
        git reset --hard origin/master
        
        if [ $? -ne 0 ]; then
            error "拉取代码失败"
            return 1
        fi
        
        success "代码已更新"
    else
        log "首次部署，克隆仓库..."
        
        # 备份现有文件
        if [ "$(ls -A)" ]; then
            backup_site
            rm -rf *
        fi
        
        # 克隆仓库
        git clone $REPO_URL .
        
        if [ $? -ne 0 ]; then
            error "克隆仓库失败"
            return 1
        fi
        
        success "仓库克隆完成"
    fi
    
    # 安装依赖
    log "安装依赖..."
    npm install --production
    
    if [ $? -ne 0 ]; then
        error "依赖安装失败"
        return 1
    fi
    
    success "依赖安装完成"
    
    # 构建项目
    log "构建项目..."
    npm run build
    
    if [ $? -ne 0 ]; then
        error "构建失败"
        return 1
    fi
    
    success "构建完成"
    
    # 复制构建文件
    if [ -d "dist" ]; then
        log "复制构建文件到根目录..."
        cp -r dist/* .
        success "文件复制完成"
    fi
    
    # 设置权限
    chown -R www:www $WEB_DIR
    chmod -R 755 $WEB_DIR
    
    success "部署完成！"
    log "网站地址: http://你的域名"
    
    return 0
}

# 查看状态
show_status() {
    echo ""
    echo "========================================"
    echo "  NexusTool 部署状态"
    echo "========================================"
    echo ""
    
    # 检查目录
    if [ -d "$WEB_DIR" ]; then
        echo -e "网站目录: ${GREEN}存在${NC} ($WEB_DIR)"
    else
        echo -e "网站目录: ${RED}不存在${NC}"
        return
    fi
    
    # 检查 git
    if [ -d "$WEB_DIR/.git" ]; then
        cd $WEB_DIR
        echo -e "Git 仓库: ${GREEN}已初始化${NC}"
        
        # 显示版本信息
        COMMIT=$(git rev-parse --short HEAD)
        DATE=$(git log -1 --format=%cd --date=short)
        echo -e "当前版本: ${BLUE}$COMMIT${NC} ($DATE)"
        
        # 检查更新
        git fetch origin > /dev/null 2>&1
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/master)
        
        if [ $LOCAL != $REMOTE ]; then
            echo -e "更新状态: ${YELLOW}有新版本可用${NC}"
        else
            echo -e "更新状态: ${GREEN}已是最新${NC}"
        fi
    else
        echo -e "Git 仓库: ${RED}未初始化${NC}"
    fi
    
    # 检查 Node.js
    if command -v node &> /dev/null; then
        NODE_VER=$(node -v)
        echo -e "Node.js: ${GREEN}$NODE_VER${NC}"
    else
        echo -e "Node.js: ${RED}未安装${NC}"
    fi
    
    # 磁盘空间
    DISK=$(df -h $WEB_DIR | tail -1 | awk '{print $5}')
    echo -e "磁盘使用: $DISK"
    
    echo ""
}

# 查看日志
show_log() {
    if [ -f "$LOG_FILE" ]; then
        echo ""
        echo "========================================"
        echo "  最近 50 条部署日志"
        echo "========================================"
        echo ""
        tail -n 50 $LOG_FILE
        echo ""
    else
        echo "暂无日志"
    fi
}

# 恢复备份
restore_backup() {
    if [ ! -f "$BACKUP_DIR/latest.txt" ]; then
        error "没有找到备份文件"
        return 1
    fi
    
    LATEST=$(cat $BACKUP_DIR/latest.txt)
    log "准备恢复备份: $LATEST"
    
    cd $WEB_DIR
    rm -rf *
    tar -xzf $BACKUP_DIR/$LATEST .
    
    if [ $? -eq 0 ]; then
        success "恢复完成"
    else
        error "恢复失败"
    fi
}

# 清理
clean_up() {
    log "清理日志和缓存..."
    
    # 清理日志
    if [ -f "$LOG_FILE" ]; then
        > $LOG_FILE
        success "日志已清空"
    fi
    
    # 清理 npm 缓存
    npm cache clean --force 2>/dev/null
    
    # 清理旧备份（保留最近5个）
    if [ -d "$BACKUP_DIR" ]; then
        cd $BACKUP_DIR
        ls -t backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs rm -f
        success "旧备份已清理"
    fi
    
    success "清理完成"
}

# 主函数
main() {
    # 创建日志文件
    touch $LOG_FILE 2>/dev/null || LOG_FILE="/tmp/nntool-deploy.log"
    
    case "${1:-deploy}" in
        deploy|update|install)
            check_deps
            backup_site
            deploy_site
            ;;
        status)
            show_status
            ;;
        log|logs)
            show_log
            ;;
        backup)
            backup_site
            ;;
        restore)
            restore_backup
            ;;
        clean)
            clean_up
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
}

# 运行
main "$@"
