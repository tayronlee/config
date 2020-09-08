" ==============================================================================================
" ln -s <this_file>  ~/.vim/bundle/lightline.vim/autoload/lightline/colorscheme/one_tayron.vim
" ==============================================================================================
let s:base3 = '#cccccc'
let s:base23 = '#bbbbbb'
let s:base2 = '#aaaaaa'
let s:base1 = '#999999'
let s:base0 = '#777777'
let s:base00 = '#666666'
let s:base01 = '#555555'
let s:base02 = '#444444'
let s:base023 = '#333333'
let s:base03 = '#2d2d2d'
let s:red = '#f2777a'
let s:orange = '#d19a66'
let s:yellow = '#ffcc66'
let s:green = '#68d369'
let s:cyan = '#009999'
let s:blue = '#6195ff'
let s:magenta = '#be58ee'

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ [ s:base023, s:blue ], [ s:base3, s:base01 ] ]
let s:p.normal.right = [ [ s:base02, s:base1 ], [ s:base2, s:base01 ] ]
let s:p.inactive.right = [ [ s:base02, s:base0 ], [ s:base1, s:base01 ] ]
let s:p.inactive.left =  [ [ s:base02, s:base0 ], [ s:base00, s:base03 ] ]
let s:p.insert.left = [ [ s:base023, s:green ], [ s:base3, s:base01 ] ]
let s:p.replace.left = [ [ s:base023, s:orange ], [ s:base3, s:base01 ] ]
let s:p.visual.left = [ [ s:base023, s:magenta ], [ s:base3, s:base01 ] ]
let s:p.normal.middle = [ [ s:base1, s:base02 ] ]
let s:p.inactive.middle = [ [ s:base0, s:base02 ] ]
let s:p.tabline.left = [ [ s:base2, s:base01 ] ]
let s:p.tabline.tabsel = [ [ s:base2, s:base03 ] ]
let s:p.tabline.middle = [ [ s:base01, s:base1 ] ]
let s:p.tabline.right = copy(s:p.normal.right)
let s:p.normal.error = [ [ s:base023, s:red ] ]
let s:p.normal.warning = [ [ s:base023, s:yellow ] ]

let g:lightline#colorscheme#one_tayron#palette = lightline#colorscheme#fill(s:p)
