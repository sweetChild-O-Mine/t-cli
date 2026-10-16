<div align="center">

# ⚡ `t-cli`

### Lightning-fast, zero-bloat Todo manager for developers who live in their terminal.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Python: 3.6+](https://img.shields.io/badge/Python-3.6+-3776AB.svg?logo=python&logoColor=white)](https://python.org)
[![RAM Usage: <1 MB](https://img.shields.io/badge/RAM_Usage-%3C1_MB-brightgreen.svg)]()
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-blue.svg)]()

<p>
  <b>0 MB background RAM</b> • <b>0.01s startup time</b> • <b>Plain Markdown storage</b> • <b>Zero dependencies</b>
</p>

</div>

---

## 🌟 Why `t-cli`?

Most task managers are bloated Electron apps consuming 500MB+ of RAM, or complex CLI tools requiring a manual to learn.

`t-cli` is built for pure terminal velocity:
- **🪶 Ultra Lightweight:** Consumes **< 1 MB of RAM** while running and **0 MB** in the background. No daemons, no background servers.
- **⚡ Rapid-Capture Mode:** Run `t`, type your tasks pressing <kbd>Enter</kbd> after each one, and hit <kbd>q</kbd> when finished.
- **📄 Plain Markdown Storage:** Tasks are stored in standard GitHub Markdown checkboxes (`- [ ]`, `- [x]`) inside `~/todo.md`. Open, edit, or sync it anytime with VS Code, Obsidian, Nano, or Git.
- **🌐 Cross-Platform:** Works natively across **Linux**, **macOS**, and **Windows** (Git Bash / Windows Terminal).
- **🛡️ Battle-Tested:** Supports ranges (`1-5`), multi-task operations (`t d 1 2 3`), external markdown edits, and UTF-8 emojis.

---

## 🖥️ Demo Preview

```text
$ t

  📋 TASKS (2 pending, 1 done)
  ─────────────────────────────────────────────
   [✔]  1. Configure tmux mouse
   [ ]  2. Finish React dashboard
   [ ]  3. Drink a glass of water

  ➕ Add task (or d <#>, rm <#>, edit, q to quit):
  ❯ Call client [Enter]
  ✅ Added: Call client
  ❯ 2 [Enter]
  ✔ Updated 1 task(s)!
  ❯ q [Enter]
  👋 All done!
```

---

## 🚀 Installation

### Option 1: Quick Install (1-Liner)

Open your terminal (**Linux**, **macOS**, or **Windows Git Bash**) and run:

```bash
curl -sSL https://raw.githubusercontent.com/sweetChild-O-Mine/t-cli/main/install.sh | bash
```

### Option 2: Clone & Install Manually

```bash
git clone https://github.com/sweetChild-O-Mine/t-cli.git
cd t-cli
chmod +x install.sh
./install.sh
```

> **Note:** The installer automatically makes both **`t`** and **`todo`** available in your terminal.

---

## 🪟 Windows Support (Git Bash / Windows Terminal)

`t-cli` works seamlessly on Windows:
1. Open **Windows Terminal** with **Git Bash** as your shell.
2. Run the 1-liner installation command above.
3. The installer places `t` into `~/bin/t` (which Git Bash automatically includes in your `$PATH`) and sets up a `t.cmd` helper for Command Prompt & PowerShell support.
4. Your tasks will be stored at `C:\Users\<YourUsername>\todo.md`.

---

## 📖 Complete Command Reference

### 1. Interactive "Rapid-Capture" Mode
Run `t` without any arguments to enter the interactive loop:
```bash
t
```
- **Add tasks:** Just type your task and press <kbd>Enter</kbd>. It immediately saves and waits for your next task.
- **Toggle Done:** Type the task number (e.g. `1` or `d 1`) and press <kbd>Enter</kbd>.
- **Uncheck:** Type `u 1` and press <kbd>Enter</kbd>.
- **Delete:** Type `rm 1` (or `del 1`) and press <kbd>Enter</kbd>.
- **Open raw file in editor:** Type `edit` (or `e`).
- **Clear completed:** Type `clear`.
- **Exit:** Type `q`, `exit`, or press <kbd>Enter</kbd> on a blank line.

---

### 2. Direct One-Liners (From Anywhere)

| Command | Description | Example |
| :--- | :--- | :--- |
| `t <text>` | Add a task directly without entering menu | `t Review pull request` |
| `t ls` | List all tasks non-interactively | `t ls` |
| `t d <id...>` | Mark task(s) as completed | `t d 1` |
| `t <id>` | Quick toggle task status | `t 2` |
| `t d 1 2 3` | Mark multiple tasks completed | `t d 1 3 4` |
| `t d 1-3` | Mark a range of tasks completed | `t d 1-4` |
| `t u <id...>` | Uncheck completed task(s) | `t u 1` |
| `t rm <id...>` | Delete task(s) | `t rm 2` |
| `t rm 1-3` | Delete a range of tasks | `t rm 1-3` |
| `t clear` | Delete all completed `[✔]` tasks | `t clear` |
| `t edit` | Open `~/todo.md` in `$EDITOR` (Nano/VS Code/Vim) | `t edit` |
| `t help` | Display built-in help manual | `t help` |

---

## 📂 Where is My Data Stored?

Your tasks live in standard Markdown format inside **`~/todo.md`**:

```markdown
# 📋 Todo List

- [x] Configure tmux mouse
- [ ] Finish React dashboard
- [ ] Drink a glass of water
```

Because it's just a text file:
* You can commit it to a private Git repository.
* You can open it in **VS Code**, **Obsidian**, or **Notepad**.
* You can view it on your phone if you sync your home directory via Syncthing or cloud storage.
* Even if you uninstall `t-cli`, you never lose your data.

---

## 🛠️ Configuration

`t-cli` respects your environment:
* **Default Editor:** Uses `$EDITOR` (e.g. `export EDITOR="nvim"` or `export EDITOR="code"`). If not set, it automatically detects `nano`, `nvim`, `vim`, `code`, or `notepad`.
* **Colors:** Automatically detects terminal color capabilities. If piped into another command (e.g. `t ls | grep "React"`), it automatically strips ANSI formatting.

---

## 📄 License

Distributed under the [MIT License](LICENSE). Feel free to modify, fork, and share!

<div align="center">
  <sub>Created with ❤️ by <a href="https://github.com/sweetChild-O-Mine">sweetChild-O-Mine</a></sub>
</div>
