-- Notes
-- * '..' is used for string concatenation: 'a' .. 'b' -> 'ab'
--
-- Requirements:
-- for opensuse:
-- `zypper in -t pattern build_basis` -- for Treesitter
-- `zypper in npm`                    -- for lsp
-- ag-silversearcher                  -- for Ack
--
--  Index
--  Packages
--  options
--  keymap
--  CMP
--  LSP

-- border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
--
-- Today I learned:
-- Delete till excluding LETTER: dtLETTER
-- Delete till including LETTER (mnemonic: find): dfLETTER
-- =====
-- Packages
-- =====
-- install packer
-- Use a protected call so we don't error out on first use
--
local packer_is_there, packer = pcall(require, "packer")

if not packer_is_there then
    print('We need packer')
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        print('Getting packer')
        print('Install path ' .. install_path)
        vim.fn.system({
            'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
        })

        vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath

        vim.cmd.packadd('packer.nvim')
    end
else
    -- Have packer use a popup window
    packer.init { display = { open_fn = function() return require("packer.util").float { border = "rounded" } end, }, }
end
-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' -- Packer can manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
    use 'kyazdani42/nvim-web-devicons' -- optional, for file icons
    use 'folke/trouble.nvim' -- pretty diagnostics

    -- colors
    -- ======
    use 'cocopon/iceberg.vim'
    -- use {'arrow2nd/iceberg.vim', branch='fix-treesitter'}
    use "lunarvim/darkplus.nvim"
    use "sainnhe/gruvbox-material"
    use "sainnhe/everforest"
    use "catppuccin/nvim"
    use "folke/tokyonight.nvim"
    use "rebelot/kanagawa.nvim"
    use 'fxn/vim-monochrome'
    use 'projekt0n/github-nvim-theme'
    use 'rose-pine/neovim'
    use 'rockerBOO/boo-colorscheme-nvim'
    use 'whatyouhide/vim-gotham'

    use 'tpope/vim-fugitive' -- Git commands in nvim
    use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
    use 'lewis6991/gitsigns.nvim' -- Add git related info in the signs columns and popups

    -- quality of life
    use "machakann/vim-sandwich" -- modify {}, (), etc
    use 'famiu/bufdelete.nvim' -- just fixes buffer delete - keep window open
    use 'preservim/nerdcommenter' -- easy commenting
    use('lukas-reineke/' ..
        'indent-blankline.nvim') -- Add indentation guides even on blank lines
    use 'kyazdani42/nvim-tree.lua' -- tree file browsers
    use { 'akinsho/bufferline.nvim', -- show tabs at top
        tag = "v2.*",
        requires = 'kyazdani42/nvim-web-devicons' }
    use 'mileszs/ack.vim'
    use "folke/which-key.nvim" -- show me key bindings

    -- Treesitter  Highlight, edit, and navigate code
    use { "nvim-treesitter/nvim-treesitter" }

    -- Autocompletion
    use 'hrsh7th/nvim-cmp' -- base plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "hrsh7th/cmp-nvim-lsp" -- language server completion
    use "hrsh7th/cmp-nvim-lua" -- internal nvim-lua completion

    use "L3MON4D3/LuaSnip" -- needed for cmp snippet engine
    use "ray-x/lsp_signature.nvim" -- show signature while typoing

    -- LSP - language server protocol
    use 'williamboman/mason.nvim' -- Automatically/easy install language servers to stdpath
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig' -- base plugin
    use 'jose-elias-alvarez/null-ls.nvim'
    use "jayp0521/mason-null-ls.nvim" -- easy instal for null-ls packages


    -- Telescope
    use { "nvim-telescope/telescope.nvim",
        requires = { { "nvim-telescope/telescope-live-grep-args.nvim" }, },
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make', cond = vim.fn.executable "make" == 1 }

    -- ====
    -- Language specific
    -- ====
    -- MARKDOWN
    use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install",
        setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
    use 'godlygeek/tabular'
    use 'preservim/vim-markdown'
    use 'ferrine/md-img-paste.vim'

    use 'vim-test/vim-test'

    use 'nvim-lualine/lualine.nvim'
    if not packer_is_there then
        print('First ever sync')
        require('packer').sync()
    end

end)

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile>|PackerCompile',
    group = packer_group,
    pattern = vim.fn.expand '$MYVIMRC',
})

