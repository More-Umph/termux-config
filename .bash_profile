export PS1='\e[35m\w\e[0m\n\e[92m$\e[0m '   # Sets text before input
export USER=/data/data/com.termux/files/usr # Sets USER env var
export STORAGE=${HOME}/storage              # Sets STORAGE env var
export TERMUX=${HOME}/.termux               # Sets TERMUX env var
export TRASH=${HOME}/.trash                 # Sets TRASH env var
export NVIM=${HOME}/.config/nvim            # Sets NVIM env var

alias profile="nvim ~/.bash_profile"  # Alias 'profile' to open this file
alias reload="source ~/.bash_profile" # Alias 'reload' to source this file
alias home="cd ${HOME}"               # Alias 'home' to cd into home directory
alias user="cd ${USER}"               # Alias 'user' to cd into usr directory
alias back="cd .."                    # Alias 'back' to go back one directory
alias list="ls -X -A"                 # Alias 'list' to show all files and sort by file type
alias vim="nvim"


setup() {
    if [ ! -d "${STORAGE}" ]; then
        termux-setup-storage
    fi

    pkg upgrade
    pkg install termux-api
    pkg install neovim
    pkg install htop
    
    curl "https://raw.githubusercontent.com/MoreUmph/termux-config/master/init.vim" -o ${NVIM}/init.vim
    
    for DIR in ${TERMUX} ${TRASH}; do
        if [ ! -d $DIR ]; then
            mkdir -p $DIR
        fi
    done
    
    toast "Use the 'profile' and 'reload' commands to edit configuration"
}


# ===========
# print(args)
# ===========
# - Prints 'args' to stdout
# Ex: print "To the terminal"

print() {
    echo "$@"
}




# ==============
# open(url/file)
# ==============
# - Opens 'url/file' externally
# Ex: open "https://google.com"

open() {
    termux-open "$@" &
}




# =========
# disk()
# =========
# - Prints disk space info
# Ex: disk

disk() {
    df -h
}




# ==========
# file(path)
# ==========
# - Opens 'path' with NeoVim
# Ex: file $HOME/.bash_profile

file() {
    nvim "$1"
}




# =========
# dir(path)
# =========
# - Cd into 'path', creating it if it doesnt exist
# Ex: dir path/subpath/file.txt

dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
    cd "$1"
}




# ===============
# copy(src, dest)
# ===============
# - Copies 'src' to 'dest'
# Ex: copy file backup/file

copy() {
    cp "$1" "$2"
}




# ===================
# hardlink(src, dest)
# ===================
# - Hardlinks 'src' to 'dest'
# Ex: link local external

link() {
    ln "$1" "$2"
}




# ===================
# softlink(src, dest)
# ===================
# - Softlinks 'src' to 'dest'

softlink() {
    ln -s "$1" "$2"
}




# ===========
# trash(file)
# ===========
# - Move 'file' to $TRASH

trash() {
    if [ -d ${TRASH} ]; then
        mv "$1" ${TRASH}
    else
        rm -rd "$1"
    fi
}




# ===================
# download(url, file)
# ===================
# - Downloads 'url' as 'file'

download() {
    curl "$1" -o "$2"
}




# ============
# install(pkg)
# ============
# - Installs 'pkg'

install() {
    pkg install "$1"
}



# ========
# update()
# ========
# - Updates and upgrades packages

update() {
    pkg update
    pkg upgrade
}




# ======================
# send(title, description, url)
# ======================
# - Download file externally

send() {
    termux-download -d "$2" -t "$1" "$3" &
}




# ===========================
# clipboard(get/set, content)
# ===========================
# -

clipboard() {
    if [ $1 == 'copy' ]; then
        termux-clipboard-get
    else
        termux-clipboard-set "$2" &
    fi
}




# =================
# brightness(0-255)
# =================
# -

brightness() {
    termux-brightness "$1" &
}




# ======================
# toast(title)
# ======================
# -

toast() {
    termux-toast -b gray -c black -g middle "$1" &
}




# ======================
# notify(title, content)
# ======================
# -

notify() {
    termux-notification -t "$1" -c "$2"
}
