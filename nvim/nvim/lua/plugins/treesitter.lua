return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "vimdoc", "javascript", "typescript", "c", "lua", "rust", "jsdoc", "bash",
                    "swift", "cpp", "go", "python",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                }
            })
        end
    }
}
