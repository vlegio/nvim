vim.cmd [[ packadd packer.nvim ]]

if packer_bootstrap then
  require('packer').sync()
end

return require('packer').startup(function()
    -- Packer сам себя
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'

    -----------------------------------------------------------
    -- ПЛАГИНЫ ВНЕШНЕГО ВИДА
    -----------------------------------------------------------
    -- Цветовая схема
    use 'joshdick/onedark.vim'
    -- Устанавливаем сразу все важные иконки
    use 'kyazdani42/nvim-web-devicons'
    -- Табы вверху
    use 'romgrk/barbar.nvim'
    -- Статусная строка снизу
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'


    -----------------------------------------------------------
    -- НАВИГАЦИЯ
    -----------------------------------------------------------
    -- Файловый менеджер
    use { "nvim-telescope/telescope-file-browser.nvim" }

    -- ctags
    use {'fcying/telescope-ctags-outline.nvim'}

    -- Замена fzf и ack
    use { 'nvim-telescope/telescope.nvim' }


    -----------------------------------------------------------
    -- LSP и автодополнялка
    -----------------------------------------------------------
    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use 'nvim-treesitter/nvim-treesitter'
    -- Collection of configurations for built-in LSP client
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    -- Автодополнялка
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'saadparwaiz1/cmp_luasnip'
    --- Автодополнлялка к файловой системе
    use 'hrsh7th/cmp-path'
    -- Snippets plugin
    use 'L3MON4D3/LuaSnip'
    -- Использование EditorConfig
    use 'gpanders/editorconfig.nvim'
	
    -- TaskFile support
    use 'superevilmegaco/Taskfile.nvim'

   

    -----------------------------------------------------------
    -- Golang
    -----------------------------------------------------------
    use 'ray-x/guihua.lua' -- recommanded if need floating window support
    use 'ray-x/go.nvim'
    -- use 'mfussenegger/nvim-dap'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    -- Автокомплит для Golang
    -- use 'Shougo/deoplete.nvim'
    --use { 'deoplete-plugins/deoplete-go', config = function() require('deoplete.nvim').cmd('make') end, }

    -- YAML
    use {
        "cuducos/yaml.nvim",
        ft = {"yaml"}, -- optional
        requires = {
          "nvim-treesitter/nvim-treesitter",
          "nvim-telescope/telescope.nvim" -- optional
        },
      }


    -----------------------------------------------------------
    -- PYTHON
    -----------------------------------------------------------
    --- Шапка с импортами приводим в порядок
    use 'fisadev/vim-isort'
    -- Поддержка темплейтом jinja2
    use 'mitsuhiko/vim-jinja'


    -----------------------------------------------------------
    -- HTML и CSS
    -----------------------------------------------------------
    -- Подсвечивает закрывающий и откры. тэг. Если, где-то что-то не закрыто, то не подсвечивает.
    use 'idanarye/breeze.vim'
    -- Закрывает автоматом html и xml тэги. Пишешь <h1> и он автоматом закроется </h1>
    use 'alvan/vim-closetag'


    -----------------------------------------------------------
    -- РАЗНОЕ
    -----------------------------------------------------------
    -- Даже если включена русская раскладка vim команды будут работать
    use 'powerman/vim-plugin-ruscmd'
    -- 'Автоформатирование' кода для всех языков
    use 'Chiel92/vim-autoformat'
    --- popup окошки
    use 'nvim-lua/popup.nvim'
    -- Обрамляет или снимает обрамление. Выдели слово, нажми S и набери <h1>
    use 'tpope/vim-surround'
    -- Считает кол-во совпадений при поиске
    use 'google/vim-searchindex'
    -- Комментирует по gc все, вне зависимости от языка программирования
    use 'terrortylor/nvim-comment'
    -- Закрывает автоматом скобки
    use 'cohama/lexima.vim'
    -- Линтер, работает для всех языков
    use 'dense-analysis/ale'
    -- Git Blame
    use 'APZelos/blamer.nvim'
	-- notify
	use 'rcarriga/nvim-notify'
end)
