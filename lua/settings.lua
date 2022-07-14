local cmd = vim.cmd             -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
local g = vim.g                 -- global variables
local opt = vim.opt             -- global/buffer/windows-scoped options
-- Направление перевода с русского на английский
g.translate_source = 'ru'
g.translate_target = 'en'

-- Конфиг ale + eslint
g.ale_fixers = {
    javascript = { 'eslint' },
}
g.ale_sign_error = '$'
g.ale_sign_warning = '!'
g.ale_fix_on_save = 1
g.ale_lint_on_save = 1
-- Автокомплит
g.ale_completion_enabled = 1
g.ale_completion_autoimport = 1
-- Запуск линтера, только при сохранении
g.ale_lint_on_text_changed = 'never'
g.ale_lint_on_insert_leave = 0
-- g.syntastic_yaml_checkers = {'yamllint'}
-- -- Change these if you want
-- g.signify_sign_add               = '+'
-- g.signify_sign_delete            = '_'
-- g.signify_sign_delete_first_line = '‾'
-- g.signify_sign_change            = '~'

-- -- I find the numbers disctracting
-- g.signify_sign_show_count = 0
-- g.signify_sign_show_text = 1

-----------------------------------------------------------
-- Главные
-----------------------------------------------------------
opt.colorcolumn = '120'             -- Разделитель на 140 символов
opt.cursorline = true               -- Подсветка строки с курсором
opt.spelllang= { 'en_us', 'ru' }    -- Словари рус eng
opt.number = true                   -- Включаем нумерацию строк
opt.relativenumber = true           -- Вкл. относительную нумерацию строк
opt.so = 999                        -- Курсор всегда в центре экрана
opt.undofile = true                 -- Возможность отката назад
opt.splitright = true               -- vertical split вправо
opt.splitbelow = true               -- horizontal split вниз
-----------------------------------------------------------
-- Цветовая схема
-----------------------------------------------------------
opt.termguicolors = true      --  24-bit RGB colors
cmd 'colorscheme onedark'
-----------------------------------------------------------
-- Табы и отступы
-----------------------------------------------------------
cmd([[
filetype indent plugin on
syntax enable
]])
opt.expandtab = true       -- use spaces instead of tabs
opt.shiftwidth = 4         -- shift 4 spaces when tab
opt.tabstop = 4            -- 1 tab == 4 spaces
opt.smartindent = true     -- autoindent new lines

-----------------------------------------------------------
-- Различные плюшки из старого конфига
-----------------------------------------------------------
opt.fileencoding = 'utf-8' -- The encoding written to file
opt.encoding = 'utf-8'     -- The encoding displayed
opt.pumheight = 10         -- Makes popup menu smaller
opt.autoindent = true      -- Good auto indent
-- g.onedark_termcolors = 256
-- opt.laststatus = 0         -- Always display the status line
-- opt.cursorline = true -- Enable highlighting of the current line
-- opt.background = 'dark' -- tell vim what the background color looks like
opt.showtabline = 2 -- Always show tabs
-- opt.clipboard = 'unnamedplus' -- Copy paste between vim and everything else
-- opt.updatetime=300 -- Faster completion
-- opt.timeoutlen=500 -- By default timeoutlen is 1000 ms


-- don't auto commenting new lines
cmd [[ au BufEnter * set fo-=c fo-=r fo-=o ]]
-- remove line lenght marker for selected filetypes
cmd [[ autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0 ]]
-- 2 spaces for selected filetypes
cmd [[ autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml,htmljinja setlocal shiftwidth=2 tabstop=2 ]]
-- 4 spaces for selected filetypes
cmd [[ autocmd FileType go,sh,py setlocal shiftwidth=4 tabstop=4 ]]
-- С этой строкой отлично форматирует html файл, который содержит jinja2
cmd[[ autocmd BufNewFile,BufRead *.html set filetype=htmldjango ]]

-----------------------------------------------------------
-- Полезные фишки
-----------------------------------------------------------
-- Запоминает где nvim последний раз редактировал файл
cmd [[ autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]


-----------------------------------------------------------
-- Установки для плагинов
-----------------------------------------------------------
-- Blamer
g.blamer_enabled = 1
g.blamer_delay = 200
g.blamer_date_format = '%y-%m-%d %H:%M'

-- Disable EditorConfig for a specific filetype - gitcommit
cmd [[ au FileType gitcommit let b:EditorConfig_disable = 1 ]]

-- LSP settings
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {}
    if server.name == "sumneko_lua" then
        -- only apply these settings for the "sumneko_lua" server
        opts.settings = {
            Lua = {
                diagnostics = {
                    -- Get the language server to recognize the 'vim', 'use' global
                    globals = {'vim', 'use'},
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        }
    end
    server:setup(opts)
end)

-- nvim_comment
local nvim_comment = require('nvim_comment')
nvim_comment.setup(
{
    -- Linters prefer comment and line to have a space in between markers
    marker_padding = true,
    -- should comment out empty or whitespace only lines
    comment_empty = false,
    -- trim empty comment whitespace
    comment_empty_trim_whitespace = false,
    -- Should key mappings be created
    create_mappings = true,
    -- Normal mode mapping left hand side
    line_mapping = "gcc",
    -- Visual/Operator mapping left hand side
    operator_mapping = "gc",
    -- text object mapping, comment chunk,,
    comment_chunk_text_object = "ic",
    -- Hook function to call before commenting takes place
    hook = nil
}
)


-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
vim.o.completeopt = 'menuone,noselect'
-- luasnip setup
local luasnip = require 'luasnip'
-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer', options = {
            get_bufnrs = function()
                return vim.api.nvim_list_bufs()
            end
        },
    },
},
}

-- telescope configuration
local telescope = require("telescope").load_extension "file_browser"

-- git
-- cmd [[ set statusline+=%{get(b:,'gitsigns_status','')} ]]

-- go
cmd [[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]]
local go = require('go')
go.setup(
{
    go = "go", -- set to go1.18beta1 if necessary
    goimport = "gopls", -- if set to 'gopls' will use gopls format, also goimport
    gopls_cmd = { "/Users/jtprogru/go/bin/gopls", "-logfile", "/Users/jtprogru/work/logs/gopls.log" },
    fillstruct = "gopls",
    gofmt = "gofumpt", -- if set to gopls will use gopls format
    log_path = vim.fn.expand("$HOME") .. "/work/logs/gonvim.log",
    lsp_cfg = { capabilities = capabilities }, -- true: use non-default gopls setup specified in go/lsp.lua
    lsp_format_on_save = 1,
    lsp_keymaps = true, -- true: use default keymaps defined in go/lsp.lua
    -- virtual text setup
    lsp_diag_virtual_text = { space = 0, prefix = "" },
    lsp_diag_signs = true,
    lsp_diag_update_in_insert = false,
    lsp_fmt_async = false, -- async lsp.buf.format
    go_boilplater_url = "https://github.com/thockin/go-build-template.git",
    dap_debug = true,
    dap_debug_gui = true,
    dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
    dap_vt = true, -- false, true and 'all frames'
    dap_port = 38697, -- can be set to a number or `-1` so go.nvim will pickup a random port
    build_tags = "", --- you can provide extra build tags for tests or debugger
    textobjects = true, -- treesitter binding for text objects
    test_runner = "go", -- one of {`go`, `richgo`, `dlv`, `ginkgo`}
    verbose_tests = true, -- set to add verbose flag to tests
    run_in_floaterm = false, -- set to true to run in float window.
    test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
    luasnip = true, -- enable included luasnip
    username = "jtprogru",
    useremail = "jtprogru@gmail.com",
}
)


