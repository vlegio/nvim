-- Init
local cmd = vim.cmd

-- Автоустановка Packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.cmd [[packadd packer.nvim]]
end

-- Use OSX clipboard to copy and to paste
cmd [[ set clipboard+=unnamedplus ]]


-----------------------------------------------------------
-- Импорт модулей lua
-----------------------------------------------------------
require('plugins')
require('settings')
require('keymaps')

