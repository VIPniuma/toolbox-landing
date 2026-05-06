import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { FaChevronLeft, FaChevronRight, FaDesktop, FaMobile, FaTabletAlt } from 'react-icons/fa'
import './Screenshots.css'

const Screenshots = () => {
  const [currentIndex, setCurrentIndex] = useState(0)

  const screenshots = [
    {
      id: 1,
      title: '主界面',
      description: '简洁直观的仪表盘，一目了然查看设备状态',
      icon: <FaDesktop />
    },
    {
      id: 2,
      title: '刷机向导',
      description: '智能引导，三步完成刷机操作',
      icon: <FaMobile />
    },
    {
      id: 3,
      title: 'ADB终端',
      description: '专业级终端，支持多标签和命令补全',
      icon: <FaTabletAlt />
    }
  ]

  const nextSlide = () => {
    setCurrentIndex((prev) => (prev + 1) % screenshots.length)
  }

  const prevSlide = () => {
    setCurrentIndex((prev) => (prev - 1 + screenshots.length) % screenshots.length)
  }

  return (
    <section className="section screenshots" id="screenshots">
      <div className="container">
        {/* 标题区 */}
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: '-100px' }}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">界面预览</span>
          <h2 className="section-title">
            精心设计的<span className="gradient-text">用户界面</span>
          </h2>
          <p className="section-description">
            现代化的设计语言，流畅的交互动画，让每一次操作都成为一种享受。
          </p>
        </motion.div>

        {/* 截图轮播 */}
        <motion.div
          className="screenshots-showcase"
          initial={{ opacity: 0, y: 40 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: '-50px' }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          {/* 主展示区 */}
          <div className="showcase-main">
            <AnimatePresence mode="wait">
              <motion.div
                key={currentIndex}
                className="showcase-frame"
                initial={{ opacity: 0, x: 100 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -100 }}
                transition={{ duration: 0.4 }}
              >
                {/* 模拟窗口 */}
                <div className="mockup-window">
                  <div className="mockup-header">
                    <div className="mockup-dots">
                      <span className="dot red"></span>
                      <span className="dot yellow"></span>
                      <span className="dot green"></span>
                    </div>
                    <div className="mockup-title">NexusTool - {screenshots[currentIndex].title}</div>
                  </div>
                  <div className="mockup-content">
                    <div className="mockup-sidebar">
                      <div className="sidebar-item active">
                        <FaDesktop />
                        <span>仪表盘</span>
                      </div>
                      <div className="sidebar-item">
                        <FaMobile />
                        <span>设备管理</span>
                      </div>
                      <div className="sidebar-item">
                        <FaTabletAlt />
                        <span>ADB工具</span>
                      </div>
                      <div className="sidebar-item">
                        <FaDesktop />
                        <span>系统优化</span>
                      </div>
                      <div className="sidebar-item">
                        <FaMobile />
                        <span>刷机向导</span>
                      </div>
                    </div>
                    <div className="mockup-body">
                      <div className="mockup-card-grid">
                        <div className="mock-card large">
                          <div className="mock-card-icon" style={{ background: 'linear-gradient(135deg, #a855f7, #3b82f6)' }}>
                            <FaMobile />
                          </div>
                          <div className="mock-card-info">
                            <h4>设备已连接</h4>
                            <p>Xiaomi 13 Ultra</p>
                          </div>
                        </div>
                        <div className="mock-card">
                          <div className="mock-card-icon" style={{ background: 'linear-gradient(135deg, #10b981, #06b6d4)' }}>
                            <FaDesktop />
                          </div>
                          <div className="mock-card-info">
                            <h4>系统版本</h4>
                            <p>Android 14</p>
                          </div>
                        </div>
                        <div className="mock-card">
                          <div className="mock-card-icon" style={{ background: 'linear-gradient(135deg, #ec4899, #f59e0b)' }}>
                            <FaTabletAlt />
                          </div>
                          <div className="mock-card-info">
                            <h4>Root状态</h4>
                            <p>已获取</p>
                          </div>
                        </div>
                        <div className="mock-card wide">
                          <div className="mock-chart">
                            <div className="chart-bar" style={{ height: '60%' }}></div>
                            <div className="chart-bar" style={{ height: '80%' }}></div>
                            <div className="chart-bar" style={{ height: '45%' }}></div>
                            <div className="chart-bar" style={{ height: '90%' }}></div>
                            <div className="chart-bar" style={{ height: '70%' }}></div>
                          </div>
                          <div className="mock-card-info">
                            <h4>性能监控</h4>
                            <p>CPU 使用率趋势</p>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </motion.div>
            </AnimatePresence>

            {/* 导航按钮 */}
            <button className="showcase-nav prev" onClick={prevSlide}>
              <FaChevronLeft />
            </button>
            <button className="showcase-nav next" onClick={nextSlide}>
              <FaChevronRight />
            </button>
          </div>

          {/* 缩略图导航 */}
          <div className="showcase-thumbnails">
            {screenshots.map((screenshot, index) => (
              <button
                key={screenshot.id}
                className={`thumbnail ${index === currentIndex ? 'active' : ''}`}
                onClick={() => setCurrentIndex(index)}
              >
                <div className="thumbnail-icon">{screenshot.icon}</div>
                <div className="thumbnail-info">
                  <span className="thumbnail-title">{screenshot.title}</span>
                  <span className="thumbnail-desc">{screenshot.description}</span>
                </div>
              </button>
            ))}
          </div>
        </motion.div>
      </div>
    </section>
  )
}

export default Screenshots