-- =====
-- options
-- =====
vim.opt.hlsearch = true -- Set highlight on search
--vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = 'a' -- Enable mouse mode
vim.opt.breakindent = true -- wrapped lines will have same indentation
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smartcase = true
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 500 -- Decrease update time
vim.opt.signcolumn = 'yes' -- extra space for symbols next to numbers
vim.opt.showmatch = true -- shortly jump to [{( partner on insert

--vim.opt.completeopt = 'menu,menuone,noselect' -- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,longest' -- Set completeopt to have a better completion experience
vim.opt.cmdheight = 2 -- more space in command line
vim.opt.wildmode = 'longest:full,full'

vim.opt.fileencoding = "utf-8"

vim.opt.pumheight = 15 -- pop up menu height
vim.opt.showmode = false -- show stuff like INSERT; don't use since we have lualine
vim.opt.showtabline = 0
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.cursorline = true
vim.opt.colorcolumn = '88,89,90' -- indicate text width
vim.opt.scrolloff = 4 -- keep lines above/below
vim.opt.sidescrolloff = 4

vim.opt.termguicolors = true
vim.opt.winblend = 15 -- pseudo transperancy: 0 nothing - 100 transparaent

-- colors
vim.g.tokyonight_style = 'night'
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_diagnostic_text_highlight = 0
vim.g.gruvbox_material_foreground = 'material'

vim.cmd [[set bg=dark]]
local is_there, kanagawa = pcall(require, 'kanagawa')
if is_there then
    kanagawa.setup()
    vim.cmd.colorscheme("kanagawa")
end
-- vim.cmd [[colorscheme iceberg]]
-- vim.cmd [[colorscheme gruvbox-material]]

vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4 --tab counts as this many characters
vim.opt.shiftwidth = 4 --how much to indent by defaul
vim.opt.expandtab = true -- all tabs are replaces by spaces

-- ===== Filetype
-- Markdown
vim.cmd([[ autocmd FileType markdown set conceallevel=2]])
--autocmd FileType markdown nmap <buffer><silent> <leader>i :call mdip#MarkdownClipboardImage()<CR>

-- ======
-- Mappings
-- ======
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
-- set up leader to SPACE
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
-- todo: check - function unknown
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<C-n>", ":NvimTreeToggle<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<leader>n", ":bnext<CR>", { desc = 'next buffer' })
keymap("n", "<leader>p", ":bprevious<CR>", { desc = 'prev buffer' })
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { desc = 'vsplit' })
vim.keymap.set('n', '<leader>h', ':split<CR>', { desc = 'hsplit' })
vim.keymap.set('n', '<leader>q', ':Bdelete<CR>', { desc = 'hsplit' })

-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'diagnostic next' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'diagnostic next' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = 'diagnostic next' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = 'diagnostic prev issue' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'diagnostic list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

-- special
--
-- remove all leading and trailing whitespace: I love it
vim.keymap.set('n', '<leader>w', ':%s/\\s\\+$//<cr>:let @/=""<CR>', { desc = 'Clear line end space' })
-- way better * behaviour !!
-- yank word under cursor, do not jump
vim.keymap.set('n', '*', '"syiw<Esc>: let @/ = @s<CR>')
-- "s              - select register s
-- yiw             - yank inner word
-- <Esc>:          - switch to command mode
-- let @/ = @s<CR> - set search register / with the content of register s


-- ============
-- Plugins
-- ============

-- Comment
-- -----
-- toggle comment normal or visual mode with:
-- ctrl+/ (two keys no shift on US keyboard)
vim.keymap.set({ 'n', 'v' }, '<C-_>', ':call nerdcommenter#Comment(0,"toggle")<CR>')
vim.g.NERDSpaceDelims = true -- add space after comment symbol
vim.g.NERDCreateDefaultMappings = false


-- indent_blankline
-- ======
-- Show very nice lines for indentation level

local is_there, indent_blankline = pcall(require, "indent_blankline")
if is_there then
    indent_blankline.setup { indent_blankline_enabled = false, }
end
keymap('n', '<leader>i', ':IndentBlanklineToggle<CR>', opts)

-- ======
-- gitsigns
-- ======
local is_there, gitsigns = pcall(require, 'gitsigns')
if is_there then
    gitsigns.setup {
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = true, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = true, -- Toggle with `:Gitsigns toggle_word_diff`

        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, { expr = true })

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, { expr = true })

            -- Actions
            map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
            map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
            map('n', '<leader>hS', gs.stage_buffer)
            map('n', '<leader>hu', gs.undo_stage_hunk)
            map('n', '<leader>hR', gs.reset_buffer)
            map('n', '<leader>hp', gs.preview_hunk)
            map('n', '<leader>hb', function() gs.blame_line { full = true } end)
            map('n', '<leader>tb', gs.toggle_current_line_blame)
            map('n', '<leader>hd', gs.diffthis)
            map('n', '<leader>hD', function() gs.diffthis('~') end)
            map('n', '<leader>td', gs.toggle_deleted)

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end

    }
