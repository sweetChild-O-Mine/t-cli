<div align="center">

# t-cli

**A minimalist, local-first todo manager for your terminal.**

[![License: MIT](https://img.shields.io/badge/License-MIT-gray.svg?style=flat-square)](LICENSE)
[![Python: 3.6+](https://img.shields.io/badge/Python-3.6+-blue.svg?style=flat-square)](https://python.org)
[![Storage: Plain Markdown](https://img.shields.io/badge/Storage-Local_Markdown-success.svg?style=flat-square)]()
[![Platform: Cross-Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgray.svg?style=flat-square)]()

<p>
  Zero accounts &bull; 100% offline &bull; Plain Markdown &bull; No background daemons
</p>

</div>

---

## Overview

Most task managers force you to create an account, verify an email, open a browser tab, or run background processes for something as simple as a task checklist.

`t-cli` is built for immediate terminal productivity:

* **100% Local & Private:** No sign-up, no login, no telemetry, and no cloud subscriptions. Your tasks are stored directly on your machine in `~/todo.md`.
* **Rapid Capture Mode:** Launch with `t`, enter tasks continuously by pressing <kbd>Enter</kbd>, and exit with <kbd>q</kbd>.
* **Standard Markdown:** Tasks are stored using standard GitHub checklist syntax (`- [ ]` and `- [x]`). You can edit the file anytime with VS Code, Nano, Vim, or any text editor.
* **Lightweight:** Written in pure Python standard library with zero external dependencies. Consumes <1 MB of memory when active and 0 MB when closed.
* **Cross-Platform:** Runs natively on Linux, macOS, and Windows (Windows Terminal & Git Bash).

---

## Terminal Preview

```text
$ t

  TASKS (2 pending, 1 done)
  ─────────────────────────────────────────────
   [✔]  1. Configure tmux mouse
   [ ]  2. Finish React dashboard
   [ ]  3. Drink a glass of water

  Add task (or d <#>, rm <#>, edit, q to quit):
  ❯ Call client
  Added: Call client
  ❯ 2
  Updated 1 task(s)!
  ❯ q
  All done!
```

---

## Installation

### Quick Install (One-Liner)

Open your terminal (**Linux**, **macOS**, or **Windows Git Bash**) and run:

```bash
curl -sSL https://raw.githubusercontent.com/sweetChild-O-Mine/t-cli/main/install.sh | bash
```

### Manual Installation

```bash
git clone https://github.com/sweetChild-O-Mine/t-cli.git
cd t-cli
chmod +x install.sh
./install.sh
```

Both `t` and `todo` commands will be available in your terminal path.

---

## Windows Support (Git Bash / Windows Terminal)

`t-cli` works out of the box on Windows:
1. Open **Windows Terminal** running **Git Bash**.
2. Run the one-line install command above.
3. The installer places the script in `~/bin/t` (automatically indexed in Git Bash `$PATH`) and sets up a `t.cmd` wrapper for Command Prompt and PowerShell.
4. Your tasks are stored locally at `C:\Users\<YourUsername>\todo.md`.

---

## Command Reference

### Interactive Mode
Run `t` with no arguments to enter continuous capture mode:

```bash
t
```

* **Add tasks:** Type your text and press <kbd>Enter</kbd>. It saves instantly and prompts for the next item.
* **Check/Uncheck:** Type the task number (e.g. `1` or `d 1`) and press <kbd>Enter</kbd>.
* **Delete:** Type `rm 1` or `del 1`.
* **Edit raw file:** Type `edit` or `e` to open `~/todo.md` in your text editor.
* **Clear completed:** Type `clear` to prune all checked tasks.
* **Exit:** Type `q`, `exit`, or press <kbd>Enter</kbd> on a blank line.

---

### Non-Interactive One-Liners

| Command | Action | Example |
| :--- | :--- | :--- |
| `t <text>` | Add a task directly | `t Review pull request` |
| `t ls` | Print all tasks without entering interactive mode | `t ls` |
| `t d <id...>` | Mark task(s) as completed | `t d 1` |
| `t <id>` | Quick toggle task status | `t 2` |
| `t d 1 2 3` | Mark multiple tasks completed | `t d 1 3 4` |
| `t d 1-3` | Mark a range of tasks completed | `t d 1-4` |
| `t u <id...>` | Mark task(s) as incomplete | `t u 1` |
| `t rm <id...>` | Delete task(s) | `t rm 2` |
| `t rm 1-3` | Delete a range of tasks | `t rm 1-3` |
| `t clear` | Remove all completed tasks | `t clear` |
| `t edit` | Open `~/todo.md` in `$EDITOR` | `t edit` |
| `t help` | Display built-in command summary | `t help` |

---

## Storage Format

Tasks are stored in plain text at `~/todo.md`:

```markdown
# Todo List

- [x] Configure tmux mouse
- [ ] Finish React dashboard
- [ ] Drink a glass of water
```

Because it uses standard Markdown:
* You own your data. There are no proprietary databases or locked formats.
* You can version-control your tasks with Git.
* You can open, preview, or edit it directly inside VS Code, Obsidian, or mobile viewers.

---

## Configuration

* **Editor:** Opens your `$EDITOR` environment variable (e.g. `nvim`, `code`, `nano`). If unset, it automatically detects an installed text editor.
* **Piping:** When output is piped to another utility (e.g. `t ls | grep "React"`), ANSI color escape codes are automatically stripped.

---

## License

Distributed under the [MIT License](LICENSE).
