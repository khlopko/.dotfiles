local lsp = require("lsp-zero")

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = ''
})

vim.diagnostic.config({
    virtual_text = true,
})

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    lsp.default_setup,
  }
})

require('mason-lspconfig').setup({
  handlers = {
    lsp.default_setup,
    lua_ls = function()
      local lua_opts = lsp.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({select = false}),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil
  }),
  window = {
    documentation = cmp.config.window.bordered(),
  }
})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    if vim.lsp.buf.range_code_action then
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.range_code_action, { buffer = 0, desc = "Range code action." })
    else
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, { buffer = 0, desc = "Code action." })
    end
end)

local lspconfig = require('lspconfig')
local util = require("lspconfig.util")

lspconfig.sourcekit.setup{
  cmd = {'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp'},
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
    vim.keymap.set('n','gd',vim.lsp.buf.definition,opts)
    --puts doc header info into a float page
    vim.keymap.set('n','K',vim.lsp.buf.hover,opts)

    -- workspace management. Necessary for multi-module projects
    vim.keymap.set('n','<space>wa',vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n','<space>wr',vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n','<space>wl',function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,opts)

    -- add LSP code actions
    vim.keymap.set({'n','v'},'<space>ca',vim.lsp.buf.code_action,opts)                

    -- find references of a type
    vim.keymap.set('n','gr',vim.lsp.buf.references,opts)
  end,
})

lsp.setup()