end

-- ======
-- CMP
-- ======
local is_there, cmp = pcall(require, "cmp")

if is_there then
    local cmpm = cmp.mapping

    cmp.setup {
        window = { documentation = cmp.config.window.bordered() },
        sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "buffer" },
            { name = "path" },
        },
        mapping = {
            ["<C-b>"] = cmpm.scroll_docs(-2),
            ["<C-f>"] = cmpm.scroll_docs(2),
            ["<C-Space>"] = cmpm.complete(),
            ["<C-e>"] = cmpm { i = cmpm.abort(), c = cmpm.close() },
            ["<C-c>"] = cmpm { i = cmpm.abort(), c = cmpm.close() },
            ["<CR>"] = cmp.mapping.confirm { select = true },
            ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
            ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        },
        -- how the completion menu looks (can be removed)
        formatting = {
            fields = { "abbr", "kind", "menu" },
            format = function(entry, vim_item)
                vim_item.menu = ({
                    nvim_lsp = "[lsp]",
                    nvim_lua = "[nvim_lua]",
                    luasnip = "[snippet]",
                    buffer = "[Buf]",
                    path = "[path]",
                })[entry.source.name]
                return vim_item
            end,
        },
    }
    cmp.setup.cmdline(':', {
        mapping = cmpm.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' },
            { name = 'cmdline' }
        })
    })

    cmp.setup.cmdline('/', {
        mapping = cmpm.preset.cmdline(),
        sources = { { name = 'buffer' } }
    })

end
-- =====
-- LSP
-- =====
local mason_is_there, mason = pcall(require, "mason")
if mason_is_there then
    mason.setup()
    require("mason-lspconfig").setup({
        ensure_installed = { 'pyright', 'marksman', 'bashls', 'sumneko_lua' }
    })
end
local lspconfig_is_there, lspconfig = pcall(require, "lspconfig")

local signs_diagnostic = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(signs_diagnostic) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end
vim.diagnostic.config({
    virtual_text = false,
    signs = { active = signs_diagnostic },
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = "none", -- seems currently broken try with 'single'
        source = "always",
        scope = 'line',
        -- header = "",  -- don't show 'Diagnostics' header
        -- prefix = "",  -- don't show numbers at beginning
    },
})

-- Set autocommands conditional on server_capabilities
local function lsp_highlight_document(client)
    if client.server_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
  augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  augroup END
]]           ,
            false
        )
    end
end

