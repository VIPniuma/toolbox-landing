import { motion } from 'framer-motion'
import { FaTools, FaGithub, FaDiscord, FaTwitter, FaEnvelope, FaHeart } from 'react-icons/fa'
import './Footer.css'

const Footer = () => {
  const currentYear = new Date().getFullYear()

  const footerLinks = {
    product: [
      { label: '功能介绍', href: '#features' },
      { label: '界面预览', href: '#screenshots' },
      { label: '下载软件', href: '#download' },
      { label: '更新日志', href: '#' },
    ],
    resources: [
      { label: '使用文档', href: '#' },
      { label: 'API 文档', href: '#' },
      { label: '常见问题', href: '#faq' },
      { label: '视频教程', href: '#' },
    ],
    community: [
      { label: 'GitHub', href: 'https://github.com' },
      { label: 'Discord', href: '#' },
      { label: 'QQ 群组', href: '#' },
      { label: 'Telegram', href: '#' },
    ],
    legal: [
      { label: '隐私政策', href: '#' },
      { label: '使用条款', href: '#' },
      { label: '开源许可', href: '#' },
    ],
  }

  const socialLinks = [
    { icon: <FaGithub />, href: 'https://github.com', label: 'GitHub' },
    { icon: <FaDiscord />, href: '#', label: 'Discord' },
    { icon: <FaTwitter />, href: '#', label: 'Twitter' },
    { icon: <FaEnvelope />, href: 'mailto:support@nexustool.dev', label: 'Email' },
  ]

  const scrollToSection = (href: string) => {
    if (href.startsWith('#')) {
      const element = document.querySelector(href)
      if (element) {
        element.scrollIntoView({ behavior: 'smooth' })
      }
    }
  }

  return (
    <footer className="footer">
      <div className="container">
        {/* 主要内容 */}
        <motion.div
          className="footer-main"
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
        >
          {/* 品牌区 */}
          <div className="footer-brand">
            <a href="#" className="footer-logo">
              <div className="footer-logo-icon">
                <FaTools />
              </div>
              <span className="footer-logo-text">NexusTool</span>
            </a>
            <p className="footer-description">
              下一代玩机工具箱，让设备管理变得简单高效。开源、免费、无广告。
            </p>
            <div className="footer-social">
              {socialLinks.map((social) => (
                <motion.a
                  key={social.label}
                  href={social.href}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="social-link"
                  whileHover={{ scale: 1.1, y: -2 }}
                  whileTap={{ scale: 0.95 }}
                  aria-label={social.label}
                >
                  {social.icon}
                </motion.a>
              ))}
            </div>
          </div>

          {/* 链接区 */}
          <div className="footer-links">
            <div className="footer-links-column">
              <h4>产品</h4>
              <ul>
                {footerLinks.product.map((link) => (
                  <li key={link.label}>
                    <button
                      onClick={() => scrollToSection(link.href)}
                      className="footer-link"
                    >
                      {link.label}
                    </button>
                  </li>
                ))}
              </ul>
            </div>

            <div className="footer-links-column">
              <h4>资源</h4>
              <ul>
                {footerLinks.resources.map((link) => (
                  <li key={link.label}>
                    <a
                      href={link.href}
                      className="footer-link"
                      onClick={(e) => {
                        if (link.href.startsWith('#')) {
                          e.preventDefault()
                          scrollToSection(link.href)
                        }
                      }}
                    >
                      {link.label}
                    </a>
                  </li>
                ))}
              </ul>
            </div>

            <div className="footer-links-column">
              <h4>社区</h4>
              <ul>
                {footerLinks.community.map((link) => (
                  <li key={link.label}>
                    <a
                      href={link.href}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="footer-link"
                    >
                      {link.label}
                    </a>
                  </li>
                ))}
              </ul>
            </div>

            <div className="footer-links-column">
              <h4>法律</h4>
              <ul>
                {footerLinks.legal.map((link) => (
                  <li key={link.label}>
                    <a href={link.href} className="footer-link">
                      {link.label}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </motion.div>

        {/* 分隔线 */}
        <div className="footer-divider"></div>

        {/* 底部版权 */}
        <motion.div
          className="footer-bottom"
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true }}
          transition={{ delay: 0.2 }}
        >
          <p className="footer-copyright">
            © {currentYear} NexusTool. All rights reserved.
          </p>
          <p className="footer-made">
            Made with <FaHeart className="heart-icon" /> by NexusTool Team
          </p>
        </motion.div>
      </div>
    </footer>
  )
}

export default Footer
