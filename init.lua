-----------------------------------------------------------------
--                                                              --
--  ███╗   ██╗ ██╗   ██╗ ██╗ ███╗   ███╗     ███████╗ ███████╗  --
--  ████╗  ██║ ██║   ██║ ██║ ████╗ ████║     ██╔════╝ ██╔════╝  --
--  ██╔██╗ ██║ ██║   ██║ ██║ ██╔████╔██║     █████╗   ███████╗  --
--  ██║╚██╗██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║     ██╔══╝   ╚════██║  --
--  ██║ ╚████║  ╚████╔╝  ██║ ██║ ╚═╝ ██║     ██║      ███████║  --
--  ╚═╝  ╚═══╝   ╚═══╝   ╚═╝ ╚═╝     ╚═╝     ╚═╝      ╚══════╝  --
--                                                              --
------------------------------------------------------------------

-- Let's try nvim from scratch again.

----------------------------------
--                              --
--  █▀█ █▀█ ▀█▀ █ █▀█ █▄ █ █▀▀  --
--  █▄█ █▀▀  █  █ █▄█ █ ▀█ ▄▄█  --
--                              --
----------------------------------

vim.opt.number = true
vim.opt.relativenumber = true

-- Share vim clipboard with system clipboard (unnamedplus)
-- `vim.schedule` -> defer clipboard configuration to improve startup time
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Enable highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable line wrap
vim.opt.wrap = false

-- Configure tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Specific to vim-tmux-navigator
vim.g.tmux_navigator_no_mappings = 1        -- skip if you want the default <C-hjkl>
vim.g.tmux_navigator_save_on_switch = 2     -- optional: :wall when leaving nvim
vim.g.tmux_navigator_disable_when_zoomed = 1

--------------------------------------------
--                                        --
--  █▀▀ █▀█ █▀▄▀█ █▀▄▀█ ▄▀█ █▄ █ █▀▄ █▀▀  --
--  █▄▄ █▄█ █ ▀ █ █ ▀ █ █▀█ █ ▀█ █▄▀ ▄▄█  --
--                                        --
--------------------------------------------

vim.api.nvim_create_user_command("Shebang", function()
  local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
  if first_line:sub(1, 2) == "#!" then
    return
  end
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { "#!/usr/bin/env bash", "" })
end, {})

----------------------------------
--                              --
--  █▀█ █   █ █ █▀▀ █ █▄ █ █▀▀  --
--  █▀▀ █▄▄ █▄█ █▄█ █ █ ▀█ ▄▄█  --
--                              --
----------------------------------

-- Install plugins

vim.pack.add({
    -- VimBeGood learning game
    -- * Invoke with `:VimBeGood`
    { src = "https://github.com/folke/snacks.nvim" },
    -- Highlighted TODO comments
	{ src = "https://github.com/folke/todo-comments.nvim", },
	{ src = "https://github.com/ThePrimeagen/vim-be-good", },
	{ src = "https://github.com/rose-pine/neovim", name = "rose-pine", },
    { src = "https://github.com/christoomey/vim-tmux-navigator" },
    -- Keystroke recorder
	{
		src = "https://github.com/NStefan002/screenkey.nvim",
		version = "v2.4.2",
	},
})

-- Configure plugins

require("snacks").setup({
    picker   = { enabled = true },
    explorer = { enabled = true, replace_netrw = true },
})
require("todo-comments").setup()
require("screenkey").setup()

require("rose-pine").setup()
vim.cmd("colorscheme rose-pine")

-------------------------------------
--                                 --
--  █▄▀ █▀▀ █▄█ █▀▄▀█ ▄▀█ █▀█ █▀▀  --
--  █ █ ██▄  █  █ ▀ █ █▀█ █▀▀ ▄▄█  --
--                                 --
-------------------------------------

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- Toggle Screenkey recording plugin
map("n", "<leader>rk", "<cmd>Screenkey toggle<CR>", { desc = "Toggle Screen Key [R]ecorder" })

-- Past over void keymap:
--  To paste over a selection without updating the paste register
map("x", "<leader>p", [["_dP]], { desc = "[P]aste over void" })

-- Snacks keymaps:
map("n", "<leader>e",       function() Snacks.explorer() end,              { desc = "File explorer" })
map("n", "<leader><space>", function() Snacks.picker.smart() end,          { desc = "Smart find files" })
map("n", "<leader>ff",      function() Snacks.picker.files() end,          { desc = "Find files" })
map("n", "<leader>fr",      function() Snacks.picker.recent() end,         { desc = "Recent files" })
map("n", "<leader>sg",      function() Snacks.picker.grep() end,           { desc = "Live grep" })
map("n", "<leader>sb",      function() Snacks.picker.buffers() end,        { desc = "Buffers" })
map("n", "<leader>sh",      function() Snacks.picker.help() end,           { desc = "Help tags" })
map("n", "<leader>sk",      function() Snacks.picker.keymaps() end,        { desc = "Keymaps" })
map("n", "<leader>sw",      function() Snacks.picker.grep_word() end,      { desc = "Grep word under cursor" })

-- Tmux compatibility
local opts = { silent = true }
map({ 'n', 'v' }, '<C-Left>',  '<cmd>TmuxNavigateLeft<cr>',  opts)
map({ 'n', 'v' }, '<C-Down>',  '<cmd>TmuxNavigateDown<cr>',  opts)
map({ 'n', 'v' }, '<C-Up>',    '<cmd>TmuxNavigateUp<cr>',    opts)
map({ 'n', 'v' }, '<C-Right>', '<cmd>TmuxNavigateRight<cr>', opts)

-- Custom keymaps:
map("n", "<leader>msb", '<cmd>Shebang<cr>', { desc = "Insert Shebang" })
