-- General settings
vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprev<CR>')
vim.opt.tabstop = 4      
vim.opt.shiftwidth = 4  
vim.opt.expandtab = true

-- Session
require('auto-session').setup({})

-- Terminal keybinds
vim.keymap.set('n', '<leader>t', ':terminal<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

vim.api.nvim_create_autocmd('TermOpen', {
	pattern = '*',
	callback = function()
		vim.cmd('startinsert')
	end
})

-- Line numbers 
vim.opt.number = true
vim.opt.relativenumber = true

-- Telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files)
vim.keymap.set('n', '<leader>fg', telescope.live_grep)
vim.keymap.set('n', '<leader>fb', telescope.buffers)
vim.keymap.set('n', '<leader>fF', function()
	telescope.find_files({ cwd = vim.fn.input('Search in: ', vim.fn.getcwd() .. '/', 'dir') })
end)

-- Zoxide wrapper
vim.api.nvim_create_user_command("Z", function(opts)
	local handle = io.popen("zoxide query " .. opts.args)
	local result = handle:read("*a"):gsub("%s+", "")
	handle:close()
	if result ~= "" then
		vim.api.nvim_set_current_dir(result)
	else
		print("No match found in zoxide")
	end
end, { nargs = 1 })

-- LSP
vim.lsp.config('clangd', {
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  cmd = { 'clangd' },
  root_markers = { 'compile_commands.json', 'CMakeLists.txt', '.git' },
})
vim.lsp.enable('clangd')

-- Colorscheme
vim.cmd.colorscheme("habamax")

-- Autocomplete
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = {{ name = "nvim_lsp" }}
})

-- Syntax highlighting
vim.api.nvim_create_autocmd("FileType", {
  pattern = { 'c', 'cpp', 'lua' },
  callback = function()
    vim.treesitter.start()
  end,
})

-- Colorscheme
vim.o.background = "light"
vim.cmd.colorscheme("gruvbox")

-- Diagnostic keybinds
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP keybinds
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)

-- Debugging 

local dap = require("dap")

dap.adapters.gdb = {
	type = 'executable',
	command = 'gdb',
	args = { '--interpreter=dap', '--eval-command', 'set print pretty on' }
}

dap.configurations.cpp = { 
	{
	name = 'Launch',
	type = 'gdb',
	request = 'launch',
	program = function()
		return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
	end,
	args = function()
		local args = vim.fn.input('Arguments: ')
		return vim.split(args, ' ')
	end,
	cwd = '${workspaceFolder}',
	stopAtBeginningOMainSubProgram = false,
	},
}
local dapui = require('dapui')

dapui.setup()

dap.listeners.after.event_initialized['dapui_config'] = function()
	dapui.open()
end

dap.listeners.after.event_terminated['dapui_config'] = function()
	dapui.close()
end

dap.listeners.after.event_exited['dapui_config'] = function()
	dapui.close()
end

vim.keymap.set('n', '<leader>du', dapui.toggle)
vim.keymap.set('n', '<leader>dt', dap.terminate)
vim.keymap.set('n', '<leader>dw', function() 
	return required('dapui').elements.watches.add(add.vim.fn.expand('<cword>'))
end)

vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>B', dap.set_breakpoint)
vim.keymap.set('n', '<leader>bc', dap.clear_breakpoints)
vim.keymap.set('n', '<F5>', dap.continue)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)vim.keymap.set('n', '<F12>', dap.step_out)

-- Lualine
require('lualine').setup({
	options = { 
		theme = 'auto',
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { function() return vim.fn.getcwd() end },
		lualine_z = { 'location' },
	}
})

-- Toggleterm
require('toggleterm').setup({
	open_mapping = [[<leader>t]],
	insert_mappings = false,
	direction = 'float',
	float_opts = {
		border = 'curved',
	},
})