local keymap_buf = vim.api.nvim_buf_set_keymap
local function lsp_keymaps(bufnr)
    local options_lsp = { noremap = true, silent = true }
    keymap_buf(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", options_lsp)
    keymap_buf(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", options_lsp)
    keymap_buf(bufnr, "n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = 'Rename' })
    keymap_buf(bufnr, "i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", options_lsp)
    keymap_buf(bufnr, "n", "<leader>f", "<cmd>lua vim.lsp.buf.format({async= true})<CR>", { desc = 'Format buffer' })
    keymap_buf(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", options_lsp)
    keymap_buf(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", options_lsp)
    keymap_buf(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", options_lsp)
    keymap_buf(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", options_lsp)
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatformat({async= true})' ]])
end

local on_attach = function(client, bufnr)
    if client.name == "tsserver" then
        client.server_capabilities.document_formatting = false
    end
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
    require "lsp_signature".on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        hint_enable = false,
        handler_opts = {
            border = "rounded"
        }
    }, bufnr)
end

if lspconfig_is_there then
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

    require('mason-lspconfig').setup_handlers({
        function(server_name)
            local settings = nil
            -- this is used to make linting of lua.init work correctly
            if server_name == 'sumneko_lua' then
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                            },
                        },
                    },
                }
            end
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = settings,
            })
        end,
    })
end

-- =====
-- NULL-LS
-- =====
local nullls_is_there, nullls = pcall(require, 'null-ls')
if nullls_is_there then
    -- local prettier = require("prettier")
    -- see: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    local formatting = nullls.builtins.formatting
    -- see: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    local diagnostics = nullls.builtins.diagnostics

    nullls.setup({ sources = {
        -- pyhhon
        formatting.black,
        formatting.isort,
        formatting.prettier,
        -- diagnostics.pylint,
        diagnostics.flake8,

        -- shell
        formatting.shfmt,
        diagnostics.shellcheck,
    } })

    require("mason-null-ls").setup(
        {
            automatic_installation = true,
        }
    )
end

-- Treesitter
-- =====
local ts_is_there, treesitter = pcall(require, 'nvim-treesitter.configs')
if ts_is_there then
    treesitter.setup {
        ensure_installed = { 'lua', 'python', 'markdown', 'bash', 'html', 'javascript', 'vim', 'help' },
        sync_install = true,
        highlight = { enable = true,
            -- additional_vim_regex_highlighting = { "python" },
            disable = { 'markdown' }
        },
        indent = { enable = true },
    }
end

--Telescope
-- ======
local is_there, telescope = pcall(require, "telescope")
-- telescope.config =  telescope.load_extension("live_grep_args")
if is_there then
    pcall(require('telescope').load_extension, 'fzf')
    local actions = require "telescope.actions"
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup {
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            path_display = { "smart" },

            mappings = {
                i = {
                    ["<C-c>"] = actions.close,
                    ["<leader>c"] = require('telescope.actions').close,
                    ["<esc>"] = require('telescope.actions').close, -- you might want to change this, prevents normal mode
                    ["<leader><leader>"] = require('telescope.actions').close, -- you might want to change this, prevents normal mode

                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,

                    ["<C-h>"] = actions.select_horizontal, --open in horizontal split
                    ["<C-v>"] = actions.select_vertical, -- open in veritcal split

                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<C-l>"] = actions.complete_tag,
                    ["<C-/>"] = actions.which_key, -- keys from pressing <C-/>
                },

                n = {
                    ["<esc>"] = actions.close,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,

                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<C-/>"] = actions.which_key,
                },
            },
        },
        extensions = {
            live_grep_args = {
                auto_quoting = true, -- enable/disable auto-quoting
                mappings = {
                    i = {
                        ["<C-k>"] = lga_actions.quote_prompt(),
                        ["<C-l>g"] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
                        ["<C-l>t"] = lga_actions.quote_prompt({ postfix = ' -t' }),
                    }
                }
            }
        }
    }

    local tb = require('telescope.builtin')

    -- in vim help: amazing!!!
    vim.keymap.set('n', '<leader>sh', tb.help_tags, { desc = '[S]earch [H]elp' })

    -- from pwd down
    vim.keymap.set('n', '<leader>sf', tb.find_files, { desc = '[S]earch [F]iles' })

    -- grep word under cursor
    vim.keymap.set('n', '<leader>sw',
        tb.grep_string, { desc = '[S]earch current [W]ord' })

    -- open rg window
    -- vim.keymap.set('n', '<leader>sg', tb.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set("n", "<leader>sg",
        ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = '[S]earch by [G]rep' })


    -- basically minibuf of diagnostics
    vim.keymap.set('n', '<leader>sd',
        tb.diagnostics, { desc = '[S]earch [D]iagnostics' })

    vim.keymap.set('n', '<leader>?',
        tb.oldfiles, { desc = '[?] Find recently opened files' })

    -- open buffer
    vim.keymap.set('n', '<leader><space>',
        require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })

    -- find here - in this file
    vim.keymap.set('n', '<leader>/', function()
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer]' })
end

