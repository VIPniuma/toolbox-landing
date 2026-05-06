# NexusTool 宝塔自动部署配置指南

## 📋 配置步骤

### 第一步：在宝塔服务器上执行配置脚本

```bash
# 下载并执行配置脚本
curl -fsSL https://raw.githubusercontent.com/VIPniuma/toolbox-landing/master/deploy-setup.sh | bash

# 或者手动执行
wget https://raw.githubusercontent.com/VIPniuma/toolbox-landing/master/deploy-setup.sh
chmod +x deploy-setup.sh
./deploy-setup.sh
```

### 第二步：配置宝塔网站

1. **登录宝塔面板**
2. **进入网站 → 你的域名 → 设置**
3. **网站目录**：确认是 `/www/wwwroot/nntool`
4. **运行目录**：设置为 `/www/wwwroot/nntool`
5. **添加伪静态规则**（因为是单页应用）：
   ```nginx
   location / {
       try_files $uri $uri/ /index.html;
   }
   ```

### 第三步：配置 GitHub Webhook

1. 访问：https://github.com/VIPniuma/toolbox-landing/settings/hooks
2. 点击 **Add webhook**
3. 填写：
   - **Payload URL**: `http://你的域名/webhook/github-webhook.php`
   - **Content type**: `application/json`
   - **Secret**: `nntool_webhook_secure_key`（脚本会输出具体密钥）
   - **Which events?**: `Just the push event`
4. 点击 **Add webhook**

### 第四步：测试部署

1. **手动测试**：
   ```bash
   /www/webhook/deploy.sh
   ```

2. **自动测试**：
   - 修改 GitHub 仓库中的文件
   - 提交并推送
   - 查看宝塔服务器是否自动更新

## 📁 文件说明

| 文件 | 路径 | 说明 |
|------|------|------|
| 部署脚本 | `/www/webhook/deploy.sh` | 执行 git pull + npm install + build |
| Webhook 接收 | `/www/webhook/github-webhook.php` | 接收 GitHub 推送并触发部署 |
| 部署日志 | `/www/webhook/deploy.log` | 记录每次部署的详细信息 |
| Webhook 日志 | `/www/webhook/webhook.log` | 记录 webhook 触发记录 |

## 🔧 常见问题

### 1. 权限问题
```bash
chown -R www:www /www/webhook
chmod 755 /www/webhook/deploy.sh
```

### 2. Node.js 版本问题
```bash
# 检查 Node.js 版本
node -v

# 如果版本过低，使用 nvm 切换
nvm use 18
```

### 3. 手动触发部署
```bash
/www/webhook/deploy.sh
```

### 4. 查看日志
```bash
# 查看部署日志
tail -f /www/webhook/deploy.log

# 查看 webhook 日志
tail -f /www/webhook/webhook.log
```

## 📝 更新流程

1. 在本地修改代码
2. 推送到 GitHub：`git push origin master`
3. GitHub 自动触发 webhook
4. 宝塔服务器自动拉取代码并构建
5. 网站自动更新

## 🔒 安全说明

- Webhook 使用 HMAC-SHA256 签名验证
- 只有来自 GitHub 的请求才会触发部署
- 密钥保存在服务器端，不对外暴露
