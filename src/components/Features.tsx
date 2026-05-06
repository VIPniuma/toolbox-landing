import { motion, type Variants } from 'framer-motion'
import { FaMobileAlt, FaCogs, FaShieldAlt, FaRocket, FaSyncAlt, FaCode, FaTerminal, FaMicrochip } from 'react-icons/fa'
import './Features.css'

const Features = () => {
  const features = [
    {
      icon: <FaMobileAlt />,
      title: '一键刷机',
      description: '支持主流品牌设备一键刷机，自动匹配ROM，安全高效，小白也能轻松上手。',
      color: '#a855f7'
    },
    {
      icon: <FaCogs />,
      title: 'Root 管理',
      description: '智能检测Root状态，提供Magisk、KernelSU等多种Root方案，一键获取最高权限。',
      color: '#3b82f6'
    },
    {
      icon: <FaShieldAlt />,
      title: '系统优化',
      description: '深度清理系统垃圾，冻结无用应用，优化电池续航，让设备运行如飞。',
      color: '#10b981'
    },
    {
      icon: <FaRocket />,
      title: '性能加速',
      description: 'CPU/GPU调频、内存优化、启动项管理，全方位提升设备性能表现。',
      color: '#ec4899'
    },
    {
      icon: <FaSyncAlt />,
      title: '驱动管理',
      description: '自动识别设备驱动，一键安装ADB、Fastboot等开发工具，告别繁琐配置。',
      color: '#06b6d4'
    },
    {
      icon: <FaCode />,
      title: 'ADB 工具箱',
      description: '图形化ADB界面，支持命令快捷执行、日志实时查看、应用管理等功能。',
      color: '#f59e0b'
    },
    {
      icon: <FaTerminal />,
      title: '命令行终端',
      description: '内置终端模拟器，支持多标签、命令历史、自动补全，极客必备。',
      color: '#8b5cf6'
    },
    {
      icon: <FaMicrochip />,
      title: '硬件检测',
      description: '全面检测设备硬件信息，CPU、内存、存储、传感器状态一目了然。',
      color: '#ef4444'
    }
  ]

  const containerVariants: Variants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1
      }
    }
  }

  const itemVariants: Variants = {
    hidden: { opacity: 0, y: 30 },
    visible: {
      opacity: 1,
      y: 0,
      transition: {
        duration: 0.5,
        ease: [0.25, 0.1, 0.25, 1]
      }
    }
  }

  return (
    <section className="section features" id="features">
      <div className="container">
        {/* 标题区 */}
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: '-100px' }}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">核心功能</span>
          <h2 className="section-title">
            强大功能，<span className="gradient-text">一应俱全</span>
          </h2>
          <p className="section-description">
            NexusTool 集成了玩机所需的全部核心功能，从刷机到优化，从Root到调试，一站式解决你的所有需求。
          </p>
        </motion.div>

        {/* 功能卡片 */}
        <motion.div
          className="features-grid"
          variants={containerVariants}
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true, margin: '-50px' }}
        >
          {features.map((feature) => (
            <motion.div
              key={feature.title}
              className="feature-card"
              variants={itemVariants}
              whileHover={{ y: -8, transition: { duration: 0.3 } }}
            >
              <div
                className="feature-icon"
                style={{ background: `linear-gradient(135deg, ${feature.color}20, ${feature.color}10)` }}
              >
                <span style={{ color: feature.color }}>{feature.icon}</span>
              </div>
              <h3 className="feature-title">{feature.title}</h3>
              <p className="feature-description">{feature.description}</p>
              <div
                className="feature-glow"
                style={{ background: `radial-gradient(circle at center, ${feature.color}30, transparent 70%)` }}
              />
            </motion.div>
          ))}
        </motion.div>
      </div>
    </section>
  )
}

export default Features