-- =====
-- nvim-tree
-- =====
local nvimtree_is_there, nvimtree = pcall(require, "nvim-tree")
if nvimtree_is_there then
    nvimtree.setup({
        view = {
            adaptive_size = true,
            mappings = {
                list = {
                    { key = "h", action = "split" },
                    { key = "<leader>h", action = "split" },
                    { key = "v", action = "vsplit" },
                    { key = "<leader>v", action = "vsplit" },
                },
            },
        },
        actions = {
            open_file = { window_picker = { enable = false } }
        }
    }
    )
end

-- bufferline
-- =====
local is_there, bufferline = pcall(require, "bufferline")
if is_there then
    bufferline.setup {
        options = {
            themable = true, -- whether or not the highlights for this plugin can be overriden.
            show_close_icon = false,
            show_buffer_close_icons = false,
            diagnostics = true,
            offsets = { { filetype = "NvimTree" } },
        }
    }
end


-- ack
-- =====
vim.cmd [[ let g:ackprg = 'ag --vimgrep' ]]


-- =====
-- Markdown preview
-- =====

-- just for reference
-- nmap <C-s> <Plug>MarkdownPreview
-- nmap <M-s> <Plug>MarkdownPreviewStop
-- nmap <C-p> <Plug>MarkdownPreviewToggle
--
vim.g.vim_markdown_folding_disabled = true

-- test
-- ====
vim.g['test#strategy'] = 'neovim'
-- " set this to false to close on key-press
-- vim.g['test#neovim#start_normal'] = true
keymap("n", "<leader>tn", ":TestNearest<CR>", { desc = 'test nearest' })
keymap("n", "<leader>tl", ":TestLast<CR>", { desc = 'test last' })
keymap("n", "<leader>tf", ":TestFile<CR>", { desc = 'test last' })


-- which key
-- =====
local is_there, whichkey = pcall(require, 'which-key')
if is_there then
    whichkey.setup {
        plugins = {
            spelling = { enabled = true, suggestions = 20 }, -- z= menu
        },
    }
    require 'which-key'.register({
        ["<leader>s"] = { name = 'search' },
        ["<leader>d"] = { name = 'diagnostic' },
        ["s"] = { name = 'surround' },
    })
end


-- Unsorted
--autocmd FileType markdown nmap <buffer><silent> <leader>i :call mdip#MarkdownClipboardImage()<CR>
--" there are some defaults for image directory and image name, you can change them
--let g:mdip_imgdir = 'attachments'
--let g:mdip_imgname = 'image'
--foo
--

-- lualine
-- ===

local is_there, lualine = pcall(require, 'lualine')
if is_there then
    lualine.setup()
end


-- ===
-- trouble
-- ===
local is_there, trouble = pcall(require, "trouble")
if is_there then
    trouble.setup({})
end

vim.g.python3_host_prog = '/usr/bin/python3'

------
-- OWN COMMANDS
------

-- show what you just yanked
-- ======
vim.cmd [[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END
]]

vim.cmd [[ command! Q execute ':bwipe!' ]] -- close buffer (unload) and window, close test terminal

vim.api.nvim_create_user_command('Gm', 'G commit -m <args>', { nargs = 1 })
keymap("n", "<leader>G", ":tab G<CR>", { desc = 'git status' })
keymap("n", "<leader>cc", ":e ~/.config/nvim/init.lua<CR>", { desc = 'config change' })
keymap("n", "<leader>cs", ":so ~/.config/nvim/init.lua|echo 'sourced' <CR>", { desc = 'config so' })
