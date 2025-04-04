return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                "gopls",
                "html",
                "rust_analyzer",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ['<Tab>'] = nil,
                ['<S-Tab>'] = nil
            }),
            window = {
                documentation = cmp.config.window.bordered(),
            },
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
            }, {
                { name = 'buffer' },
            })
        })

        local lspconfig = require('lspconfig')
        local util = require("lspconfig.util")

        lspconfig.sourcekit.setup {
            cmd = { '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp' },
            root_dir = function(filename, _)
                return util.root_pattern("buildServer.json")(filename)
                    or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
                    or util.find_git_ancestor(filename)
                    or util.root_pattern("Package.swift")(filename)
            end,
        }

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                --enable omnifunc completion
                --vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                vim.bo[ev.buf].omnifunc = nil

                -- buffer local mappings
                local opts = { buffer = ev.buf }
                -- go to definition
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                --puts doc header info into a float page
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

                -- workspace management. Necessary for multi-module projects
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set('n', '<space>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)

                -- add LSP code actions
                vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)

                -- find references of a type
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            end,
        })
    end
}
