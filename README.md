# 📔 Unified Diary System (全域日記系統) v5.1

![Version](https://img.shields.io/badge/version-v5.1-blue)
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

---

## 📖 使用手冊 (User Manual)

### 1. 安裝與設定

#### 1.1 下載專案

```bash
git clone https://github.com/Allen930311/Diaryskill.git
cd Diaryskill
```

#### 1.2 安裝 Python 依賴

```bash
pip install -r requirements.txt
```

#### 1.3 環境變數設定

複製範本並填入你的設定：

```bash
cp .env.example .env
```

編輯 `.env`，填入以下必要欄位：

| 變數名稱 | 必要 | 說明 |
|----------|------|------|
| `NOTION_TOKEN` | 是 | Notion Internal Integration Token（從 [Notion Integrations](https://www.notion.so/my-integrations) 取得） |
| `NOTION_DIARY_DB` | 是 | 你的 Notion 日記 Database ID |
| `GLOBAL_DIARY_ROOT` | 否 | 全域日記存放路徑（預設為本倉庫的 `diary/` 資料夾） |
| `OBSIDIAN_DAILY_NOTES` | 否 | Obsidian Daily Notes 資料夾路徑（留空則跳過 Obsidian 同步） |
| `DESKTOP_PATH` | 否 | 桌面路徑（用於 `--inject-only` 掃描模式） |

#### 1.4 驗證安裝

```powershell
pwsh scripts/verify_setup.ps1
```

此腳本會自動檢查 Python、環境變數、依賴套件與路徑是否正確。

#### 1.5 建立 Notion Database（首次使用）

如果你還沒有日記用的 Notion Database，可用腳本自動建立：

```bash
python scripts/sync_to_notion.py --create-db <你的Notion父頁面ID>
```

腳本會回傳新建的 Database ID，將其填入 `.env` 的 `NOTION_DIARY_DB`。

> **Notion 權限提醒**：請確認你的 Integration 已被加入目標頁面的「連結」（Connections）中，否則 API 會回傳 403。

---

### 2. 在 AI Agent 中使用

本系統需要搭配具備 **Continuous Tool Calling** 能力的 AI Agent 使用。

#### 2.1 安裝 SKILL.md 到你的 AI 框架

將 `SKILL.md`（中文版）或 `SKILL.en.md`（英文版）放入你的 AI Agent 的技能目錄：

| AI Agent | 建議放置路徑 |
|----------|-------------|
| **Gemini CLI (Antigravity)** | `~/.gemini/antigravity/global_skills/diary/SKILL.md` |
| **Claude Code** | 在 `CLAUDE.md` 中引用，或放入 `~/.claude/skills/diary/SKILL.md` |
| **Cursor** | 放入 `.cursor/rules/` 或作為 System Prompt 引用 |

#### 2.2 替換 SKILL.md 中的路徑佔位符

SKILL.md 使用以下佔位符，需替換為你的實際路徑：

| 佔位符 | 說明 | 範例 |
|--------|------|------|
| `{diary_system_path}` | 本倉庫的根目錄路徑 | `C:/Users/You/tools/Diaryskill` 或 `~/tools/Diaryskill` |
| `{knowledge_base_path}` | 知識庫存放路徑（可選） | `C:/Users/You/knowledge-base` |

替換範例（以 Linux/Mac 為例）：

```
# 替換前
python {diary_system_path}/scripts/fetch_diaries.py

# 替換後
python ~/tools/Diaryskill/scripts/fetch_diaries.py
```

#### 2.3 觸發日記流程

在任何專案目錄下，對 AI Agent 說：

```
幫我寫日記
```

或使用高觸發準確率的格式：

```
:{使用diary skill幫我寫日記}
```

AI 會自動執行 Step 0 → Step 4 的完整流程。

---

### 3. 腳本獨立使用（不透過 AI）

所有 Python 腳本也支援手動調用：

#### 3.1 提取素材

```bash
python scripts/fetch_diaries.py "/path/to/project/diary/2026/03/2026-03-16-myproject.md"
```

印出「全域日記」與「專案日記」兩份素材，供手動或 AI 融合。

#### 3.2 同步推送

```bash
# 僅推送（Notion + Obsidian）
python scripts/master_diary_sync.py --sync-only

# 僅掃描桌面專案並注入全域日記
python scripts/master_diary_sync.py --inject-only

# 完整流程（注入 + 同步）
python scripts/master_diary_sync.py
```

#### 3.3 刷新專案 Context

```bash
python scripts/prepare_context.py "/path/to/your/project"
```

會在目標專案目錄下生成 `AGENT_CONTEXT.md`，包含 5 大區塊：專案目標、技術棧、目錄結構、架構約定、進度待辦。

---

### 4. Notion Database 欄位結構

同步腳本會自動管理以下 Notion Database 欄位：

| 欄位名稱 | 類型 | 說明 |
|----------|------|------|
| `標題` | Title | 日記標題（如 `📊 2026-03-16 每日複盤`） |
| `日期` | Date | 日記日期 |
| `專案` | Multi-select | 當日涉及的專案名稱 |
| `標籤` | Multi-select | 自動標籤（Business、AI、影片 等） |

> **注意**：本腳本僅推送「Business」區塊到 Notion。如果你的 Notion 日記頁面有其他區塊（如 Learning、Workout），它們不會被覆蓋。

---

### 5. 常見問題 (FAQ)

<details>
<summary><b>Q: Notion 同步失敗，回傳 401 或 403？</b></summary>

- 確認 `NOTION_TOKEN` 正確且未過期
- 確認你的 Integration 已加入目標 Database 的「Connections」
- 執行 `pwsh scripts/verify_setup.ps1` 檢查環境
</details>

<details>
<summary><b>Q: 不用 Notion，只想用 Obsidian 可以嗎？</b></summary>

可以。設定 `OBSIDIAN_DAILY_NOTES` 環境變數指向你的 Obsidian vault 路徑，不設定 `NOTION_TOKEN` 即可。同步時 Notion 會自動跳過，只備份到 Obsidian。
</details>

<details>
<summary><b>Q: 不用任何雲端同步，純本地可以嗎？</b></summary>

可以。只使用 Step 1 → Step 3（本地留檔 + 全域融合），跳過 Step 4 的同步即可。SKILL.md 的 Step 4 只有在有環境變數時才會實際推送。
</details>

<details>
<summary><b>Q: `{diary_system_path}` 是什麼？</b></summary>

這是 SKILL.md 中的佔位符，代表你放置本倉庫的絕對路徑。安裝時請手動替換為你的實際路徑，例如 `C:/Users/You/tools/Diaryskill` 或 `~/tools/Diaryskill`。
</details>

<details>
<summary><b>Q: 我可以自訂日記模板嗎？</b></summary>

可以。編輯 `templates/local-diary-template.md` 和 `templates/global-diary-template.md`，AI Agent 在 Step 1 和 Step 3 會參照這些模板。你也可以直接在 SKILL.md 的模板區塊中修改。
</details>

<details>
<summary><b>Q: 支援哪些作業系統？</b></summary>

Python 腳本跨平台可用（Windows / macOS / Linux）。`verify_setup.ps1` 需要 PowerShell，但僅用於初始檢查，非必要。
</details>

---

### 6. 進階：自訂標籤規則

`sync_to_notion.py` 內建自動標籤邏輯，你可以在 `extract_metadata()` 函數中的 `tag_keywords` 字典新增自己的標籤規則：

```python
tag_keywords = {
    "你的標籤": ["關鍵詞1", "關鍵詞2"],
    # ...
}
```

日記內容中出現任何匹配關鍵詞，就會自動加上對應的 Notion 標籤。
