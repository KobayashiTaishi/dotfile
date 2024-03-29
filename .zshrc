fpath=(/usr/local/share/zsh-completions $fpath)
# 文字コードの設定
export LC_CTYPE=ja_JP.UTF-8
export LANG=ja_JP.UTF-8
export JLESSCHARSET=japanese-sjis
export OUTPUT_CHARSET=utf-8


#----------------------------------------------------------
# エイリアス
#----------------------------------------------------------

alias ls='ls -hF'
alias ll='ls -l'
alias la='ls -A'
alias refresh='exec $SHELL -l'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'

#----------------------------------------------------------
# 基本
#----------------------------------------------------------
# 補完される前にオリジナルのコマンドまで展開してチェックする
setopt complete_aliases
# 色を使う
autoload -U colors; colors
# ビープを鳴らさない
setopt nobeep
# エスケープシーケンスを使う
setopt prompt_subst
# コマンドラインでも#以降をコメントと見なす
setopt interactive_comments
# emacs風のキーバインド
bindkey -e
# C-s, C-qを無効にする
setopt no_flow_control
# 日本語のファイル名を表示可能
setopt print_eight_bit
# C-wで直前の/までを削除する
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# ディレクトリを水色にする
export LS_COLORS='di=01;36'
#----------------------------------------------------------
# 補完関連
#----------------------------------------------------------
# 補完機能を強化
autoload -Uz compinit; compinit -u
# URLを自動エスケープ
autoload -Uz url-quote-magic; zle -N self-insert url-quote-magic

# TABで順に補完候補を切り替える
setopt auto_menu
# 補完候補を一覧表示
setopt auto_list
# 補完候補をEmacsのキーバインドで動けるように
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
# --prefix=/usrなどの=以降も補間
setopt magic_equal_subst
# ディレクトリ名の補間で末尾の/を自動的に付加し、次の補間に備える
setopt auto_param_slash
## 補完候補の色付け
#eval `dircolors`
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧でファイルの種別をマーク表示
setopt list_types
# 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash
# スペルチェック
setopt correct
# killコマンドでプロセスを補完
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

#----------------------------------------------------------
# 移動関連
#----------------------------------------------------------
# ディレクトリ名でもcd
setopt auto_cd
# cdのタイミングで自動的にpushd.直前と同じ場合は無視
setopt auto_pushd
setopt pushd_ignore_dups
## cd 時に自動で push
setopt auto_pushd
## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

#----------------------------------------------------------
# 履歴関連
#----------------------------------------------------------
# 履歴の保存先
HISTFILE=$HOME/.zsh-history
# メモリに展開する履歴の数
HISTSIZE=10000
# 保存する履歴の数
SAVEHIST=10000
# ヒストリファイルにコマンドラインだけではなく実行時刻と実行時間も保存する。
setopt extended_history
# ヒストリ全体でのコマンドの重複を禁止する
setopt hist_ignore_dups
# コマンドの空白をけずる
setopt hist_reduce_blanks
# historyコマンドはログに記述しない
setopt hist_no_store
# 先頭が空白だった場合はログに残さない
setopt hist_ignore_space
# 履歴ファイルに時刻を記録
setopt extended_history
# シェルのプロセスごとに履歴を共有
setopt share_history
# 複数のzshを同時に使うときなどhistoryファイルに上書きせず追加
setopt append_history
# 履歴をインクリメンタルに追加
setopt inc_append_history
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# 履歴検索機能のショートカット設定
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
# インクリメンタルサーチの設定
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
# 全履歴の一覧を出力する
function history-all { history -E 1 }

#----------------------------------------------------------
# プロンプト表示関連
#----------------------------------------------------------
# 右側に時間を表示する
# RPROMPT="%T"
# 右側まで入力が来ら時間を消す
setopt transient_rprompt
# プロンプト
function precmd() {
PROMPT="%{${fg[cyan]}%}%n%{${fg[yellow]}%} %~%{${reset_color}%}"
st=`git status 2>/dev/null`
if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=${fg[cyan]}
elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=${fg[blue]}
elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=${fg_bold[red]}
else
    color=${fg[red]}
fi
PROMPT+=" %{$color%}$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /')%b%{${reset_color}%}
"
#PROMPT+="%{${fg[cyan]}%}pyenv_:$(pyenv global 2> /dev/null | sed -e 's/* \(.*\)/\1 /')%b%{${reset_color}%}
#"
}

#----------------------------------------------------------
# 環境依存対応
#----------------------------------------------------------
case ${OSTYPE} in
    darwin*)
        source ~/dotfiles/.zshrc.osx
        ;;
    linux*)
        ;;
esac

#----------------------------------------------------------
# その他
#----------------------------------------------------------
# ログアウト時にバックグラウンドジョブをkillしない
setopt no_hup
# ログアウト時にバックグラウンドジョブを確認しない
setopt no_checkjobs
# バックグラウンドジョブが終了したら(プロンプトの表示を待たずに)すぐに知らせる
setopt notify

# makeのエラー出力に色付け
e_normal=`echo -e "\033[0;30m"`
e_RED=`echo -e "\033[1;31m"`
e_BLUE=`echo -e "\033[1;36m"`

function make() {
LANG=C command make "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot\sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}
function mk () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# PATH=$PATH:$HOME/.rvm/bin:/usr/local/clamXav/bin/ # Add RVM to PATH for scripting

eval "$(rbenv init -)"
export PATH=$HOME/.nodebrew/current/bin:$PATH
PATH=/usr/local/mysql-5.5/bin:$PATH
export PATH=/usr/local/redis-2.6/bin:$PATH
export PATH=$HOME/local/bin/:$PATH
export AWS_ACCESS_KEY_ID=AKIAJADTU7KZ3BRZISTA
export AWS_SECRET_ACCESS_KEY=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
export CMD_QUEUE_NAME=cmd_queue_dev_taishi
export PATH=/opt/X11/bin/:$PATH
