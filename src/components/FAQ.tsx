import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { FaChevronDown, FaQuestionCircle } from 'react-icons/fa'
import './FAQ.css'

const FAQ = () => {
  const [openIndex, setOpenIndex] = useState<number | null>(0)

  const faqs = [
    {
      question: 'NexusTool 是免费的吗？',
      answer: '是的，NexusTool 完全免费且开源。我们相信工具应该人人可用，因此不会收取任何费用。你可以在 GitHub 上查看完整的源代码，确保没有任何恶意代码或后门。'
    },
    {
      question: '使用 NexusTool 刷机会导致设备变砖吗？',
      answer: 'NexusTool 采用了多重安全保护机制，包括刷机前自动备份、ROM 完整性校验、电量检测等。只要按照向导提示操作，基本不会出现变砖情况。但刷机本身存在风险，建议在操作前做好数据备份。'
    },
    {
      question: '支持哪些品牌的设备？',
      answer: 'NexusTool 支持市面上绝大多数 Android 设备，包括但不限于小米、OPPO、vivo、华为、三星、一加、realme、魅族等品牌。对于部分特殊机型，可能需要手动下载对应的驱动和固件。'
    },
    {
      question: '如何获取 Root 权限？',
      answer: 'NexusTool 提供了一键 Root 功能，支持 Magisk、KernelSU 等多种 Root 方案。只需连接设备后，在"Root 管理"模块中选择合适的方案，点击"一键 Root"即可。整个过程会自动完成，无需手动输入命令。'
    },
    {
      question: '遇到问题时如何获取帮助？',
      answer: '你可以通过以下方式获取帮助：1) 查看软件内置的帮助文档；2) 访问我们的 GitHub Issues 页面提交问题；3) 加入官方 Discord/QQ 群组与社区成员交流；4) 发送邮件至 support@nexustool.dev 联系技术支持团队。'
    },
    {
      question: '软件会收集我的个人数据吗？',
      answer: '不会。NexusTool 尊重用户隐私，所有操作都在本地完成，不会上传任何个人数据到服务器。我们仅会收集匿名的崩溃报告和使用统计（可在设置中关闭），用于改进软件质量。'
    }
  ]

  const toggleFAQ = (index: number) => {
    setOpenIndex(openIndex === index ? null : index)
  }

  return (
    <section className="section faq" id="faq">
      <div className="container">
        {/* 标题区 */}
        <motion.div
          className="section-header"
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: '-100px' }}
          transition={{ duration: 0.6 }}
        >
          <span className="section-label">常见问题</span>
          <h2 className="section-title">
            有疑问？<span className="gradient-text">我们来解答</span>
          </h2>
          <p className="section-description">
            以下是用户最常问的问题，如果没有找到你想要的答案，欢迎联系我们。
          </p>
        </motion.div>

        {/* FAQ 列表 */}
        <motion.div
          className="faq-list"
          initial={{ opacity: 0, y: 40 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: '-50px' }}
          transition={{ duration: 0.6, delay: 0.2 }}
        >
          {faqs.map((faq, index) => (
            <motion.div
              key={index}
              className={`faq-item ${openIndex === index ? 'open' : ''}`}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: index * 0.1 }}
            >
              <button
                className="faq-question"
                onClick={() => toggleFAQ(index)}
              >
                <div className="faq-icon">
                  <FaQuestionCircle />
                </div>
                <span className="faq-text">{faq.question}</span>
                <motion.div
                  className="faq-chevron"
                  animate={{ rotate: openIndex === index ? 180 : 0 }}
                  transition={{ duration: 0.3 }}
                >
                  <FaChevronDown />
                </motion.div>
              </button>

              <AnimatePresence>
                {openIndex === index && (
                  <motion.div
                    className="faq-answer"
                    initial={{ height: 0, opacity: 0 }}
                    animate={{ height: 'auto', opacity: 1 }}
                    exit={{ height: 0, opacity: 0 }}
                    transition={{ duration: 0.3, ease: 'easeInOut' }}
                  >
                    <div className="faq-answer-content">
                      {faq.answer}
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>
          ))}
        </motion.div>

        {/* 联系提示 */}
        <motion.div
          className="faq-contact"
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.4 }}
        >
          <p>还有其他问题？</p>
          <a
            href="https://github.com"
            target="_blank"
            rel="noopener noreferrer"
            className="btn-secondary"
          >
            联系我们
          </a>
        </motion.div>
      </div>
    </section>
  )
}

export default FAQ
