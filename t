#!/bin/sh
'''':
if command -v python3 >/dev/null 2>&1; then
    exec python3 "$0" "$@"
elif command -v python >/dev/null 2>&1; then
    exec python "$0" "$@"
else
    echo "Error: Python 3 is required to run 't', but neither 'python3' nor 'python' was found in PATH." >&2
    exit 1
fi
'''
"""
t - Minimalist, lightning-fast, zero-bloat Todo manager for the terminal.
Stores tasks in ~/todo.md in standard Markdown checklist format.
Cross-platform: Linux, macOS, and Windows (Git Bash / Windows Terminal).
"""

import sys
import os
import re
import subprocess
from pathlib import Path

# Enable VT100 / ANSI escape sequences on Windows if running in Windows Terminal or cmd
if os.name == 'nt':
    try:
        import ctypes
        kernel32 = ctypes.windll.kernel32
        kernel32.SetConsoleMode(kernel32.GetStdHandle(-11), 7)
    except Exception:
        pass

TODO_FILE = Path.home() / "todo.md"

# ANSI Colors
USE_COLOR = sys.stdout.isatty()
def col(text, code):
    return f"\033[{code}m{text}\033[0m" if USE_COLOR else text

BOLD = "1"
DIM = "2"
RED = "31"
GREEN = "32"
YELLOW = "33"
BLUE = "34"
MAGENTA = "35"
CYAN = "36"
GRAY = "90"

class Task:
    def __init__(self, text, done=False, raw_line=None):
        self.text = text
        self.done = done
        self.raw_line = raw_line

def init_file():
    if not TODO_FILE.exists():
        TODO_FILE.write_text("# 📋 Todo List\n\n", encoding="utf-8")

def load_tasks():
    init_file()
    lines = TODO_FILE.read_text(encoding="utf-8").splitlines()
    tasks = []
    other_lines = []
    
    # Matches: - [ ] Task or - [x] Task or * [ ] Task
    pattern = re.compile(r"^\s*[-*]\s*\[([ xX])\]\s*(.*)$")
    
    for line in lines:
        match = pattern.match(line)
        if match:
            done = match.group(1).lower() == 'x'
            text = match.group(2).strip()
            tasks.append(Task(text, done, line))
        else:
            other_lines.append(line)
            
    return tasks, other_lines

def save_tasks(tasks, other_lines=None):
    init_file()
    if other_lines is None:
        # Keep header if present
        current_lines = TODO_FILE.read_text(encoding="utf-8").splitlines()
        other_lines = [l for l in current_lines if not re.match(r"^\s*[-*]\s*\[([ xX])\]", l)]
        if not other_lines:
            other_lines = ["# 📋 Todo List", ""]

    content = []
    # Add non-task lines (headers, etc.)
    for l in other_lines:
        if l.strip() or content: # avoid leading blanks
            content.append(l)
            
    if content and content[-1].strip():
        content.append("") # Blank line before tasks
        
    for t in tasks:
        mark = "x" if t.done else " "
        content.append(f"- [{mark}] {t.text}")
        
    content.append("") # Trailing newline
    TODO_FILE.write_text("\n".join(content), encoding="utf-8")

def display_tasks(tasks):
    print()
    if not tasks:
        print(f"  {col('✨ All clean! No tasks found.', GREEN)} {col('(Type text below to add one)', GRAY)}")
        print()
        return

    pending_count = sum(1 for t in tasks if not t.done)
    done_count = len(tasks) - pending_count
    
    header = f"  {col('📋 TASKS', BOLD)} {col(f'({pending_count} pending, {done_count} done)', GRAY)}"
    print(header)
    print(f"  {col('─' * 45, GRAY)}")

    for i, t in enumerate(tasks, 1):
        idx_str = f"{i:>2}."
        if t.done:
            status = col("[✔]", GREEN)
            item_text = col(f"\033[9m{t.text}\033[0m", GRAY) # strikethrough if terminal supports it
            print(f"   {status} {col(idx_str, GRAY)} {item_text}")
        else:
            status = col("[ ]", YELLOW)
            print(f"   {status} {col(idx_str, BOLD)} {t.text}")
    print()

def add_task(text, tasks):
    text = text.strip()
    if not text:
        return False
    tasks.append(Task(text, done=False))
    save_tasks(tasks)
    return True

