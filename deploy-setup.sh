#!/bin/bash
# ============================================
# NexusTool 宝塔自动部署配置脚本
# 网站目录: /www/wwwroot/nntool
# ============================================

echo "========================================"
echo "  NexusTool 自动部署配置"
echo "========================================"
echo ""

# 配置变量
WEB_DIR="/www/wwwroot/nntool"
WEBHOOK_DIR="/www/webhook"
REPO_URL="https://github.com/VIPniuma/toolbox-landing.git"
SECRET_KEY="nntool_webhook_$(date +%s)_secure"

echo "1. 创建 Webhook 目录..."
mkdir -p $WEBHOOK_DIR
cd $WEBHOOK_DIR

echo "2. 创建部署脚本..."
cat > deploy.sh << 'DEPLOY_EOF'
#!/bin/bash

# 配置
REPO_URL="https://github.com/VIPniuma/toolbox-landing.git"
WEB_DIR="/www/wwwroot/nntool"
LOG_FILE="/www/webhook/deploy.log"

echo "========== $(date '+%Y-%m-%d %H:%M:%S') ==========" >> $LOG_FILE

# 进入网站目录
cd $WEB_DIR

# 检查是否是 git 仓库
if [ ! -d ".git" ]; then
    echo "首次部署，初始化 git 仓库..." >> $LOG_FILE
    git init >> $LOG_FILE 2>&1
    git remote add origin $REPO_URL >> $LOG_FILE 2>&1
    git pull origin master >> $LOG_FILE 2>&1
else
    echo "拉取最新代码..." >> $LOG_FILE
    git pull origin master >> $LOG_FILE 2>&1
fi

# 安装依赖
echo "安装依赖..." >> $LOG_FILE
npm install >> $LOG_FILE 2>&1

# 构建项目
echo "构建项目..." >> $LOG_FILE
npm run build >> $LOG_FILE 2>&1

# 复制构建文件到网站根目录（如果构建输出在 dist）
if [ -d "dist" ]; then
    echo "复制构建文件..." >> $LOG_FILE
    cp -r dist/* . >> $LOG_FILE 2>&1
fi

echo "部署完成！" >> $LOG_FILE
echo "" >> $LOG_FILE
DEPLOY_EOF

chmod +x deploy.sh

echo "3. 创建 Webhook PHP 接收文件..."
cat > github-webhook.php << 'PHP_EOF'
<?php
// 安全密钥
$secret = 'nntool_webhook_$(date +%s)_secure';

// 获取 GitHub 发送的签名
$headers = getallheaders();
$signature = isset($headers['X-Hub-Signature-256']) ? $headers['X-Hub-Signature-256'] : '';

// 获取请求体
$payload = file_get_contents('php://input');

// 验证签名
$hash = 'sha256=' . hash_hmac('sha256', $payload, $secret);
if (!hash_equals($hash, $signature)) {
    http_response_code(403);
    die('Unauthorized');
}

// 只处理 push 事件
$event = isset($headers['X-GitHub-Event']) ? $headers['X-GitHub-Event'] : '';
if ($event !== 'push') {
    die('Not a push event');
}

// 执行部署脚本
$output = shell_exec('/www/webhook/deploy.sh 2>&1');
echo $output;

// 记录日志
file_put_contents('/www/webhook/webhook.log', date('Y-m-d H:i:s') . " - Webhook triggered\n$output\n\n", FILE_APPEND);
?>
PHP_EOF

# 替换密钥
sed -i "s/nntool_webhook_$(date +%s)_secure/$SECRET_KEY/g" github-webhook.php

echo "4. 设置目录权限..."
chown -R www:www $WEBHOOK_DIR
chmod 755 $WEBHOOK_DIR
chmod 755 $WEBHOOK_DIR/deploy.sh
chmod 644 $WEBHOOK_DIR/github-webhook.php

echo "5. 初始化网站目录..."
cd $WEB_DIR

# 备份现有文件（如果有）
if [ "$(ls -A)" ]; then
    echo "  备份现有文件到 backup_$(date +%Y%m%d_%H%M%S)..."
    mkdir -p backup_$(date +%Y%m%d_%H%M%S)
    mv * backup_$(date +%Y%m%d_%H%M%S)/ 2>/dev/null || true
fi

# 克隆仓库
echo "  克隆 GitHub 仓库..."
git clone $REPO_URL .

# 安装依赖并构建
echo "  安装依赖..."
npm install

echo "  构建项目..."
npm run build

# 复制 dist 内容到根目录
if [ -d "dist" ]; then
    echo "  复制构建文件到网站根目录..."
    cp -r dist/* .
fi

echo ""
echo "========================================"
echo "  配置完成！"
echo "========================================"
echo ""
echo "【Webhook 地址】"
echo "http://你的域名/webhook/github-webhook.php"
echo ""
echo "【安全密钥】"
echo "$SECRET_KEY"
echo ""
echo "【GitHub Webhook 配置步骤】"
echo "1. 访问: https://github.com/VIPniuma/toolbox-landing/settings/hooks"
echo "2. 点击 'Add webhook'"
echo "3. Payload URL: http://你的域名/webhook/github-webhook.php"
echo "4. Content type: application/json"
echo "5. Secret: $SECRET_KEY"
echo "6. 选择 'Just the push event'"
echo "7. 点击 'Add webhook'"
echo ""
echo "【宝塔面板配置】"
echo "1. 登录宝塔面板"
echo "2. 进入网站 -> 你的域名 -> 设置"
echo "3. 在网站目录中确认运行目录是: /www/wwwroot/nntool"
echo "4. 添加伪静态规则（如果是SPA）:"
echo "   location / {"
echo "       try_files \$uri \$uri/ /index.html;"
echo "   }"
echo ""
echo "【测试部署】"
echo "执行: /www/webhook/deploy.sh"
echo ""
