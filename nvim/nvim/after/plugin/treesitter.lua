require'nvim-treesitter.configs'.setup {
    ensure_installed = { "rust", "c", "cpp", "lua", "python", "go", "typescript", "javascript", "html", "css", "json", "yaml", "swift" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

