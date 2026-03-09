# 📔 Unified Diary System (全域日記系統) v4.1

![Version](https://img.shields.io/badge/version-v4.1-blue)
![AI Agent](https://img.shields.io/badge/AI-Agent_Driven-orange)
![Sync](https://img.shields.io/badge/Sync-Notion%20%7C%20Obsidian-lightgrey)

**Unified Diary System** 是一個專為多專案開發者設計的「全自動、防污染」AI 寫作與同步工作流。透過 AI Agent 的連續工具調用（Continuous Tool Calling），只需一句指令，系統便會自動完成：**專案本地留檔 ➔ 全域進度融合 ➔ 雲端雙向同步 ➔ 經驗提煉更新**，達成真正的「One-Shot」無縫紀錄。

---

## ✨ 核心特色 (Core Features)

* ⚡ **Agent One-Shot 連續執行**：觸發後 AI 會一口氣執行到底，中間不廢話、不中斷，直到最後一步「經驗提煉」才需要人類把關。
* 🛡️ **Context Firewall (內容防火牆)**：嚴格分離「專案本地日記」與「全域總控日記」，徹底解決 AI 總結時容易發生的專案進度混淆、標籤漂移等污染問題。
* 🧠 **自動經驗提煉 (Lessons Learned)**：不僅紀錄流水帳，AI 還會主動從當日踩過的坑或新發現中，提煉出「新規則」或「優化方案」，自動沉澱到知識庫（Knowledge Base）。
* 🔄 **跨平台無縫同步**：內建腳本支援一鍵 `--sync-only` 將全域進度推送到 Notion 與 Obsidian。

---

## 🏗️ 系統架構與 4 步工作流 (The 5-Step Workflow)

當開發者在任何專案目錄下輸入 `:{使用diary skill幫我寫日記}` 時，系統將嚴格依序執行以下原子操作：

### Step 1: 專案本地留檔 (AI 執行)
1.  **自動定位**：AI 自動調用終端機 (`pwd`) 識別當前工作目錄，確認「專案名稱」。
2.  **精準寫檔**：將當次對話的 Git Commits、程式碼變更與問題解法，以「追加模式」寫入該專案專屬的本地目錄 `diary/YYYY/MM/YYYY-MM-DD-<專案名>.md`。

### Step 1.5: 刷新專案 Context (自動化腳本)
* **自動執行**：AI 呼叫 `prepare_context.py`，掃描專案最新目錄結構、技術棧與日記待辦，生成/更新專案目錄下的 `AGENT_CONTEXT.md`。

### Step 2: 提取全域與專案素材 (自動腳本)
* **素材抓取**：AI 自動執行 `fetch_diaries.py` 腳本，精準調出「剛剛寫入的專案本地日記」與「今日全域日記（若已存在）」兩份素材，印在終端機供 AI 讀取。

### Step 3: AI 智慧融合與全域寫檔 (AI 執行)
* **無痛融合**：AI 在腦內將兩份素材無縫縫合，並寫入全域日記庫 `.../global_skills/auto-skill/diary/YYYY/MM/YYYY-MM-DD.md`。
* **嚴格分區**：採用 `### 📁 <專案名>` 的標籤化管理，舊專案進度保留，新專案進度追加，絕對不覆蓋。

### Step 4: 雲端同步推送與經驗提煉 (腳本 + 人類把關)
1.  **一鍵推送**：AI 調用 `master_diary_sync.py --sync-only` 推送至 Notion/Obsidian。
2.  **人類授權**：AI 提煉出今日的 `📌 新規則` 或 `🔄 經驗優化` 呈報給開發者。獲得授權後，自動寫入知識庫並執行 `qmd embed`（如有安裝）。

---

## 📂 目錄結構 (Directory Structure)

本系統採用「分散式紀錄，集中式管理」的架構：

```text
📦 你的電腦環境
 ┣ 📂 專案A (e.g., auto-video-editor)
 ┃ ┗ 📂 diary/YYYY/MM/
 ┃    ┗ 📜 2026-02-24-auto-video-editor.md  <-- Step 1 寫入這裡 (乾淨無污染)
 ┣ 📂 專案B (e.g., GSS)
 ┃ ┗ 📂 diary/YYYY/MM/
 ┃    ┗ 📜 2026-02-24-GSS.md                
 ┃
 ┗ 📂 全域技能與日誌中心 (本倉庫路徑)
    ┣ 📂 scripts/
    ┃  ┣ 📜 fetch_diaries.py                <-- Step 2 負責搬運素材
    ┃  ┣ 📜 prepare_context.py              <-- Step 1.5 刷新 AGENT_CONTEXT.md
    ┃  ┗ 📜 master_diary_sync.py            <-- Step 4 負責同步 Notion/Obsidian
    ┣ 📂 knowledge-base/                    <-- Step 4 AI 提煉的經驗存放區
    ┗ 📂 diary/YYYY/MM/
       ┗ 📜 2026-02-24.md                   <-- Step 3 最終融合的全域總表
```

---

## 🚀 如何使用 (Usage)

在設定好 `.env` 檔案（包含 Notion Token 等）後，只需在開發對話中輸入：

```bash
:{使用diary skill幫我寫日記} 今天完成了 Google Colab 的 Python 腳本初步串接，修正了套件版本衝突的問題。
```

系統即會接管後續所有建檔、融合與同步動作。

---

## 🛠️ 前置需求 (Prerequisites)

1. **設定環境**：將 `.env.example` 重新命名為 `.env`，並填入 `NOTION_TOKEN`、`NOTION_DIARY_DB` 等關鍵資訊。
2. **安裝依賴**：`pip install -r requirements.txt`
3. **AI Agent**：具備 Function Calling / Continuous Tool Calling 能力的 AI Agent (例如 Cursor, Claude Code, 或 Gemini CLI 框架)。

---

> **💡 關於設計理念：**
> 為什麼不直接讓 AI 寫全域日記？因為我們發現，當 AI 缺乏「本地專案獨佔上下文」時，極易發生**標籤漂移**（把 A 專案的進度寫到 B 專案下）。透過這套「先本地、再全域」的 4 步架構，我們徹底解決了 AI 自動化紀錄的污染痛點。
