-- Notes
-- * '..' is used for string concatenation: 'a' .. 'b' -> 'ab'
--
-- Requirements:
-- for opensuse:
-- `zypper in -t pattern build_basis`
-- `zypper in npm`
--
--  Index
--  Packages
--  options
--  keymap
--  CMP
--  LSP

        -- border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
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
        vim.fn.system({
            'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
        })
    end
    -- vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
    vim.cmd 'packadd packer.nvim'
    local _, packer = pcall(require, "packer")
else
    -- Have packer use a popup window
    packer.init { display = { open_fn = function() return require("packer.util").float { border = "rounded" } end, }, }
end


require('packer').startup(function(use)
    use('wbthomason/packer.nvim')      -- Packer can manage itself
    use "nvim-lua/popup.nvim"          -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim"        -- Useful lua functions used ny lots of plugins
    use 'kyazdani42/nvim-web-devicons' -- optional, for file icons

    -- colors
    use 'cocopon/iceberg.vim'
    use 'mjlbach/onedark.nvim'
    use "lunarvim/darkplus.nvim"
    use "sainnhe/gruvbox-material"
    use "arcticicestudio/nord-vim"
    use "sainnhe/sonokai"
    use "sainnhe/everforest"
    use "catppuccin/nvim"
    use "kyazdani42/blue-moon"
    use "folke/tokyonight.nvim"
    use "andersevenrud/nordic.nvim"
    use "rebelot/kanagawa.nvim"

    use 'tpope/vim-fugitive'        -- Git commands in nvim
    use 'tpope/vim-rhubarb'         -- Fugitive-companion to interact with github
    use 'lewis6991/gitsigns.nvim'   -- Add git related info in the signs columns and popups
    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

    -- quality of life
    use "machakann/vim-sandwich"              -- modify {}, (), etc
    use 'numToStr/Comment.nvim'               -- easy commenting
    use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
    use 'kyazdani42/nvim-tree.lua'            -- tree file browsers
    use {'akinsho/bufferline.nvim',           -- show tabs at top
        tag = "v2.*",
        requires = 'kyazdani42/nvim-web-devicons'}
    use 'mileszs/ack.vim'

    -- Treesitter  Highlight, edit, and navigate code
    use { "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate", }
    use 'nvim-treesitter/nvim-treesitter-textobjects' --  Additional textobjects for treesitter

    -- Autocompletion
    use 'hrsh7th/nvim-cmp'                -- base plugin
    use "hrsh7th/cmp-buffer"              -- buffer completions
    use "hrsh7th/cmp-path"                -- path completions
    use "hrsh7th/cmp-cmdline"             -- cmdline completions
    use "hrsh7th/cmp-nvim-lsp"            -- language server completion
    use "hrsh7th/cmp-nvim-lua"            -- internal nvim-lua completion
    use "saadparwaiz1/cmp_luasnip"        -- snippet completions

    use "L3MON4D3/LuaSnip"                -- needed for cmp snippet engine
    use "rafamadriz/friendly-snippets"    -- a bunch of snippets to use

    -- LSP - language server protocol
    use 'neovim/nvim-lspconfig'           -- base plugin
    use 'williamboman/nvim-lsp-installer' -- Automatically/easy install language servers to stdpath

    -- Telescope
    use {"nvim-telescope/telescope.nvim",
        requires = { { "nvim-telescope/telescope-live-grep-args.nvim" }, },
        config = function() require("telescope").load_extension("live_grep_args") end
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make', cond = vim.fn.executable "make" == 1 }

    if not packer_is_there then
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
vim.opt.hlsearch = true    -- Set highlight on search
--vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = 'a'        -- Enable mouse mode
vim.opt.breakindent = true -- wrapped lines will have same indentation
vim.opt.undofile = true    -- Save undo history
vim.opt.ignorecase = true  -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smartcase = true
vim.opt.updatetime = 250   -- Decrease update time
vim.opt.signcolumn = 'yes' -- extra space for symbols next to numbers

vim.opt.completeopt = 'menu,menuone,noselect' -- Set completeopt to have a better completion experience
vim.opt.cmdheight = 2      -- more space in command line

vim.opt.fileencoding = "utf-8"

vim.opt.pumheight = 10     -- pop up menu height
vim.opt.showmode = false   -- show stuff like INSERT
vim.opt.showtabline = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.cursorline = true
vim.opt.scrolloff = 4      -- keep lines above/below
vim.opt.sidescrolloff = 4

vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4    --tab counts as this many characters
vim.opt.shiftwidth = 4     --how much to indent by defaul
vim.opt.expandtab = true    -- all tabs are replaces by spaces
-- TODO: make python specific
vim.opt.termguicolors = true
vim.opt.winblend = 15 -- pseudo transperancy: 0 nothing - 100 transparaent
vim.cmd [[colorscheme gruvbox-material]]

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
keymap("n", "<leader>n", ":bnext<CR>", opts)
keymap("n", "<leader>p", ":bprevious<CR>", opts)

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
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist)


-- ============
-- Plugins
-- ============

-- -----
-- Comment
-- -----
-- comment anywhere with Ctrl+/
require('Comment').setup {
    toggler = { line = '<C-_>'},
    opleader = { line = '<C-_>'},
    extra = {
        eol = '<C-a>', -- at the end of line 
        above = 'gcO', -- on the line above
        below = 'gco', -- on the line below
    },
}

-- ======
-- indent_blankline
-- ======
-- Show very nice lines for indentation level
require('indent_blankline').setup {
    indent_blankline_enabled = false,
}
keymap('n', '<leader>i', ':IndentBlanklineToggle<CR>', opts)

-- ======
-- gitsigns
-- ======
require('gitsigns').setup {}

-- ======
-- CMP
-- ======
local  cmp  = require "cmp"
local luasnip = require "luasnip"
require("luasnip/loaders/from_vscode").lazy_load()

-- TODO chekc what it does
local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--   פּ ﯟ   some other good icons
local kind_icons = {
    Text = "",
    Method = "m",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet
local cmpm = cmp.mapping

cmp.setup {
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    window = { documentation = cmp.config.window.bordered() },
    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
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

        -- deals with snippets and completion
        -- do correct thing on button press depending on
        -- state. Example:
        -- select_item from suggestion or jump to next snippet tag
         ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','c'}),
        -- ["<C-n>"] = cmpm(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     elseif luasnip.expandable() then
        --         luasnip.expand()
        --     elseif luasnip.expand_or_jumpable() then
        --         luasnip.expand_or_jump()
        --     elseif check_backspace() then
        --         fallback()
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s", 'c'}),
        --
        -- ["<C-p>"] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_prev_item()
        --     elseif luasnip.jumpable(-1) then
        --         luasnip.jump(-1)
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s", 'c'}),
    },
    -- how the completion menu looks (can be removed)
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
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
    -- confirm_opts = {
    --   behavior = cmp.ConfirmBehavior.Replace,
    --   select = false,
    -- },
}
cmp.setup.cmdline(':', {
    mapping = cmpm.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' } })
})
cmp.setup.cmdline(':e', {
    mapping = cmpm.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
    })
})

