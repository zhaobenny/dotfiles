# Run cctop, installing if needed (stays installed)
cctop() {
    if ! command -v cctop &>/dev/null; then
        echo "Installing cctop..."
        local os arch
        case "$(uname -s)" in
            Linux) os=linux ;; Darwin) os=darwin ;; *) echo "Unsupported OS"; return 1 ;;
        esac
        case "$(uname -m)" in
            x86_64|amd64) arch=amd64 ;; aarch64|arm64) arch=arm64 ;; *) echo "Unsupported arch"; return 1 ;;
        esac
        mkdir -p ~/bin
        curl -fsSL "https://github.com/zhaobenny/cctop/releases/latest/download/cctop-${os}-${arch}" -o ~/bin/cctop && chmod +x ~/bin/cctop
    fi
    command cctop "$@"
}