def parse_indices(args, max_len):
    indices = []
    for arg in args:
        # Handle ranges like 1-3 or single numbers
        if "-" in arg:
            parts = arg.split("-")
            if len(parts) == 2 and parts[0].isdigit() and parts[1].isdigit():
                start, end = int(parts[0]), int(parts[1])
                for n in range(min(start, end), max(start, end) + 1):
                    if 1 <= n <= max_len:
                        indices.append(n - 1)
        elif arg.isdigit():
            n = int(arg)
            if 1 <= n <= max_len:
                indices.append(n - 1)
            else:
                print(col(f"  ⚠️  Index #{n} out of range (1-{max_len})", RED))
    return sorted(list(set(indices)))

def toggle_done(indices, tasks, set_to=None):
    changed = 0
    for idx in indices:
        if 0 <= idx < len(tasks):
            if set_to is None:
                tasks[idx].done = not tasks[idx].done
            else:
                tasks[idx].done = set_to
            changed += 1
    if changed:
        save_tasks(tasks)
    return changed

def remove_tasks(indices, tasks):
    # Sort descending so popping doesn't shift earlier indices
    removed = 0
    for idx in sorted(indices, reverse=True):
        if 0 <= idx < len(tasks):
            del tasks[idx]
            removed += 1
    if removed:
        save_tasks(tasks)
    return removed

def clear_completed(tasks):
    before = len(tasks)
    tasks[:] = [t for t in tasks if not t.done]
    cleared = before - len(tasks)
    if cleared > 0:
        save_tasks(tasks)
    return cleared

