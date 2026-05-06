import { useEffect, useState } from 'react'
import Navbar from './components/Navbar'
import Hero from './components/Hero'
import Features from './components/Features'
import Screenshots from './components/Screenshots'
import Download from './components/Download'
import FAQ from './components/FAQ'
import Footer from './components/Footer'
import './App.css'

function App() {
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    // 模拟加载动画
    const timer = setTimeout(() => {
      setIsLoading(false)
    }, 500)
    return () => clearTimeout(timer)
  }, [])

  if (isLoading) {
    return (
      <div className="loading-screen">
        <div className="loading-spinner"></div>
        <p>Loading NexusTool...</p>
      </div>
    )
  }

  return (
    <div className="app">
      <Navbar />
      <main>
        <Hero />
        <Features />
        <Screenshots />
        <Download />
        <FAQ />
      </main>
      <Footer />
    </div>
  )
}

export default App