cmp.setup.cmdline('/', {
    mapping = cmpm.preset.cmdline(),
    sources = { { name = 'buffer' } }
})

-- =====
-- LSP
-- =====
local lspconfig = require("lspconfig")
require("nvim-lsp-installer").setup{automatic_installation = true}

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
    -- signs = { active = signs_diagnostic },
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
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]       ,
            false
        )
    end
end

local keymap_buf = vim.api.nvim_buf_set_keymap
local function lsp_keymaps(bufnr)
    local options_lsp = { noremap = true, silent = true }
    keymap_buf(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", options_lsp)
    keymap_buf(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", options_lsp)
    keymap_buf(bufnr, "n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", options_lsp)
    keymap_buf(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", options_lsp)

    -- keymap_buf(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", options_lsp)
    -- keymap_buf(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", options_lsp)
    -- keymap_buf(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", options_lsp)
    -- keymap_buf(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", options_lsp)
    -- defines command: Format
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

local on_attach = function(client, bufnr)
    if client.name == "tsserver" then
        client.resolved_capabilities.document_formatting = false
    end
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- CONFIG PER LANGUAGE
-- PYTHON
lspconfig['pyright'].setup(
    {
        on_attach = on_attach,
        capabilities = capabilities,
    }
)
-- LUA
lspconfig['sumneko_lua'].setup(
    {
        on_attach = on_attach,
        capabilities = capabilities,
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
        },
    }
)

-- =====
-- Treesitter
-- =====

require('nvim-treesitter.configs').setup {
    ensure_installed = { 'lua', 'python', 'markdown' },
    highlight = { enable = true },
    indent = { enable = true },
}

-- ======
--Telescope
-- ======
local _, telescope = pcall(require, "telescope")
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
vim.keymap.set('n', '<leader>sh',
    tb.help_tags, { desc = '[S]earch [H]elp' })

-- from pwd down
vim.keymap.set('n', '<leader>sf',
    tb.find_files, { desc = '[S]earch [F]iles' })

-- grep word under cursor
vim.keymap.set('n', '<leader>sw',
    tb.grep_string, { desc = '[S]earch current [W]ord' })

-- open rg window
-- vim.keymap.set('n', '<leader>sg', tb.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set("n", "<leader>sg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = '[S]earch by [G]rep' })


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

-- =====
-- nvim-tree
-- =====
require("nvim-tree").setup({
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
        open_file = { window_picker = { enable = false } } } }
)

-- =====
-- bufferline 
-- =====
require("bufferline").setup{
    options = {
        show_close_icon = false,
        show_buffer_close_icon = false,
        buffer_close_icon= "",
        diagnostics = "false",
        show_tab_indicators =  false,
        themable = true -- whether or not the highlights for this plugin can be overriden.
    }
}

-- show what you just yanked
vim.cmd[[
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END
]]
    
-- =====
-- ack
-- =====
vim.cmd[[ let g:ackprg = 'ag --vimgrep' ]]

