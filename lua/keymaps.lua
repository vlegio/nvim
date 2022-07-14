local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

-- Стрелочки откл. Использовать hjkl
-- map('', '<up>', ':echoe "Use k"<CR>', {noremap = true, silent = false})
-- map('', '<down>', ':echoe "Use j"<CR>', {noremap = true, silent = false})
-- map('', '<left>', ':echoe "Use h"<CR>', {noremap = true, silent = false})
-- map('', '<right>', ':echoe "Use l"<CR>', {noremap = true, silent = false})
-- Автоформат + сохранение по CTRL-s , как в нормальном, так и в insert режиме
map('n', '<C-s>', ':Autoformat<CR>:w<CR>',  default_opts)
map('i', '<C-s>', '<esc>:Autoformat<CR>:w<CR>', default_opts)
-- Переключение вкладок с помощью TAB или shift-tab (akinsho/bufferline.nvim)
map('n', '<Tab>', ':bn<CR>', default_opts)
map('n', '<S-Tab>', ':bp<CR>', default_opts)
-- Закрыть вкладку по CTRL-w
map('n', '<C-w>', ':bd<CR>', default_opts)
-- fzf
map('n', '<C-a>', ':Telescope find_files<CR>', {noremap = true})
map('n', '<C-p>', ':Telescope buffers<CR>', {noremap = true})

-----------------------------------------------------------
-- Фн. клавиши по F1 .. F12
-----------------------------------------------------------
-- По F1 очищаем последний поиск с подсветкой
map('n', '<F1>', ':nohl<CR>', default_opts)
-- shift + F1 = удалить пустые строки
map('n', '<S-F1>', ':g/^$/d<CR>', default_opts)
-- <F2> Telescope файловый браузер
map('n','<F2>', ':Telescope file_browser<CR>', {noremap = true})
map('i','<F2>', '<esc>:Telescope file_browser<CR>', {noremap = true})
-- <F3> перечитать конфигурацию nvim Может не работать, если echo $TERM  xterm-256color
map('n', '<F3>', ':so ~/.config/nvim/init.lua<CR>:so ~/.config/nvim/lua/plugins.lua<CR>:so ~/.config/nvim/lua/settings.lua<CR>:so ~/.config/nvim/lua/keymaps.lua<CR>', { noremap = true })
-- <F4>
-- <F6>
-- <F7>
-- <F8>  Показ дерева классов и функций, плагин majutsushi/tagbar
map('n', '<F8>', ':TagbarToggle<CR>', default_opts)
-- <F11> Проверка орфографии  для русского и английского языка
map('n', '<F11>', ':set spell!<CR>', default_opts)
map('i', '<F11>', '<C-O>:set spell!<CR>', default_opts)

