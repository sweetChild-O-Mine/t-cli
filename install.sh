#!/usr/bin/env bash
# ==============================================================================
# t-cli Auto Installer
# Installs 't' (and 'todo') for Linux, macOS, and Windows (Git Bash).
# Usage:
#   curl -sSL https://raw.githubusercontent.com/sweetChild-O-Mine/t-cli/main/install.sh | bash
#   or locally: ./install.sh
# ==============================================================================

set -e

# ANSI Color codes
BOLD="\033[1m"
GREEN="\033[32m"
CYAN="\033[36m"
YELLOW="\033[33m"
RED="\033[31m"
GRAY="\033[90m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}"
cat << "BANNER"
  _             _ _ 
 | |_      ___ | (_)
 | __|____/ __|| | |
 | |_|___| (__ | | |
  \__|    \___||_|_|
BANNER
echo -e " Lightning-fast, zero-bloat Todo manager (<1 MB RAM)${RESET}\n"

# 1. Detect Python 3
PYTHON_BIN=""
if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN="python3"
elif command -v python >/dev/null 2>&1; then
    # Verify if 'python' is Python 3
    PY_VER=$(python -c 'import sys; print(sys.version_info[0])' 2>/dev/null || echo "2")
    if [ "$PY_VER" = "3" ]; then
        PYTHON_BIN="python"
    fi
fi

if [ -z "$PYTHON_BIN" ]; then
    echo -e "${RED}Error: Python 3 is required to run t-cli, but was not found in your PATH.${RESET}"
    echo -e "Please install Python 3:"
    echo -e "  • Ubuntu/Debian:  sudo apt install python3"
    echo -e "  • Arch Linux:     sudo pacman -S python"
    echo -e "  • macOS:          brew install python3"
    echo -e "  • Windows:        https://www.python.org/downloads/ (make sure to check 'Add to PATH')"
    exit 1
fi

echo -e " ${GREEN}✔${RESET} Detected Python: $($PYTHON_BIN --version)"

# 2. Determine installation directory
# On Git Bash / MSYS on Windows, ~/bin is standard and automatically in PATH
OS_TYPE="$(uname -s 2>/dev/null || echo "unknown")"
IS_WINDOWS=false

case "$OS_TYPE" in
    MINGW*|MSYS*|CYGWIN*)
        IS_WINDOWS=true
        INSTALL_DIR="$HOME/bin"
        ;;
    *)
        INSTALL_DIR="$HOME/.local/bin"
        ;;
esac

mkdir -p "$INSTALL_DIR"

# 3. Obtain the executable
TARGET="$INSTALL_DIR/t"
REPO_RAW="https://raw.githubusercontent.com/sweetChild-O-Mine/t-cli/main/t"

# If running locally inside repository
if [ -f "$(dirname "$0")/t" ]; then
    echo -e " ${CYAN}➔${RESET} Installing from local repository..."
    cp "$(dirname "$0")/t" "$TARGET"
else
    echo -e " ${CYAN}➔${RESET} Downloading t-cli from GitHub..."
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$REPO_RAW" -o "$TARGET"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$TARGET" "$REPO_RAW"
    else
        echo -e "${RED}Error: curl or wget is required to download t-cli.${RESET}"
        exit 1
    fi
fi

chmod +x "$TARGET"

# 4. Create 'todo' symlink / copy alias
TODO_TARGET="$INSTALL_DIR/todo"
ln -sf "$TARGET" "$TODO_TARGET" 2>/dev/null || cp "$TARGET" "$TODO_TARGET"
chmod +x "$TODO_TARGET" 2>/dev/null || true

# 5. On Windows / Git Bash, also create t.cmd wrapper for CMD / PowerShell support
if [ "$IS_WINDOWS" = true ]; then
    cat << 'WIN_EOF' > "$INSTALL_DIR/t.cmd"
@echo off
python "%~dp0t" %*
WIN_EOF
    cat << 'WIN_EOF' > "$INSTALL_DIR/todo.cmd"
@echo off
python "%~dp0t" %*
WIN_EOF
fi

echo -e " ${GREEN}✔${RESET} Installed ${BOLD}t${RESET} and ${BOLD}todo${RESET} into ${CYAN}$INSTALL_DIR${RESET}"

# 6. Check if INSTALL_DIR is in PATH
PATH_CHECK=false
case ":$PATH:" in
    *":$INSTALL_DIR:"*) PATH_CHECK=true ;;
esac

if [ "$PATH_CHECK" = false ]; then
    echo -e "\n${YELLOW}⚠️  Notice: $INSTALL_DIR is not currently in your \$PATH.${RESET}"
    
    # Detect shell profile
    SHELL_NAME="$(basename "${SHELL:-bash}")"
    case "$SHELL_NAME" in
        zsh)  PROFILE_FILE="$HOME/.zshrc" ;;
        bash) PROFILE_FILE="$HOME/.bashrc" ;;
        *)    PROFILE_FILE="$HOME/.profile" ;;
    esac
    
    echo -e "Add it by running:"
    echo -e "  ${CYAN}echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> $PROFILE_FILE${RESET}"
    echo -e "  ${CYAN}source $PROFILE_FILE${RESET}"
fi

echo -e "\n${GREEN}${BOLD}🎉 Installation Complete!${RESET}"
echo -e "Run ${CYAN}${BOLD}t${RESET} to launch interactive rapid-capture mode."
echo -e "Run ${CYAN}${BOLD}t help${RESET} to view all available commands.\n"