def open_editor():
    init_file()
    editor = os.environ.get("EDITOR")
    if not editor:
        for candidate in ["nano", "nvim", "vim", "code", "notepad"]:
            if subprocess.run(["which" if os.name != "nt" else "where", candidate], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0:
                editor = candidate
                break
    if editor:
        subprocess.run([editor, str(TODO_FILE)])
    else:
        print(col("  ⚠️ No editor found in $EDITOR. Opening with nano/notepad...", RED))
        default_editor = "notepad" if os.name == "nt" else "nano"
        subprocess.run([default_editor, str(TODO_FILE)])

def print_help():
    help_text = f"""
{col('⚡ t - Minimalist Terminal Todo Manager', BOLD)}

{col('USAGE:', YELLOW)}
  {col('t', BOLD)}                     Enter interactive rapid-entry mode
  {col('t <task text>', BOLD)}        Quick-add a task directly
  {col('t ls', BOLD)}                  List all tasks (non-interactive)
  {col('t d <id...>', BOLD)}           Mark task(s) done (e.g. {col('t d 1', CYAN)} or {col('t d 1 2', CYAN)} or {col('t d 1-3', CYAN)})
  {col('t u <id...>', BOLD)}           Uncheck task(s)
  {col('t rm <id...>', BOLD)}          Delete task(s)
  {col('t clear', BOLD)}               Remove all completed tasks
  {col('t edit', BOLD)}                Open {col('~/todo.md', CYAN)} in editor ({os.environ.get('EDITOR', 'nano')})
  {col('t help', BOLD)}                Show this help guide

{col('INTERACTIVE RAPID-CAPTURE MODE (when running `t`):', YELLOW)}
  • Just type text and hit {col('[Enter]', BOLD)} to add task after task!
  • Type {col('1', CYAN)} or {col('d 1', CYAN)} to toggle/check task #1
  • Type {col('rm 1', RED)} or {col('del 1', RED)} to delete task #1
  • Type {col('edit', MAGENTA)} to open raw file in editor
  • Type {col('clear', YELLOW)} to clear completed tasks
  • Type {col('q', BOLD)} or hit {col('[Enter]', BOLD)} on empty prompt to exit
"""
    print(help_text)

def interactive_loop():
    while True:
        tasks, other_lines = load_tasks()
        display_tasks(tasks)
        
        prompt_str = f"  {col('➕ Add task', BOLD)} {col('(or d <#>, rm <#>, edit, q to quit):', GRAY)}\n  {col('❯', CYAN)} "
        try:
            line = input(prompt_str).strip()
        except (KeyboardInterrupt, EOFError):
            print("\n  👋 Exited.")
            break
            
        if not line or line.lower() in ["q", "quit", "exit", ":q"]:
            print(f"  {col('👋 All done!', GREEN)}")
            break
            
        parts = line.split()
        cmd = parts[0].lower()
        args = parts[1:]
        
        # Check if user entered bare numbers (e.g. "1" or "1 2" to toggle done)
        if all(p.isdigit() or ("-" in p and p.replace("-","").isdigit()) for p in parts):
            indices = parse_indices(parts, len(tasks))
            toggled = toggle_done(indices, tasks)
            if toggled:
                print(col(f"  ✔ Updated {toggled} task(s)!", GREEN))
            continue
            
        if cmd in ["d", "done", "check", "x"]:
            if not args:
                print(col("  ⚠️ Specify task number(s) to check (e.g. d 1)", YELLOW))
            else:
                indices = parse_indices(args, len(tasks))
                toggled = toggle_done(indices, tasks, set_to=True)
                if toggled:
                    print(col(f"  ✔ Marked {toggled} task(s) as done!", GREEN))
            continue
            
        if cmd in ["u", "undone", "uncheck"]:
            if not args:
                print(col("  ⚠️ Specify task number(s) to uncheck (e.g. u 1)", YELLOW))
            else:
                indices = parse_indices(args, len(tasks))
                toggled = toggle_done(indices, tasks, set_to=False)
                if toggled:
                    print(col(f"  ↺ Unchecked {toggled} task(s)!", CYAN))
            continue
            
        if cmd in ["rm", "del", "delete", "remove"]:
            if not args:
                print(col("  ⚠️ Specify task number(s) to remove (e.g. rm 1)", YELLOW))
            else:
                indices = parse_indices(args, len(tasks))
                removed = remove_tasks(indices, tasks)
                if removed:
                    print(col(f"  🗑 Removed {removed} task(s)!", RED))
            continue
            
        if cmd in ["edit", "e"]:
            open_editor()
            continue
            
        if cmd in ["clear", "clean"]:
            cleared = clear_completed(tasks)
            if cleared:
                print(col(f"  🧹 Cleared {cleared} completed task(s)!", GREEN))
            else:
                print(col("  ℹ️ No completed tasks to clear.", GRAY))
            continue
            
        if cmd in ["help", "?"]:
            print_help()
            try:
                input(col("\n  Press [Enter] to return to tasks...", GRAY))
            except (KeyboardInterrupt, EOFError):
                break
            continue
            
        # Otherwise, treat the entire line as a new task!
        add_task(line, tasks)
        print(col(f"  ✅ Added: {line}", GREEN))

def main():
    args = sys.argv[1:]
    
    # No args -> Launch interactive rapid capture loop
    if not args:
        interactive_loop()
        return
        
    cmd = args[0].lower()
    cmd_args = args[1:]
    tasks, other_lines = load_tasks()
    
    if cmd in ["-h", "--help", "help"]:
        print_help()
        return
        
    if cmd in ["ls", "list", "show"]:
        display_tasks(tasks)
        return
        
    if cmd in ["d", "done", "check", "x"]:
        if not cmd_args:
            print(col("⚠️  Specify task number(s) to check (e.g. t d 1)", RED))
            sys.exit(1)
        indices = parse_indices(cmd_args, len(tasks))
        count = toggle_done(indices, tasks, set_to=True)
        print(col(f"✔ Marked {count} task(s) as completed!", GREEN))
        return
        
    if cmd in ["u", "undone", "uncheck"]:
        if not cmd_args:
            print(col("⚠️  Specify task number(s) to uncheck (e.g. t u 1)", RED))
            sys.exit(1)
        indices = parse_indices(cmd_args, len(tasks))
        count = toggle_done(indices, tasks, set_to=False)
        print(col(f"↺ Unchecked {count} task(s)!", CYAN))
        return
        
    if cmd in ["rm", "del", "delete", "remove"]:
        if not cmd_args:
            print(col("⚠️  Specify task number(s) to delete (e.g. t rm 1)", RED))
            sys.exit(1)
        indices = parse_indices(cmd_args, len(tasks))
        count = remove_tasks(indices, tasks)
        print(col(f"🗑 Removed {count} task(s)!", RED))
        return
        
    if cmd in ["edit", "e"]:
        open_editor()
        return
        
    if cmd in ["clear", "clean"]:
        count = clear_completed(tasks)
        print(col(f"🧹 Cleared {count} completed task(s)!", GREEN))
        return
        
    # If the first argument is a number, toggle done directly! (e.g. "t 1")
    if cmd.isdigit() and not cmd_args:
        indices = parse_indices([cmd], len(tasks))
        toggle_done(indices, tasks)
        status = "completed" if tasks[indices[0]].done else "uncompleted"
        print(col(f"✔ Task #{cmd} marked as {status}!", GREEN))
        return

    # Otherwise, the arguments are a new task to add!
    task_text = " ".join(args).strip()
    if add_task(task_text, tasks):
        remaining = sum(1 for t in tasks if not t.done)
        print(f"{col('✅ Added:', GREEN)} {task_text} {col(f'({remaining} pending)', GRAY)}")

if __name__ == "__main__":
    main()
