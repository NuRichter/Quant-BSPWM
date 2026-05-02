--  ╔═══════════════════════════════════════════════════════════════╗
--  ║  Quant BSPWM - Neovim Configuration                         ║
--  ║  Lazy.nvim + LSP + Treesitter + Telescope                   ║
--  ╚═══════════════════════════════════════════════════════════════╝

-- Leader key (must be set before lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Core Options ──────────────────────────────────────────────────

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Display
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.showmode = false
opt.pumheight = 12
opt.cmdheight = 1
opt.laststatus = 3
opt.fillchars = { eob = " " }

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.fileencoding = "utf-8"

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = { "menu", "menuone", "noselect" }

-- Clipboard (system)
opt.clipboard = "unnamedplus"

-- Mouse
opt.mouse = "a"

-- Whitespace display
opt.list = true
opt.listchars = { tab = "  ", trail = "~", extends = ">", precedes = "<" }

-- CJK rendering
opt.ambiwidth = "single"

-- ── Keymaps ───────────────────────────────────────────────────────

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", opts)

-- Resize windows
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Stay centered
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Clear search highlight
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Save / Quit
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>Q", ":qa!<CR>", opts)

-- Better paste (don't lose register)
map("x", "<leader>p", '"_dP', opts)

-- Select all
map("n", "<C-a>", "ggVG", opts)

-- Terminal
map("n", "<leader>tt", ":split | terminal<CR>", opts)
map("t", "<Esc>", "<C-\\><C-n>", opts)

-- ── Bootstrap Lazy.nvim ───────────────────────────────────────────

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugin Specifications ─────────────────────────────────────────

require("lazy").setup({

    -- Colorscheme (Catppuccin with Quant overrides)
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = true,
                term_colors = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = { enabled = true },
                    treesitter = true,
                    indent_blankline = { enabled = true },
                    mason = true,
                    which_key = true,
                    mini = { enabled = true },
                },
                color_overrides = {
                    mocha = {
                        base = "#16141f",
                        mantle = "#0e0c15",
                        crust = "#0e0c15",
                        surface0 = "#1e1c2a",
                        surface1 = "#2a2837",
                        surface2 = "#3a3849",
                        overlay0 = "#6e6a86",
                        overlay1 = "#908caa",
                        text = "#e0def4",
                        subtext0 = "#908caa",
                        subtext1 = "#bfbdd4",
                        pink = "#f5c2e7",
                        mauve = "#cba6f7",
                        red = "#f38ba8",
                        peach = "#fab387",
                        yellow = "#f9e2af",
                        green = "#a6e3a1",
                        teal = "#94e2d5",
                        blue = "#89b4fa",
                        lavender = "#c4a7e7",
                    },
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash", "c", "cpp", "css", "html", "java", "javascript",
                    "json", "lua", "markdown", "markdown_inline", "python",
                    "regex", "rust", "toml", "tsx", "typescript", "vim",
                    "vimdoc", "yaml",
                },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
            })
        end,
    },

    -- Telescope (fuzzy finder)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    prompt_prefix = "   ",
                    selection_caret = "  ",
                    entry_prefix = "  ",
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = { prompt_position = "top", preview_width = 0.55 },
                    },
                    file_ignore_patterns = {
                        "node_modules", ".git/", "target/", "__pycache__",
                        "%.class", "%.jar", "%.o", "%.a",
                    },
                },
            })
            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")

            local builtin = require("telescope.builtin")
            map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
            map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
            map("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
            map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
            map("n", "<leader>fw", builtin.grep_string, { desc = "Grep word" })
            map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
            map("n", "<leader>fs", builtin.git_status, { desc = "Git status" })
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
        },
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = { package_installed = "", package_pending = "", package_uninstalled = "" },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls", "pyright", "ts_ls", "rust_analyzer",
                    "jdtls", "html", "cssls", "jsonls", "bashls",
                    "clangd", "tailwindcss",
                },
                automatic_installation = true,
            })

            require("fidget").setup({ notification = { window = { winblend = 0 } } })

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                local lmap = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
                end
                lmap("gd", vim.lsp.buf.definition, "Go to definition")
                lmap("gr", vim.lsp.buf.references, "References")
                lmap("gI", vim.lsp.buf.implementation, "Implementation")
                lmap("K", vim.lsp.buf.hover, "Hover")
                lmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
                lmap("<leader>rn", vim.lsp.buf.rename, "Rename")
                lmap("<leader>D", vim.lsp.buf.type_definition, "Type definition")
                lmap("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
                lmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
            end

            local servers = {
                "lua_ls", "pyright", "ts_ls", "rust_analyzer",
                "html", "cssls", "jsonls", "bashls", "clangd", "tailwindcss",
            }

            for _, server in ipairs(servers) do
                local server_opts = { capabilities = capabilities, on_attach = on_attach }
                if server == "lua_ls" then
                    server_opts.settings = {
                        Lua = {
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                            diagnostics = { globals = { "vim" } },
                        },
                    }
                end
                lspconfig[server].setup(server_opts)
            end

            -- Diagnostic signs
            local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl })
            end

            vim.diagnostic.config({
                virtual_text = { prefix = "" },
                float = { border = "rounded" },
                severity_sort = true,
            })
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
            })
        end,
    },

    -- File tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            require("nvim-tree").setup({
                view = { width = 32, side = "left" },
                renderer = {
                    indent_markers = { enable = true },
                    icons = { show = { git = true, folder = true, file = true } },
                },
                filters = { dotfiles = false, custom = { "^.git$" } },
                git = { enable = true, ignore = false },
            })
            map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
            map("n", "<leader>o", ":NvimTreeFocus<CR>", opts)
        end,
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "^" },
                    changedelete = { text = "~" },
                },
                current_line_blame = true,
                current_line_blame_opts = { delay = 500 },
            })
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- Buffer line (tabs)
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = {
                    separator_style = "thin",
                    diagnostics = "nvim_lsp",
                    show_buffer_close_icons = true,
                    show_close_icon = false,
                    offsets = {
                        { filetype = "NvimTree", text = " Explorer", highlight = "Directory" },
                    },
                },
                highlights = require("catppuccin.groups.integrations.bufferline").get(),
            })
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("ibl").setup({
                indent = { char = "." },
                scope = { enabled = true, show_start = false, show_end = false },
            })
        end,
    },

    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({ check_ts = true })
        end,
    },

    -- Comment toggling
    {
        "numToStr/Comment.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("Comment").setup()
        end,
    },

    -- Which-key (keybind hints)
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup({
                window = { border = "rounded" },
            })
        end,
    },

    -- Surround
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end,
    },

    -- Todo comments
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("todo-comments").setup()
        end,
    },

    -- Color highlighter
    {
        "NvChad/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("colorizer").setup({
                filetypes = { "*" },
                user_default_options = {
                    css = true,
                    tailwind = true,
                    mode = "virtualtext",
                    virtualtext = "",
                },
            })
        end,
    },

    -- Smooth scrolling
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        config = function()
            require("neoscroll").setup({ mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" } })
        end,
    },

    -- Dashboard
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.header.val = {
                "",
                "   ██████╗ ██╗   ██╗ █████╗ ███╗   ██╗████████╗",
                "  ██╔═══██╗██║   ██║██╔══██╗████╗  ██║╚══██╔══╝",
                "  ██║   ██║██║   ██║███████║██╔██╗ ██║   ██║   ",
                "  ██║▄▄ ██║██║   ██║██╔══██║██║╚██╗██║   ██║   ",
                "  ╚██████╔╝╚██████╔╝██║  ██║██║ ╚████║   ██║   ",
                "   ╚══▀▀═╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝ ",
                "",
            }

            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
                dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
                dashboard.button("g", "  Grep text", ":Telescope live_grep<CR>"),
                dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
                dashboard.button("c", "  Configuration", ":e $MYVIMRC<CR>"),
                dashboard.button("l", "  Lazy plugins", ":Lazy<CR>"),
                dashboard.button("q", "  Quit", ":qa<CR>"),
            }

            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"

            alpha.setup(dashboard.config)
        end,
    },

}, {
    ui = {
        border = "rounded",
        icons = { cmd = " ", config = " ", event = " ", ft = " ", init = " " },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "netrwPlugin",
                "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
        },
    },
})
