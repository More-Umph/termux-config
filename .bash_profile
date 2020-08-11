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
    CURR_DIR=${PWD}
    cd $HOME
    if [ ! -d "${STORAGE}" ]; then
        termux-setup-storage
    fi

    echo y | pkg upgrade
    echo y | pkg install termux-api neovim htop git openssh
    
    for DIR in ${TERMUX} ${TRASH} ${NVIM}; do
        if [ ! -d $DIR ]; then
            mkdir -p $DIR
        fi
    done
    
    curl "https://raw.githubusercontent.com/MoreUmph/termux-config/master/init.vim" -o ${NVIM}/init.vim
    toast "Use the 'profile' and 'reload' commands to edit configuration"
    cd $CURR_DIR
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
# Ex: file "$HOME/.bash_profile"

file() {
    nvim "$1"
}




# =========
# dir(path)
# =========
# - Cd into 'path', creating it if it doesnt exist
# Ex: dir "path/subpath"

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
# Ex: copy "file" "backup/file"

copy() {
    cp "$1" "$2"
}




# ===================
# hardlink(src, dest)
# ===================
# - Hardlinks 'src' to 'dest'
# Ex: link "local.yml" "external.yml"

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
# Ex: trash "old_folder"

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
# Ex: download "https://MoreRam.com" "cool.html"

download() {
    curl "$1" -o "$2"
}




# ============
# install(pkg)
# ============
# - Installs 'pkg'
# Ex: install rust clang

install() {
    pkg install "$@"
}



# ========
# update()
# ========
# - Updates and upgrades packages
# Ex: update

update() {
    pkg update
    pkg upgrade
}




# ======================
# send(title, description, url)
# ======================
# - Download file externally
# Ex: send "Webpage" "A page to save" "https://google.com"

send() {
    termux-download -d "$2" -t "$1" "$3" &
}




# ===========================
# clipboard(paste/set/file, content/path)
# ===========================
# -
# Ex: clipboard file "file.txt"

clipboard() {
    if [ $1 == "paste" ]; then
        termux-clipboard-get
    elif [ $1 == "set" ]; then
        termux-clipboard-set "$2" &
    elif [ $1 == "file" ]; then
        termux-clipboard-set "$(cat $2)" &
    fi
}




# =================
# brightness(0-255)
# =================
# -
# Ex: brightness 0

brightness() {
    termux-brightness "$1" &
}




# ======================
# toast(title)
# ======================
# -
# Ex: toast "A little popup"

toast() {
    termux-toast -b gray -c black -g middle "$1" </dev/null &>/dev/null &
}




# ======================
# notify(title, content)
# ======================
# -

notify() {
    termux-notification -t "$1" -c "$2"
}
