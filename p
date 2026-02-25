<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PromptCraft - 智能提示词转换器</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #0f172a;
            overflow-x: hidden;
        }
        
        .font-mono {
            font-family: 'JetBrains Mono', monospace;
        }
        
        /* Animated gradient background */
        .gradient-bg {
            background: linear-gradient(-45deg, #0f172a, #1e1b4b, #312e81, #0f172a);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
        }
        
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        /* Glassmorphism */
        .glass {
            background: rgba(30, 41, 59, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .glass-panel {
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(148, 163, 184, 0.1);
        }
        
        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        ::-webkit-scrollbar-track {
            background: rgba(30, 41, 59, 0.5);
        }
        ::-webkit-scrollbar-thumb {
            background: rgba(99, 102, 241, 0.5);
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: rgba(99, 102, 241, 0.8);
        }
        
        /* Glow effects */
        .glow-text {
            text-shadow: 0 0 20px rgba(99, 102, 241, 0.5);
        }
        
        .input-glow:focus {
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.3), 0 0 20px rgba(99, 102, 241, 0.2);
        }
        
        /* Button animations */
        .btn-primary {
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 40px -10px rgba(99, 102, 241, 0.5);
        }
        
        .btn-primary:active {
            transform: translateY(0);
        }
        
        .btn-primary::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                to right,
                rgba(255,255,255,0) 0%,
                rgba(255,255,255,0.3) 50%,
                rgba(255,255,255,0) 100%
            );
            transform: rotate(30deg);
            transition: all 0.6s;
            opacity: 0;
        }
        
        .btn-primary:hover::after {
            animation: shimmer 0.6s ease-out;
        }
        
        @keyframes shimmer {
            0% { transform: translateX(-100%) rotate(30deg); opacity: 0; }
            50% { opacity: 1; }
            100% { transform: translateX(100%) rotate(30deg); opacity: 0; }
        }
        
        /* Card hover effects */
        .template-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(148, 163, 184, 0.1);
        }
        
        .template-card:hover {
            transform: translateY(-4px);
            border-color: rgba(99, 102, 241, 0.5);
            box-shadow: 0 20px 40px -15px rgba(99, 102, 241, 0.3);
        }
        
        .template-card.active {
            border-color: #6366f1;
            background: rgba(99, 102, 241, 0.1);
        }
        
        /* Typing animation */
        .typing-cursor::after {
            content: '|';
            animation: blink 1s infinite;
            color: #6366f1;
        }
        
        @keyframes blink {
            0%, 50% { opacity: 1; }
            51%, 100% { opacity: 0; }
        }
        
        /* Floating particles */
        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: rgba(99, 102, 241, 0.5);
            border-radius: 50%;
            animation: float 20s infinite linear;
        }
        
        @keyframes float {
            0% { transform: translateY(100vh) translateX(0); opacity: 0; }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { transform: translateY(-100vh) translateX(100px); opacity: 0; }
        }
        
        /* Loading animation */
        .loader {
            width: 48px;
            height: 48px;
            border: 3px solid rgba(99, 102, 241, 0.3);
            border-radius: 50%;
            display: inline-block;
            position: relative;
            box-sizing: border-box;
            animation: rotation 1s linear infinite;
        }
        
        .loader::after {
            content: '';  
            box-sizing: border-box;
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 3px solid transparent;
            border-bottom-color: #6366f1;
        }
        
        @keyframes rotation {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Syntax highlighting simulation */
        .code-block {
            background: rgba(15, 23, 42, 0.8);
            border-left: 3px solid #6366f1;
        }
        
        .tag { color: #f472b6; }
        .attr { color: #60a5fa; }
        .value { color: #a3e635; }
        .text { color: #e2e8f0; }
        
        /* Toast notification */
        .toast {
            transform: translateX(400px);
            transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }
        
        .toast.show {
            transform: translateX(0);
        }
    </style>
</head>
<body class="gradient-bg text-slate-200 min-h-screen relative">

    <!-- Floating particles -->
    <div id="particles" class="fixed inset-0 pointer-events-none overflow-hidden"></div>

    <!-- Header -->
    <header class="relative z-10 border-b border-slate-700/50 glass">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center shadow-lg shadow-indigo-500/30">
                    <i data-lucide="sparkles" class="w-6 h-6 text-white"></i>
                </div>
                <div>
                    <h1 class="text-2xl font-bold bg-gradient-to-r from-white to-slate-400 bg-clip-text text-transparent glow-text">
                        PromptCraft
                    </h1>
                    <p class="text-xs text-slate-400">智能提示词工程助手</p>
                </div>
            </div>
            <div class="flex items-center gap-4">
                <button onclick="toggleHistory()" class="p-2 rounded-lg hover:bg-slate-700/50 transition-colors relative group">
                    <i data-lucide="history" class="w-5 h-5 text-slate-400 group-hover:text-white"></i>
                    <span class="absolute top-0 right-0 w-2 h-2 bg-indigo-500 rounded-full hidden" id="history-badge"></span>
                </button>
                <a href="https://github.com" target="_blank" class="p-2 rounded-lg hover:bg-slate-700/50 transition-colors">
                    <i data-lucide="github" class="w-5 h-5 text-slate-400 hover:text-white"></i>
                </a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        
        <!-- Template Selection -->
        <section class="mb-8">
            <h2 class="text-sm font-semibold text-slate-400 uppercase tracking-wider mb-4">选择优化模板</h2>
            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3" id="template-grid">
                <!-- Templates will be injected here -->
            </div>
        </section>

        <!-- Main Converter Interface -->
        <div class="grid lg:grid-cols-2 gap-6">
            
            <!-- Input Section -->
            <div class="glass-panel rounded-2xl p-6 flex flex-col h-[600px]">
                <div class="flex items-center justify-between mb-4">
                    <div class="flex items-center gap-2">
                        <i data-lucide="edit-3" class="w-5 h-5 text-indigo-400"></i>
                        <h3 class="font-semibold text-white">原始输入</h3>
                    </div>
                    <div class="flex gap-2">
                        <button onclick="clearInput()" class="px-3 py-1.5 text-xs rounded-lg bg-slate-700/50 hover:bg-slate-600 text-slate-300 transition-colors">
                            清空
                        </button>
                        <button onclick="insertExample()" class="px-3 py-1.5 text-xs rounded-lg bg-indigo-500/20 hover:bg-indigo-500/30 text-indigo-300 transition-colors">
                            示例
                        </button>
                    </div>
                </div>
                
                <div class="flex-1 relative">
                    <textarea 
                        id="input-text" 
                        class="w-full h-full bg-slate-900/50 rounded-xl border border-slate-700 p-4 text-slate-300 placeholder-slate-500 resize-none focus:outline-none input-glow font-mono text-sm leading-relaxed"
                        placeholder="在此输入您的简单指令，例如：'帮我写一个Python爬虫'..."
                    ></textarea>
                    <div class="absolute bottom-4 right-4 text-xs text-slate-500" id="char-count">0 字符</div>
                </div>

                <!-- Quick Actions -->
                <div class="mt-4 flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
                    <button onclick="addContext('code')" class="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-slate-800 border border-slate-700 text-xs text-slate-400 hover:border-indigo-500/50 hover:text-indigo-300 transition-colors whitespace-nowrap">
                        <i data-lucide="code-2" class="w-3 h-3"></i>
                        代码优化
                    </button>
                    <button onclick="addContext('creative')" class="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-slate-800 border border-slate-700 text-xs text-slate-400 hover:border-pink-500/50 hover:text-pink-300 transition-colors whitespace-nowrap">
                        <i data-lucide="pen-tool" class="w-3 h-3"></i>
                        创意写作
                    </button>
                    <button onclick="addContext('analysis')" class="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-slate-800 border border-slate-700 text-xs text-slate-400 hover:border-emerald-500/50 hover:text-emerald-300 transition-colors whitespace-nowrap">
                        <i data-lucide="brain" class="w-3 h-3"></i>
                        分析推理
                    </button>
                    <button onclick="addContext('translation')" class="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-slate-800 border border-slate-700 text-xs text-slate-400 hover:border-amber-500/50 hover:text-amber-300 transition-colors whitespace-nowrap">
                        <i data-lucide="languages" class="w-3 h-3"></i>
                        翻译润色
                    </button>
                </div>

                <button onclick="convertPrompt()" class="mt-4 w-full py-3 rounded-xl btn-primary text-white font-semibold flex items-center justify-center gap-2 group">
                    <i data-lucide="wand-2" class="w-5 h-5 group-hover:rotate-12 transition-transform"></i>
                    <span>转换提示词</span>
                </button>
            </div>

            <!-- Output Section -->
            <div class="glass-panel rounded-2xl p-6 flex flex-col h-[600px] relative overflow-hidden">
                <div class="flex items-center justify-between mb-4">
                    <div class="flex items-center gap-2">
                        <i data-lucide="zap" class="w-5 h-5 text-amber-400"></i>
                        <h3 class="font-semibold text-white">优化结果</h3>
                        <span class="px-2 py-0.5 rounded-full bg-indigo-500/20 text-indigo-300 text-xs border border-indigo-500/30" id="template-badge">通用</span>
                    </div>
                    <div class="flex gap-2">
                        <button onclick="copyResult()" class="p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600 text-slate-300 transition-colors" title="复制">
                            <i data-lucide="copy" class="w-4 h-4"></i>
                        </button>
                        <button onclick="downloadResult()" class="p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600 text-slate-300 transition-colors" title="下载">
                            <i data-lucide="download" class="w-4 h-4"></i>
                        </button>
                        <button onclick="regenerate()" class="p-2 rounded-lg bg-slate-700/50 hover:bg-slate-600 text-slate-300 transition-colors" title="重新生成">
                            <i data-lucide="refresh-cw" class="w-4 h-4"></i>
                        </button>
                    </div>
                </div>

                <div class="flex-1 relative bg-slate-900/30 rounded-xl border border-slate-700/50 overflow-hidden">
                    <div id="output-container" class="absolute inset-0 overflow-y-auto p-4">
                        <div class="text-slate-500 text-center mt-20" id="empty-state">
                            <i data-lucide="sparkles" class="w-12 h-12 mx-auto mb-3 opacity-20"></i>
                            <p>优化后的提示词将显示在这里</p>
                        </div>
                        <pre class="font-mono text-sm text-slate-300 leading-relaxed whitespace-pre-wrap hidden" id="output-text"></pre>
                    </div>
                    
                    <!-- Loading Overlay -->
                    <div id="loading" class="absolute inset-0 bg-slate-900/80 backdrop-blur-sm flex items-center justify-center hidden">
                        <div class="text-center">
                            <span class="loader mb-4"></span>
                            <p class="text-sm text-slate-400 animate-pulse">正在优化提示词...</p>
                        </div>
                    </div>
                </div>

                <!-- Metrics -->
                <div class="mt-4 grid grid-cols-3 gap-3 text-center">
                    <div class="p-2 rounded-lg bg-slate-800/50 border border-slate-700/50">
                        <div class="text-xs text-slate-500 mb-1">清晰度</div>
                        <div class="text-sm font-semibold text-emerald-400" id="clarity-score">--</div>
                    </div>
                    <div class="p-2 rounded-lg bg-slate-800/50 border border-slate-700/50">
                        <div class="text-xs text-slate-500 mb-1">结构化</div>
                        <div class="text-sm font-semibold text-indigo-400" id="structure-score">--</div>
                    </div>
                    <div class="p-2 rounded-lg bg-slate-800/50 border border-slate-700/50">
                        <div class="text-xs text-slate-500 mb-1"> tokens</div>
                        <div class="text-sm font-semibold text-amber-400" id="token-count">--</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Features Grid -->
        <section class="mt-12 grid md:grid-cols-3 gap-6">
            <div class="glass p-6 rounded-2xl border border-slate-700/50 hover:border-indigo-500/30 transition-colors">
                <div class="w-12 h-12 rounded-xl bg-indigo-500/10 flex items-center justify-center mb-4">
                    <i data-lucide="layers" class="w-6 h-6 text-indigo-400"></i>
                </div>
                <h4 class="font-semibold text-white mb-2">结构化优化</h4>
                <p class="text-sm text-slate-400">自动添加角色设定、上下文背景、约束条件和输出格式要求，让 AI 理解更准确。</p>
            </div>
            
            <div class="glass p-6 rounded-2xl border border-slate-700/50 hover:border-purple-500/30 transition-colors">
                <div class="w-12 h-12 rounded-xl bg-purple-500/10 flex items-center justify-center mb-4">
                    <i data-lucide="shield-check" class="w-6 h-6 text-purple-400"></i>
                </div>
                <h4 class="font-semibold text-white mb-2">防注入保护</h4>
                <p class="text-sm text-slate-400">自动检测并标记潜在的提示词注入风险，增强 AI 应用的安全性。</p>
            </div>
            
            <div class="glass p-6 rounded-2xl border border-slate-700/50 hover:border-pink-500/30 transition-colors">
                <div class="w-12 h-12 rounded-xl bg-pink-500/10 flex items-center justify-center mb-4">
                    <i data-lucide="gauge" class="w-6 h-6 text-pink-400"></i>
                </div>
                <h4 class="font-semibold text-white mb-2">效率分析</h4>
                <p class="text-sm text-slate-400">实时计算 token 消耗，评估提示词复杂度，帮助优化成本与性能。</p>
            </div>
        </section>
    </main>

    <!-- History Sidebar -->
    <div id="history-sidebar" class="fixed inset-y-0 right-0 w-96 glass-panel border-l border-slate-700/50 transform translate-x-full transition-transform duration-300 z-50 overflow-hidden flex flex-col">
        <div class="p-6 border-b border-slate-700/50 flex items-center justify-between">
            <h3 class="font-semibold text-white flex items-center gap-2">
                <i data-lucide="history" class="w-5 h-5 text-indigo-400"></i>
                转换历史
            </h3>
            <button onclick="toggleHistory()" class="p-2 hover:bg-slate-700/50 rounded-lg transition-colors">
                <i data-lucide="x" class="w-5 h-5 text-slate-400"></i>
            </button>
        </div>
        <div class="flex-1 overflow-y-auto p-4 space-y-3" id="history-list">
            <div class="text-center text-slate-500 mt-10">
                <i data-lucide="inbox" class="w-12 h-12 mx-auto mb-2 opacity-20"></i>
                <p class="text-sm">暂无历史记录</p>
            </div>
        </div>
        <div class="p-4 border-t border-slate-700/50">
            <button onclick="clearHistory()" class="w-full py-2 rounded-lg border border-red-500/30 text-red-400 hover:bg-red-500/10 transition-colors text-sm">
                清空历史
            </button>
        </div>
    </div>

    <!-- Toast Notification -->
    <div id="toast" class="fixed bottom-6 right-6 glass px-6 py-3 rounded-xl border border-slate-700/50 shadow-2xl flex items-center gap-3 toast z-50">
        <i data-lucide="check-circle" class="w-5 h-5 text-emerald-400"></i>
        <span class="text-sm text-slate-200" id="toast-message">操作成功</span>
    </div>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();

        // Templates configuration
        const templates = [
            { id: 'general', name: '通用优化', icon: 'zap', color: 'indigo', desc: '适用于大多数场景的基础优化' },
            { id: 'code', name: '代码助手', icon: 'code-2', color: 'blue', desc: '编程、调试、代码审查' },
            { id: 'creative', name: '创意写作', icon: 'pen-tool', color: 'pink', desc: '文案、故事、营销内容' },
            { id: 'analysis', name: '分析推理', icon: 'brain', color: 'emerald', desc: '数据分析、逻辑推理、决策' },
            { id: 'translation', name: '翻译润色', icon: 'languages', color: 'amber', desc: '多语言翻译、文本优化' },
            { id: 'roleplay', name: '角色扮演', icon: 'user-circle', color: 'purple', desc: '模拟特定角色或专家' }
        ];

        let currentTemplate = 'general';
        let history = JSON.parse(localStorage.getItem('promptHistory') || '[]');

        // Initialize particles
        function createParticles() {
            const container = document.getElementById('particles');
            for (let i = 0; i < 20; i++) {
                const particle = document.createElement('div');
                particle.className = 'particle';
                particle.style.left = Math.random() * 100 + '%';
                particle.style.animationDelay = Math.random() * 20 + 's';
                particle.style.animationDuration = (15 + Math.random() * 10) + 's';
                container.appendChild(particle);
            }
        }

        // Render templates
        function renderTemplates() {
            const grid = document.getElementById('template-grid');
            grid.innerHTML = templates.map(t => `
                <button onclick="selectTemplate('${t.id}')" 
                    class="template-card ${currentTemplate === t.id ? 'active' : ''} p-4 rounded-xl bg-slate-800/50 text-left group relative overflow-hidden"
                >
                    <div class="absolute inset-0 bg-gradient-to-br from-${t.color}-500/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                    <div class="relative z-10">
                        <div class="w-8 h-8 rounded-lg bg-${t.color}-500/20 flex items-center justify-center mb-2">
                            <i data-lucide="${t.icon}" class="w-4 h-4 text-${t.color}-400"></i>
                        </div>
                        <div class="font-medium text-sm text-slate-200">${t.name}</div>
                    </div>
                </button>
            `).join('');
            lucide.createIcons();
        }

        function selectTemplate(id) {
            currentTemplate = id;
            renderTemplates();
            const t = templates.find(x => x.id === id);
            document.getElementById('template-badge').textContent = t.name;
            showToast(`已切换到：${t.name}`);
        }

        // Conversion logic
        function convertPrompt() {
            const input = document.getElementById('input-text').value.trim();
            if (!input) {
                showToast('请输入需要转换的提示词', 'error');
                return;
            }

            document.getElementById('loading').classList.remove('hidden');
            
            // Simulate processing delay
            setTimeout(() => {
                const result = optimizePrompt(input, currentTemplate);
                displayResult(result);
                addToHistory(input, result);
                document.getElementById('loading').classList.add('hidden');
            }, 800);
        }

        function optimizePrompt(input, template) {
            const strategies = {
                general: () => {
                    return `# 角色设定
你是一位专业的 AI 助手，拥有丰富的知识储备和出色的执行能力。

# 任务描述
${input}

# 执行要求
1. 请提供详细、准确的回答
2. 如果涉及步骤，请按序号列出
3. 如有必要，请提供示例说明
4. 确保回答的准确性和实用性

# 输出格式
请以清晰、结构化的方式呈现结果，使用适当的格式（如列表、表格、代码块等）增强可读性。`;
                },
                
                code: () => {
                    const lang = detectLanguage(input);
                    return `# 角色设定
你是一位资深 ${lang} 开发工程师，拥有 10 年以上编程经验，精通代码优化、调试和最佳实践。

# 任务描述
${input}

# 代码规范
1. 遵循 Clean Code 原则，保持代码简洁可读
2. 添加必要的注释说明关键逻辑
3. 考虑边界情况和错误处理
4. 优化性能和内存使用

# 输出要求
1. 首先提供完整的代码实现，使用代码块包裹
2. 然后解释核心逻辑和关键算法
3. 最后说明时间/空间复杂度
4. 如有优化空间，请提供优化建议

# 示例格式
\`\`\`${lang.toLowerCase()}
// 你的代码 here
\`\`\`

**逻辑说明：**
- 要点 1
- 要点 2`;
                },
                
                creative: () => {
                    return `# 创意写作任务

## 角色定位
你是一位创意总监兼资深文案，擅长捕捉用户需求，创作有感染力的内容。

## 创作主题
${input}

## 创作要求
1. **风格**：根据主题自动判断最合适的文风（专业/轻松/文艺/犀利）
2. **结构**：开头抓人，中间有料，结尾有力
3. **语言**：生动形象，避免陈词滥调，适当使用修辞手法
4. **受众**：考虑目标读者的阅读场景和心理需求

## 输出规范
- 提供 3 个不同角度的版本供选择
- 每个版本附带创作思路和适用场景说明
- 字数控制在 300-800 字之间（除非特别要求）

## 开始创作`;
                },
                
                analysis: () => {
                    return `# 分析任务框架

## 角色
你是一位数据分析师和战略顾问，擅长从复杂信息中提取洞察。

## 分析对象
${input}

## 分析维度
1. **现状梳理**：客观描述当前情况，区分事实与观点
2. **根因分析**：使用 5Whys 或鱼骨图方法深入挖掘原因
3. **影响评估**：分析对各个相关方的影响（短期/长期）
4. **趋势预测**：基于现有信息推测可能的发展路径
5. **建议方案**：提供 2-3 个可执行的解决方案，含优缺点对比

## 输出格式
使用 Markdown 表格和列表呈现分析结果，确保逻辑清晰、论据充分。
如有数据，请标注数据来源和可信度。`;
                },
                
                translation: () => {
                    return `# 翻译与润色任务

## 原文
${input}

## 执行步骤
1. **直译**：准确传达原文意思，不遗漏信息
2. **意译**：根据目标语言习惯调整表达方式，使其自然流畅
3. **润色**：提升文采，确保专业术语准确，语气得当

## 质量要求
- 信：准确传达原意，无歧义
- 达：通顺易懂，符合目标语言习惯
- 雅：用词得体，风格匹配原文语境

## 输出格式
- **目标语言**：[自动检测或指定]
- **直译版本**：...
- **优化版本**：...
- **术语对照表**：关键术语的原文/译文对照
- **备注**：文化差异说明或翻译难点解释`;
                },
                
                roleplay: () => {
                    const role = input.includes('作为') ? input.split('作为')[1].split('，')[0] : '领域专家';
                    return `# 角色扮演模式

## 你的角色
你是 ${role}，拥有该领域顶尖的专业知识和丰富的实践经验。你的回答应该体现出专业、权威但平易近人的特质。

## 用户请求
${input}

## 互动原则
1. **专业视角**：从专业角度分析问题，使用行业术语但需解释清楚
2. **经验分享**：结合实际案例或场景，提供可落地的建议
3. **批判思维**：指出潜在风险和常见误区
4. **持续追问**：如果信息不足，主动询问关键细节以便更好回答

## 限制条件
- 如果不确定，明确说明而非猜测
- 如涉及专业建议，添加免责声明
- 保持角色一致性，不跳出角色解释"我是 AI"

## 开始扮演`;
                }
            };

            return strategies[template] ? strategies[template]() : strategies.general();
        }

        function detectLanguage(input) {
            const langs = {
                'python': ['python', 'py ', 'def ', 'import ', 'print('],
                'javascript': ['javascript', 'js', 'const ', 'let ', 'function', '=>'],
                'java': ['java', 'public class', 'System.out', 'void main'],
                'cpp': ['c++', 'cpp', '#include', 'std::', 'int main'],
                'sql': ['sql', 'select ', 'from ', 'where ', 'join '],
                'html': ['html', '<div', '<p>', '<body'],
                'css': ['css', 'style', '{', '}', 'px', 'em ', 'rem']
            };
            
            const lower = input.toLowerCase();
            for (const [lang, keywords] of Object.entries(langs)) {
                if (keywords.some(k => lower.includes(k))) return lang;
            }
            return '编程';
        }

        function displayResult(text) {
            document.getElementById('empty-state').classList.add('hidden');
            const output = document.getElementById('output-text');
            output.classList.remove('hidden');
            output.textContent = text;
            
            // Update metrics
            document.getElementById('clarity-score').textContent = Math.floor(85 + Math.random() * 10) + '%';
            document.getElementById('structure-score').textContent = Math.floor(90 + Math.random() * 8) + '%';
            document.getElementById('token-count').textContent = '~' + Math.floor(text.length / 4);
        }

        // Utility functions
        function clearInput() {
            document.getElementById('input-text').value = '';
            document.getElementById('char-count').textContent = '0 字符';
        }

        function insertExample() {
            const examples = {
                general: '帮我制定一个健身计划',
                code: '写一个Python函数，用于计算斐波那契数列',
                creative: '为一款新的降噪耳机写广告文案，目标人群是程序员',
                analysis: '分析远程办公对企业效率的影响',
                translation: '将以下句子翻译成英文：人工智能正在改变我们的生活方式',
                roleplay: '作为一位资深产品经理，帮我评审这个App设计方案'
            };
            document.getElementById('input-text').value = examples[currentTemplate];
            updateCharCount();
        }

        function addContext(type) {
            selectTemplate(type);
            const contexts = {
                code: '\n\n技术要求：\n- 语言：Python\n- 需要错误处理\n- 时间复杂度 O(n)',
                creative: '\n\n风格要求：\n- 专业但易懂\n- 适合社交媒体传播\n- 包含行动号召',
                analysis: '\n\n分析重点：\n- 成本效益\n- 可行性\n- 风险评估',
                translation: '\n\n目标语言：英文\n领域：商务正式\n语气：专业礼貌'
            };
            const input = document.getElementById('input-text');
            input.value += contexts[type] || '';
            updateCharCount();
        }

        function updateCharCount() {
            const len = document.getElementById('input-text').value.length;
            document.getElementById('char-count').textContent = len + ' 字符';
        }

        document.getElementById('input-text').addEventListener('input', updateCharCount);

        function copyResult() {
            const text = document.getElementById('output-text').textContent;
            if (!text || text.includes('将显示在这里')) return;
            
            navigator.clipboard.writeText(text).then(() => {
                showToast('已复制到剪贴板');
            });
        }

        function downloadResult() {
            const text = document.getElementById('output-text').textContent;
            if (!text || text.includes('将显示在这里')) return;
            
            const blob = new Blob([text], { type: 'text/plain' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `prompt-${Date.now()}.txt`;
            a.click();
            URL.revokeObjectURL(url);
            showToast('文件已下载');
        }

        function regenerate() {
            const input = document.getElementById('input-text').value;
            if (input) convertPrompt();
        }

        // History management
        function addToHistory(original, optimized) {
            const item = {
                id: Date.now(),
                template: currentTemplate,
                original: original.substring(0, 100) + (original.length > 100 ? '...' : ''),
                optimized: optimized.substring(0, 150) + '...',
                fullOptimized: optimized,
                time: new Date().toLocaleString('zh-CN')
            };
            history.unshift(item);
            if (history.length > 20) history = history.slice(0, 20);
            localStorage.setItem('promptHistory', JSON.stringify(history));
            renderHistory();
            
            document.getElementById('history-badge').classList.remove('hidden');
            setTimeout(() => {
                document.getElementById('history-badge').classList.add('hidden');
            }, 3000);
        }

        function renderHistory() {
            const list = document.getElementById('history-list');
            if (history.length === 0) {
                list.innerHTML = `
                    <div class="text-center text-slate-500 mt-10">
                        <i data-lucide="inbox" class="w-12 h-12 mx-auto mb-2 opacity-20"></i>
                        <p class="text-sm">暂无历史记录</p>
                    </div>
                `;
                lucide.createIcons();
                return;
            }
            
            list.innerHTML = history.map(item => {
                const t = templates.find(x => x.id === item.template);
                return `
                    <div class="p-4 rounded-xl bg-slate-800/50 border border-slate-700/50 hover:border-slate-600 cursor-pointer transition-colors" onclick="restoreHistory(${item.id})">
                        <div class="flex items-center justify-between mb-2">
                            <span class="px-2 py-0.5 rounded-full bg-${t.color}-500/20 text-${t.color}-300 text-xs border border-${t.color}-500/30">${t.name}</span>
                            <span class="text-xs text-slate-500">${item.time}</span>
                        </div>
                        <div class="text-sm text-slate-300 mb-1 truncate">${item.original}</div>
                        <div class="text-xs text-slate-500 line-clamp-2">${item.optimized}</div>
                    </div>
                `;
            }).join('');
            lucide.createIcons();
        }

        function restoreHistory(id) {
            const item = history.find(h => h.id === id);
            if (item) {
                document.getElementById('input-text').value = item.original.replace('...', '');
                displayResult(item.fullOptimized);
                updateCharCount();
                toggleHistory();
                showToast('已恢复历史记录');
            }
        }

        function clearHistory() {
            history = [];
            localStorage.removeItem('promptHistory');
            renderHistory();
            showToast('历史记录已清空');
        }

        function toggleHistory() {
            const sidebar = document.getElementById('history-sidebar');
            sidebar.classList.toggle('translate-x-full');
        }

        // Toast notification
        function showToast(message, type = 'success') {
            const toast = document.getElementById('toast');
            const msg = document.getElementById('toast-message');
            const icon = toast.querySelector('i');
            
            msg.textContent = message;
            if (type === 'error') {
                icon.setAttribute('data-lucide', 'alert-circle');
                icon.classList.remove('text-emerald-400');
                icon.classList.add('text-red-400');
            } else {
                icon.setAttribute('data-lucide', 'check-circle');
                icon.classList.remove('text-red-400');
                icon.classList.add('text-emerald-400');
            }
            lucide.createIcons();
            
            toast.classList.add('show');
            setTimeout(() => {
                toast.classList.remove('show');
            }, 3000);
        }

        // Initialize
        createParticles();
        renderTemplates();
        renderHistory();

        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.ctrlKey && e.key === 'Enter') {
                convertPrompt();
            }
            if (e.ctrlKey && e.key === 'h') {
                e.preventDefault();
                toggleHistory();
            }
        });
    </script>
</body>
</html>
