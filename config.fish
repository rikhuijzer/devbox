if test (pwd) = $HOME
    cd ~/git/
end

abbr cbt 'cmake --build build --target'
abbr e 'nvim'
abbr g 'git'
abbr ga 'git add .'
abbr gc 'git commit -m'
abbr gck 'git checkout'
abbr gd 'git diff'
abbr gl 'git log --pretty=format:"%ai: %h %s"'
abbr gp 'git push'
abbr gs 'git status'
abbr gt '~/git/'
abbr gup 'git up'
abbr la 'ls -ahlv'
abbr llvm '~/git/llvm-project'
abbr r 'ranger'

set -x EDITOR nvim

set -x PIPENV_VENV_IN_PROJECT 1
set -x LANG en_US.UTF-8
set -x TRITON_BUILD_WITH_CLANG_LLD true

function fish_prompt
    printf '%s@%s %s%s%s (%sDEVBOX%s)> ' $USER DEVBOX \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) \
        (set_color $fish_color_cwd) (set_color normal)
end
