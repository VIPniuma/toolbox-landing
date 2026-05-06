# NexusTool - 玩机工具箱官网

一个炫酷的暗黑科技风官网，用于展示和下载 NexusTool 玩机工具箱。

![NexusTool Landing Page](https://img.shields.io/badge/NexusTool-Landing%20Page-purple?style=for-the-badge)
![React](https://img.shields.io/badge/React-19-blue?style=for-the-badge&logo=react)
![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue?style=for-the-badge&logo=typescript)
![Vite](https://img.shields.io/badge/Vite-8-purple?style=for-the-badge&logo=vite)

## ✨ 特性

- 🎨 **暗黑科技风设计** - 霓虹渐变、玻璃拟态、流畅动画
- 📱 **完全响应式** - 完美适配桌面、平板和手机
- ⚡ **高性能** - 基于 React + Vite 构建，加载迅速
- 🎭 **丰富动画** - Framer Motion 驱动的流畅交互
- 🌐 **GitHub Pages 部署** - 一键部署到 GitHub Pages

## 🚀 快速开始

### 本地开发

```bash
# 克隆仓库
git clone https://github.com/yourusername/toolbox-landing.git
cd toolbox-landing

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

### 构建

```bash
# 构建生产版本
npm run build

# 预览生产构建
npm run preview
```

### 部署到 GitHub Pages

1. 修改 `vite.config.ts` 中的 `base` 为你的仓库名：
   ```ts
   base: '/your-repo-name/',
   ```

2. 修改 `package.json` 中的 `homepage`：
   ```json
   "homepage": "https://yourusername.github.io/your-repo-name"
   ```

3. 安装 gh-pages：
   ```bash
   npm install --save-dev gh-pages
   ```

4. 部署：
   ```bash
   npm run deploy
   ```

## 📁 项目结构

```
toolbox-landing/
├── src/
│   ├── components/          # 页面组件
│   │   ├── Navbar.tsx      # 导航栏
│   │   ├── Hero.tsx        # 首屏
│   │   ├── Features.tsx    # 功能展示
│   │   ├── Screenshots.tsx # 界面预览
│   │   ├── Download.tsx    # 下载区
│   │   ├── FAQ.tsx         # 常见问题
│   │   └── Footer.tsx      # 页脚
│   ├── App.tsx             # 主应用
│   ├── App.css             # 应用样式
│   ├── index.css           # 全局样式
│   └── main.tsx            # 入口文件
├── dist/                   # 构建输出
├── index.html              # HTML 模板
├── package.json            # 项目配置
├── tsconfig.json           # TypeScript 配置
└── vite.config.ts          # Vite 配置
```

## 🎨 自定义

### 修改品牌信息

1. **名称**: 搜索替换所有 `NexusTool` 为你自己的品牌名
2. **颜色**: 修改 `src/index.css` 中的 CSS 变量
3. **功能**: 编辑 `src/components/Features.tsx` 中的功能列表
4. **下载链接**: 修改 `src/components/Download.tsx` 中的下载按钮链接

### 颜色主题

在 `src/index.css` 中修改以下变量：

```css
:root {
  --neon-purple: #a855f7;  /* 主色调 */
  --neon-blue: #3b82f6;    /* 辅助色 */
  --neon-cyan: #06b6d4;    /* 强调色 */
  --neon-pink: #ec4899;    /* 装饰色 */
}
```

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

Made with ❤️ by NexusTool Team
