-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Tabs & indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Line wrapping & display
vim.opt.wrap = true
-- vim.opt.breakindent = true

-- Undo & performance
vim.opt.updatetime = 50
vim.opt.undofile = true

-- Line numbers
vim.opt.nu = true
vim.opt.rnu = true

-- UI
vim.opt.showmode = false
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.lazyredraw = false

-- Search
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Diagnostics
vim.diagnostic.config({ virtual_text = true })

--spelling
vim.opt.spelllang = "en_us"
vim.opt.spell = true

vim.keymap.set("n", "<A-Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<Tab>", "<cmd>b#<CR>", { desc = "Last buffer" })
vim.keymap.set("n", "Q", "<C-w>c", { desc = "Close current split" })
vim.keymap.set("n", "Q", "<cmd>bd<CR>", { desc = "Close buffer" })
