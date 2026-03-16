# 📔 Unified Diary System (Agentic Context-Preserving Logger) v5.1

![Version](https://img.shields.io/badge/version-v5.1-blue)
![AI Agent](https://img.shields.io/badge/AI-Agent_Driven-orange)
![Sync](https://img.shields.io/badge/Sync-Notion%20%7C%20Obsidian-lightgrey)

**Unified Diary System** is a fully automated, anti-pollution AI journaling and synchronization workflow designed specifically for multi-project developers and creators. By leveraging Continuous Tool Calling from AI Agents, a single natural language command automatically executes a 4-step pipeline: **Local Project Logging ➔ Global Context Fusion ➔ Cloud Bi-directional Sync ➔ Experience Extraction**, achieving a true "One-Shot" seamless record.

---

## ✨ Core Features

* ⚡ **Agent One-Shot Execution**: Once triggered, the AI completes the entire technical process without interruption, only pausing at the final step to ask for human validation on extracted "lessons learned".
* 🛡️ **Context Firewall**: Strictly separates "Project Local Diaries" from the "Global Master Diary." This fundamentally solves the severe "Context Pollution / Tag Drift" problem where AI hallucinates and mixes up progress between Project A and Project B during daily summaries.
* 🧠 **Automated Lessons Learned**: More than just a timeline of events, the AI proactively extracts "New Rules" or "Optimizations" from the bugs you faced or discoveries you made today, distilling them into your Knowledge Base.
* 🔄 **Seamless Cross-Platform Sync**: Includes built-in scripts to push the final global diary straight to Notion and/or Obsidian with a simple `--sync-only` flag.

---

## 🏗️ The 5-Step Workflow Architecture

When a developer types `:{Write a diary entry using the diary skill}` in *any* project directory, the system strictly executes the following atomic operations:

### Step 1: Local Project Archiving (AI Execution)
1. **Auto-Location**: The AI calls terminal commands (e.g., `pwd`) to identify the current working directory, establishing the "Project Name".
2. **Precision Writing**: It writes today's Git Commits, code changes, and problem solutions in "append mode" exclusively into that project's local directory: `diary/YYYY/MM/YYYY-MM-DD-<Project_Name>.md`.

### Step 1.5: Refresh Project Context (Automation Script)
* **Auto-Execution**: The AI invokes `prepare_context.py` to scan the project's latest directory structure, tech stack, and diary-based action items, generating/updating the `AGENT_CONTEXT.md` at the project root.

### Step 2: Extracting Global & Project Material (Automation Script)
* **Material Fetching**: The AI automatically executes `fetch_diaries.py`, precisely pulling the "just-written local project diary" and today's "Global Diary (if it exists)", printing both to the terminal for the AI to read.

### Step 3: AI Smart Fusion & Global Archiving (AI Execution)
* **Seamless Fusion**: The AI mentally sews the two sources from Step 2 together, writing the combined result into the global diary vault: `.../global_skills/auto-skill/diary/YYYY/MM/YYYY-MM-DD.md`.
* **Strict Zoning**: It uses `### 📁 <Project Name>` tagging to ensure existing project progress is preserved, while new project progress is safely appended—absolutely no overwriting.

### Step 4: Cloud Sync & Experience Extraction (Script + Human)
1. **One-Click Push**: The AI calls `master_diary_sync.py --sync-only` to push the data to Notion/Obsidian.
2. **Human Authorization**: The AI extracts today's `📌 New Rules` or `🔄 Experience Optimizations` and presents them to the developer. Once authorized, these are written to the local Knowledge Base and embedded (e.g., via `qmd embed`).

---

## 📂 Directory Structure

This system adopts a "Distributed Recording, Centralized Management" architecture:

```text
📦 Your Computer Environment
 ┣ 📂 Project A (e.g., auto-video-editor)
 ┃ ┗ 📂 diary/YYYY/MM/
 ┃    ┗ 📜 2026-02-24-auto-video-editor.md  <-- Step 1 writes here (Clean, isolated history)
 ┣ 📂 Project B (e.g., GSS)
 ┃ ┗ 📂 diary/YYYY/MM/
 ┃    ┗ 📜 2026-02-24-GSS.md                
 ┃
 ┗ 📂 Global Skills & Diary Center (This Repo)
    ┣ 📂 scripts/
    ┃  ┣ 📜 fetch_diaries.py                <-- Step 2: Material transporter
    ┃  ┣ 📜 prepare_context.py              <-- Step 1.5: Context refresher
    ┃  ┗ 📜 master_diary_sync.py            <-- Step 4: Notion/Obsidian sync
    ┣ 📂 knowledge-base/                    <-- Step 4: AI extracted lessons
    ┗ 📂 diary/YYYY/MM/
       ┗ 📜 2026-02-24.md                   <-- Step 3: The ultimate fused global log
```

---

## 🚀 How to Use (Usage)

After setting up `.env` with your Notion tokens, simply input the following into your CLI/IDE chat while working inside a project:

```bash
:{Write a diary entry using the diary skill} Today I finished the initial integration of the Google Colab python script and fixed the package version conflicts.
```

The system will take over to handle all the filing, merging, and syncing automatically.

---

## 🛠️ Setup & Prerequisites

1. **Configuration**: Rename `.env.example` to `.env` and fill in your `NOTION_TOKEN`, `NOTION_DIARY_DB`, and set where your global diary root is stored.
2. **Dependencies**: `pip install -r requirements.txt`
3. **AI Agent**: Requires an AI assistant with Function Calling / Continuous Tool Calling capabilities (like Cursor, Claude Code, or Gemini CLI frameworks).

---

> **💡 Design Philosophy:**
> Why not just have the AI write directly to the global diary? Because we found that when an AI lacks the "isolated local project context", it frequently suffers from **Tag Drift** (writing Project A's progress under Project B's header). Through this highly-structured "Local First, Global Second" 4-step architecture, we completely eliminated the context pollution pain point in AI-automated logging.

---

## 📖 User Manual

### 1. Installation & Setup

#### 1.1 Clone the Repository

```bash
git clone https://github.com/Allen930311/Diaryskill.git
cd Diaryskill
```

#### 1.2 Install Python Dependencies

```bash
pip install -r requirements.txt
```

#### 1.3 Environment Variables

Copy the template and fill in your settings:

```bash
cp .env.example .env
```

Edit `.env` with the following:

| Variable | Required | Description |
|----------|----------|-------------|
| `NOTION_TOKEN` | Yes | Notion Internal Integration Token (get it from [Notion Integrations](https://www.notion.so/my-integrations)) |
| `NOTION_DIARY_DB` | Yes | Your Notion Diary Database ID |
| `GLOBAL_DIARY_ROOT` | No | Path to store global diaries (defaults to `diary/` in this repo) |
| `OBSIDIAN_DAILY_NOTES` | No | Obsidian Daily Notes folder path (leave empty to skip Obsidian sync) |
| `DESKTOP_PATH` | No | Desktop path (used for `--inject-only` scan mode) |

#### 1.4 Verify Installation

```powershell
pwsh scripts/verify_setup.ps1
```

This script checks Python, environment variables, dependencies, and paths.

#### 1.5 Create Notion Database (First Time)

If you don't have a diary database in Notion yet:

```bash
python scripts/sync_to_notion.py --create-db <your_notion_parent_page_id>
```

The script will return a new Database ID — add it to `NOTION_DIARY_DB` in your `.env`.

> **Notion Permissions**: Make sure your Integration is added to the target page's "Connections", otherwise the API will return 403.

---

### 2. Using with AI Agents

This system requires an AI Agent with **Continuous Tool Calling** capabilities.

#### 2.1 Install SKILL.md into Your AI Framework

Place `SKILL.en.md` (English) or `SKILL.md` (Chinese) into your AI Agent's skill directory:

| AI Agent | Suggested Path |
|----------|---------------|
| **Gemini CLI (Antigravity)** | `~/.gemini/antigravity/global_skills/diary/SKILL.md` |
| **Claude Code** | Reference in `CLAUDE.md`, or place in `~/.claude/skills/diary/SKILL.md` |
| **Cursor** | Place in `.cursor/rules/` or reference as System Prompt |

#### 2.2 Replace Path Placeholders in SKILL.md

SKILL.md uses the following placeholders that must be replaced with your actual paths:

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{diary_system_path}` | Root directory of this repo | `C:/Users/You/tools/Diaryskill` or `~/tools/Diaryskill` |
| `{knowledge_base_path}` | Knowledge base storage path (optional) | `C:/Users/You/knowledge-base` |

Example replacement:

```
# Before
python {diary_system_path}/scripts/fetch_diaries.py

# After
python ~/tools/Diaryskill/scripts/fetch_diaries.py
```

#### 2.3 Trigger the Diary Workflow

In any project directory, tell your AI Agent:

```
Write a diary entry
```

Or use the high-accuracy trigger format:

```
:{Write a diary entry using the diary skill}
```

The AI will automatically execute the full Step 0 → Step 4 pipeline.

---

### 3. Standalone Script Usage (Without AI)

All Python scripts can also be invoked manually:

#### 3.1 Extract Materials

```bash
python scripts/fetch_diaries.py "/path/to/project/diary/2026/03/2026-03-16-myproject.md"
```

Prints both the "Global Diary" and "Project Diary" materials for manual or AI fusion.

#### 3.2 Sync & Push

```bash
# Push only (Notion + Obsidian)
python scripts/master_diary_sync.py --sync-only

# Scan desktop projects and inject into global diary only
python scripts/master_diary_sync.py --inject-only

# Full pipeline (inject + sync)
python scripts/master_diary_sync.py
```

#### 3.3 Refresh Project Context

```bash
python scripts/prepare_context.py "/path/to/your/project"
```

Generates `AGENT_CONTEXT.md` in the target project directory with 5 sections: Project Goal, Tech Stack, Directory Structure, Architecture Conventions, and Current Status/TODOs.

---

### 4. Notion Database Schema

The sync script automatically manages the following Notion Database properties:

| Property | Type | Description |
|----------|------|-------------|
| `標題` (Title) | Title | Diary title (e.g., `📊 2026-03-16 每日複盤`) |
| `日期` (Date) | Date | Diary date |
| `專案` (Projects) | Multi-select | Project names involved today |
| `標籤` (Tags) | Multi-select | Auto-tags (Business, AI, Video, etc.) |

> **Note**: This script only pushes the "Business" section to Notion. If your Notion diary page has other sections (e.g., Learning, Workout), they will NOT be overwritten.

---

### 5. FAQ

<details>
<summary><b>Q: Notion sync fails with 401 or 403?</b></summary>

- Verify `NOTION_TOKEN` is correct and not expired
- Ensure your Integration is added to the target Database's "Connections"
- Run `pwsh scripts/verify_setup.ps1` to check your environment
</details>

<details>
<summary><b>Q: Can I use only Obsidian without Notion?</b></summary>

Yes. Set the `OBSIDIAN_DAILY_NOTES` environment variable to your Obsidian vault path. Don't set `NOTION_TOKEN` and Notion sync will be skipped automatically — only Obsidian backup will run.
</details>

<details>
<summary><b>Q: Can I use this purely locally without any cloud sync?</b></summary>

Yes. Just use Steps 1-3 (local archiving + global fusion) and skip Step 4's sync. The sync scripts only push when the relevant environment variables are set.
</details>

<details>
<summary><b>Q: What is `{diary_system_path}`?</b></summary>

It's a placeholder in SKILL.md representing the absolute path where you cloned this repository. Replace it manually with your actual path during setup, e.g., `C:/Users/You/tools/Diaryskill` or `~/tools/Diaryskill`.
</details>

<details>
<summary><b>Q: Can I customize the diary templates?</b></summary>

Yes. Edit `templates/local-diary-template.md` and `templates/global-diary-template.md`. The AI Agent references these templates during Steps 1 and 3. You can also modify the template blocks directly in SKILL.md.
</details>

<details>
<summary><b>Q: Which operating systems are supported?</b></summary>

The Python scripts are cross-platform (Windows / macOS / Linux). `verify_setup.ps1` requires PowerShell but is only used for initial verification — it's not required for daily use.
</details>

---

### 6. Advanced: Custom Tag Rules

`sync_to_notion.py` includes automatic tagging logic. You can add your own tag rules in the `tag_keywords` dictionary inside the `extract_metadata()` function:

```python
tag_keywords = {
    "YourTag": ["keyword1", "keyword2"],
    # ...
}
```

When any matching keyword appears in the diary content, the corresponding Notion tag is automatically applied.
