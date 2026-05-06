import { motion } from 'framer-motion'
import { FaDownload, FaGithub, FaArrowDown, FaWindows, FaApple, FaLinux } from 'react-icons/fa'
import './Hero.css'

const Hero = () => {
  const scrollToDownload = () => {
    const element = document.querySelector('#download')
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' })
    }
  }

  const stats = [
    { value: '50K+', label: '活跃用户' },
    { value: '100+', label: '功能模块' },
    { value: '4.9', label: '用户评分' },
    { value: '99%', label: '好评率' },
  ]

  return (
    <section className="hero" id="hero">
      {/* 背景装饰 */}
      <div className="hero-bg-decoration">
        <div className="glow-orb orb-1"></div>
        <div className="glow-orb orb-2"></div>
        <div className="glow-orb orb-3"></div>
      </div>

      <div className="container hero-container">
        <motion.div
          className="hero-content"
          initial={{ opacity: 0, y: 40 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: 'easeOut' }}
        >
          {/* 标签 */}
          <motion.div
            className="hero-badge"
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.2, duration: 0.5 }}
          >
            <span className="badge-dot"></span>
            <span>v2.0 全新发布</span>
          </motion.div>

          {/* 标题 */}
          <motion.h1
            className="hero-title"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3, duration: 0.6 }}
          >
            <span className="title-line">下一代</span>
            <span className="title-line gradient-text">玩机工具箱</span>
          </motion.h1>

          {/* 描述 */}
          <motion.p
            className="hero-description"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4, duration: 0.6 }}
          >
            NexusTool 是一款专为极客打造的设备管理工具，集成刷机、Root、
            系统优化、驱动管理等功能，让你的设备焕发新生。
          </motion.p>

          {/* 按钮组 */}
          <motion.div
            className="hero-buttons"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5, duration: 0.6 }}
          >
            <motion.button
              className="btn-primary hero-cta"
              onClick={scrollToDownload}
              whileHover={{ scale: 1.05, boxShadow: '0 10px 40px rgba(168, 85, 247, 0.4)' }}
              whileTap={{ scale: 0.95 }}
            >
              <FaDownload />
              立即下载
            </motion.button>

            <motion.a
              href="https://github.com"
              target="_blank"
              rel="noopener noreferrer"
              className="btn-secondary hero-secondary"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <FaGithub />
              GitHub
            </motion.a>
          </motion.div>

          {/* 平台支持 */}
          <motion.div
            className="hero-platforms"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.6, duration: 0.6 }}
          >
            <span className="platform-label">支持平台：</span>
            <div className="platform-icons">
              <span className="platform-icon" title="Windows">
                <FaWindows />
              </span>
              <span className="platform-icon" title="macOS">
                <FaApple />
              </span>
              <span className="platform-icon" title="Linux">
                <FaLinux />
              </span>
            </div>
          </motion.div>
        </motion.div>

        {/* 统计数据 */}
        <motion.div
          className="hero-stats"
          initial={{ opacity: 0, y: 40 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7, duration: 0.6 }}
        >
          {stats.map((stat, index) => (
            <motion.div
              key={stat.label}
              className="stat-item"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.8 + index * 0.1, duration: 0.5 }}
            >
              <span className="stat-value">{stat.value}</span>
              <span className="stat-label">{stat.label}</span>
            </motion.div>
          ))}
        </motion.div>

        {/* 向下滚动提示 */}
        <motion.div
          className="scroll-indicator"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1.2, duration: 0.6 }}
        >
          <motion.div
            className="scroll-arrow"
            animate={{ y: [0, 10, 0] }}
            transition={{ duration: 1.5, repeat: Infinity, ease: 'easeInOut' }}
            onClick={scrollToDownload}
          >
            <FaArrowDown />
          </motion.div>
        </motion.div>
      </div>
    </section>
  )
}

export default Hero
