# Run ccusage monthly, installing bun temporarily if needed
ccusage() {
    local had_bun=true
    if ! command -v bun &>/dev/null; then
        had_bun=false
        curl -fsSL https://bun.sh/install | bash
        source ~/.bashrc
    fi
    bun x ccusage monthly
    if [[ "$had_bun" == false ]]; then
        rm -rf ~/.bun
    fi
}
