import { motion } from 'framer-motion'
import { FaWindows, FaApple, FaLinux, FaDownload, FaStar, FaCheckCircle } from 'react-icons/fa'
import './Download.css'

const Download = () => {
  const platforms = [
    {
      icon: <FaWindows />,
      name: 'Windows',
      version: 'v2.0.0',
      size: '85 MB',
      requirements: 'Windows 10/11',
      color: '#00a4ef',
      primary: true
    },
    {
      icon: <FaApple />,
      name: 'macOS',
      version: 'v2.0.0',
      size: '92 MB',
      requirements: 'macOS 11+',
      color: '#a2aaad',
      primary: false
    },
    {
      icon: <FaLinux />,
      name: 'Linux',
      version: 'v2.0.0',
      size: '78 MB',
      requirements: 'Ubuntu 20.04+',
      color: '#fcc624',
      primary: false
    }
  ]

  const highlights = [
    '完全免费，开源透明',
    '无广告，无捆绑',
    '持续更新维护',
    '社区技术支持'
  ]

  return (
    <section className="section download" id="download">
      <div className="container">
        {/* 标题区 */}
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: '-100px' }}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">立即下载</span>
          <h2 className="section-title">
            选择你的<span className="gradient-text">平台</span>
          </h2>
          <p className="section-description">
            NexusTool 支持 Windows、macOS 和 Linux 三大平台，选择适合你的版本开始体验。
          </p>
        </motion.div>

        {/* 下载卡片 */}
        <motion.div
          className="download-grid"
          initial={{ opacity: 0, y: 40 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: '-50px' }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          {platforms.map((platform, index) => (
            <motion.div
              key={platform.name}
              className={`download-card ${platform.primary ? 'primary' : ''}`}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: index * 0.1 }}
              whileHover={{ y: -8, transition: { duration: 0.3 } }}
            >
              {platform.primary && (
                <div className="download-badge">推荐</div>
              )}

              <div
                className="download-icon"
                style={{ background: `linear-gradient(135deg, ${platform.color}20, ${platform.color}10)` }}
              >
                <span style={{ color: platform.color }}>{platform.icon}</span>
              </div>

              <h3 className="download-name">{platform.name}</h3>

              <div className="download-meta">
                <span className="meta-item">{platform.version}</span>
                <span className="meta-separator">•</span>
                <span className="meta-item">{platform.size}</span>
              </div>

              <p className="download-requirements">
                系统要求: {platform.requirements}
              </p>

              <motion.button
                className={`btn-primary download-btn ${platform.primary ? '' : 'btn-outline'}`}
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                style={platform.primary ? {} : {
                  background: 'transparent',
                  border: `1px solid ${platform.color}`,
                  color: platform.color
                }}
              >
                <FaDownload />
                下载 {platform.name} 版
              </motion.button>
            </motion.div>
          ))}
        </motion.div>

        {/* 亮点展示 */}
        <motion.div
          className="download-highlights"
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.4 }}
        >
          {highlights.map((highlight, index) => (
            <motion.div
              key={highlight}
              className="highlight-item"
              initial={{ opacity: 0, x: -20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.5 + index * 0.1 }}
            >
              <FaCheckCircle className="highlight-icon" />
              <span>{highlight}</span>
            </motion.div>
          ))}
        </motion.div>

        {/* GitHub 链接 */}
        <motion.div
          className="download-github"
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true }}
          transition={{ delay: 0.6 }}
        >
          <p>
            喜欢 NexusTool？在 GitHub 给我们一颗 ⭐
          </p>
          <motion.a
            href="https://github.com"
            target="_blank"
            rel="noopener noreferrer"
            className="github-link"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            <FaStar />
            Star on GitHub
          </motion.a>
        </motion.div>
      </div>
    </section>
  )
}

export default Download
