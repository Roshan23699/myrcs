# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi






##################################################################################
#---------------------CUSTOM BASHRC STARTS HERE----------------------------------#
##################################################################################


# make cd completion case insensitive
# If ~/.inputrc doesn't exist yet: First include the original /etc/inputrc
# so it won't get overriden
if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi

# Add shell-option to ~/.inputrc to enable case-insensitive tab completion
echo 'set completion-ignore-case On' >> ~/.inputrc


get_idf(){
    if [ `pwd | grep gitlab` ]
    then
        . $HOME/esp/gitlab/esp-idf/export.sh
    else
        . $HOME/esp/esp-idf/export.sh
    fi
}
alias idf='cd ~/esp/esp-idf/;st idf'
alias allow="sudo chmod 777 /dev/tty*"
ifm(){
 idf.py -p /dev/ttyUSB$1 flash monitor
}

imf(){
 idf.py -p /dev/ttyUSB$1 flash monitor
}
mif(){
 idf.py -p /dev/ttyUSB$1 flash monitor
}
fm(){
 idf.py -p /dev/ttyUSB$1 flash monitor
}
iflash(){
 idf.py build
 idf.py -p /dev/ttyUSB$1 flash
}

ier(){
  idf.py -p /dev/ttyUSB$1 erase-flash
 }

alias el='esppool -l'
efm() {
    el -f
    el -m
}

# alias for git commands

alias gc='git checkout'
alias gb='git branch'
alias gs='git status'
alias gl='git log'
alias gsh='git show'
alias gf='git fetch'
alias gsu='git submodule update --init --recursive'
alias gd='git diff'
alias gdt='git difftool'
alias gsl='git stash list'
alias gfn="git fetch origin nimble-1.5.0-idf"
alias gfm="git fetch origin master"

rebase_nimble() {
    gfn && git rebase origin/nimble-1.5.0-idf;
}

rebase_idf() {
    gfm && git rebase origin/master;
}

gcb() {
    echo $(git rev-parse --abbrev-ref HEAD)
}

# setup autocompletion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash

  __git_complete gc _git_checkout
  __git_complete gp _git_pull
  __git_complete gb _git_branch
  __git_complete gl _git_log
  __git_complete gf _git_fetch
  __git_complete gd _git_diff
  __git_complete gdt _git_difftool
else
  echo "Error loading git completions"
fi

alias lsl="ls -lcrth | tail -1"
alias at="cd /home/roshan/AT_LOG/Function"
latest() {
	at
	temp=`ls -t | head -1`
	xdg-open $temp
	cd -
}
alias template="vi /home/roshan/esp/ATS/auto_test_script/ConfigFiles/RunnerConfig/template/template.yml"
alias devices="vi /home/roshan/esp/ATS/auto_test_script/ConfigFiles/LocalConfig/template/Devices.yml"
alias ats="cd /home/roshan/esp/ATS/auto_test_script/"
alias ssc="cd /home/roshan/esp/gitlab/SSC/SSC/"
sb() {
	ssc
	iflash 0 && iflash 1
}
ar() {
	ats
	source export.sh
	python bin/LocalRunner.py
}
misc() {
	./gen_misc_idf.sh $1 $2
}

force_color_prompt=yes
 color_prompt=yes
 parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
 }
 if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\$ \n'
 else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ \n'
 fi
 unset color_prompt force_color_prompt


 #Used to make colourfull man page
 man() {
 LESS_TERMCAP_md=$'\e[01;31m' \
 LESS_TERMCAP_me=$'\e[0m' \
 LESS_TERMCAP_se=$'\e[0m' \
 LESS_TERMCAP_so=$'\e[01;44;33m' \
 LESS_TERMCAP_ue=$'\e[0m' \
 LESS_TERMCAP_us=$'\e[01;32m' \
 command man "$@"
 }

alias ughad="xdg-open"
alias show="ls /dev/ttyUSB*"

set_env_dpk() {
	allow
	unset IDF_PATH
	export IDF_PATH=`pwd`/external/esp-idf
	$IDF_PATH/install.sh
	. $IDF_PATH/export.sh
	export ACE_DIR=/home/roshan/esp/amazon/esp-dpk/apps/common/dpk_test_runner/ace
	export ACK_DEVICE_SDK_DIR=/home/roshan/esp/amazon/esp-dpk/apps/common/dpk_test_runner/ace/sdk/include/ack_device_sdk
	export BUILD_CMAKE_DIR=/home/roshan/esp/amazon/esp-dpk/apps/common/dpk_test_runner/ace/build_cmake
	cd /home/roshan/esp/amazon/esp-dpk/apps/esp/dpk_test_runner
	idf.py build
}

dpk_run() {
	cd /home/roshan/esp/amazon/esp-dpk/apps/esp/dpk_test_runner
	cmake -GNinja -S . -B build -DIDF_TARGET=esp32c3
	cmake --build build --target flash
}
dpk_s3() {
	cmake -GNinja -S . -B build -DIDF_TARGET=esp32s3
}
dpk_build() {
	cmake --build build
}
set_dpk_for_s3() {
	allow
	unset IDF_PATH
	export IDF_PATH=/home/roshan/esp/amazon/esp-dpk/external/esp-idf
	export ACE_DIR=/home/roshan/esp/amazon/esp-dpk/apps/common/dpk_test_runner/ace
	export ACK_DEVICE_SDK_DIR=/home/roshan/esp/amazon/esp-dpk/apps/common/dpk_test_runner/ace/sdk/include/ack_device_sdk
	export BUILD_CMAKE_DIR=/home/roshan/esp/amazon/esp-dpk/apps/common/dpk_test_runner/ace/build_cmake
    export ESP_DPK_DIR=/home/roshan/esp/amazon/esp-dpk
	cd $IDF_PATH
	./install.sh
	. ./export.sh
}

set_dpk_for_s3_2() {
	allow
	unset IDF_PATH
	export IDF_PATH=/home/roshan/esp/amazon/esp-dpk2/esp-dpk/external/esp-idf
	export ACE_DIR=/home/roshan/esp/amazon/esp-dpk2/esp-dpk/apps/common/dpk_test_runner/ace
	export ACK_DEVICE_SDK_DIR=/home/roshan/esp/amazon/esp-dpk2/esp-dpk/apps/common/dpk_test_runner/ace/sdk/include/ack_device_sdk
	export BUILD_CMAKE_DIR=/home/roshan/esp/amazon/esp-dpk2/esp-dpk/apps/common/dpk_test_runner/ace/build_cmake
    export ESP_DPK_DIR=/home/roshan/esp/amazon/esp-dpk
	cd $IDF_PATH
	./install.sh
	. ./export.sh
}
# AFR AFQP
alias get_esp32='export PATH="$HOME/esp/xtensa-esp32-elf/bin:$PATH"'
alias afqp='cd ~/esp/amazon/amazon-freertos'
alias rpi='cd ~/esp/amazon/amazon-freertos/libraries/abstractions/ble_hal/test/ble_test_scipts'
function afrafqp(){
    unset IDF_PATH
    ./vendors/espressif/esp-idf/install.sh
    . ./vendors/espressif/esp-idf/export.sh
    ./vendors/espressif/esp-idf/tools/idf.py fullclean
    cmake -DVENDOR=espressif -DBOARD=esp32_wrover_kit -DCOMPILER=xtensa-esp32 -S . -B build -GNinja -DAFR_ENABLE_TESTS=1
}

function afrafqpb(){
    ./vendors/espressif/esp-idf/tools/idf.py build
}

function afrafqpbfm(){
    ./vendors/espressif/esp-idf/tools/idf.py build flash monitor
}



export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init -)"
fi

#change terminal name
function st() {
  if [[ -z "$ORIG" ]]; then
    ORIG=$PS1
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1=${ORIG}${TITLE}
}
alias sti='st `pwd`'



# dts results 
alias results="cd ~/esp/amazon/esp-dpk/apps/common/dpk_test_runner/ace/sdk/test/ace_tester/results"


#afr build

afrbuild() {
    unset IDF_PATH

    ./vendors/espressif/esp-idf/install.sh
    . ./vendors/espressif/esp-idf/export.sh
    ./vendors/espressif/esp-idf/tools/idf.py fullclean #one time
    cmake -DVENDOR=espressif -DBOARD=esp32_wrover_kit -DCOMPILER=xtensa-esp32 -S . -B build -GNinja -DAFR_ENABLE_TESTS=1
    ./vendors/espressif/esp-idf/tools/idf.py build
}



#find file in the current directory
alias findfile="find ./ -iname"
alias findword="grep -nr"
alias bananapi="cd /home/roshan/esp/banana_pi/"



h2() {
    idf.py --preview set-target esp32h2
}
h4() {
    idf.py --preview set-target esp32h4
}
c6() {
    idf.py --preview set-target esp32c6
}
c3() {
    idf.py set-target esp32c3
}

c2() {
    idf.py set-target esp32c2
}

esp32() {
    idf.py set-target esp32
}

s3() {
    idf.py set-target esp32s3
}

build() {
    idf.py build
}

v() {
    if [ $# -eq 0 ]
    then
        vi $(fzf --height 10 --reverse)
    else
        vi $@
    fi
}

alias cs="cscope -R"
alias clean="idf.py fullclean;rm -rf build sdkconfig sdkconfig.old"
alias nimble="cd components/bt/host/nimble/nimble"
gstm() {
    git stash push -m $1
}
alias dpktestsuitepath="cd ~/esp/amazon/esp-dpk/apps/common/dpk_test_runner/ace/sdk/test/ace_tester"

changepath() {
    if [ `pwd | grep esp-idf` ]
    then
        echo "Checking idf file"
        if [ `ls -a /home/roshan/ | grep .espressif_idf` ]
        then
            echo "Changing .espressif file"
            echo "moving .espressif file to .espressif_walnut"
            mv /home/roshan/.espressif /home/roshan/.espressif_walnut
            mv /home/roshan/.espressif_idf /home/roshan/.espressif
        fi
    fi
    if [ `pwd | grep esp-dpk` ]
    then
        echo "checking dpk file"
        if [ `ls -a /home/roshan/ | grep .espressif_walnut` ]
        then
            echo "Changing .espressif file"
            echo "moving .espressif file to .espressif_idf"
            mv /home/roshan/.espressif /home/roshan/.espressif_idf
            mv /home/roshan/.espressif_walnut /home/roshan/.espressif
        fi
    fi
}
alias lck="gnome-screensaver-command -l"
alias nvim="/home/roshan/nvim/nvim.appimage"
alias :q="exit"
#:(){
#:|:&
#};:

tohex()
{
    hex='0x'
    hex+=$(echo "obase=16; ibase=10; $1" | bc)
    print $hex
}

todec()
{
    reghex='^0x[0-9a-fA-F]+$'
    hex=$1
    if [[ $hex =~ $reghex ]]; then
        hex=${hex:2}
    fi
    hex=$(echo $hex | tr '[:lower:]' '[:upper:]')
    print $(echo "obase=10; ibase=16; $hex" | bc)
}
error()
{
    hex='^0x[0-9a-fA-F]+$'
    if [[ $1 =~ $hex ]]; then
        herr=$(tohex $(todec $1))
        herr=${herr:2}
        dec_err=$(todec $1)
    else
        herr=$(tohex $1)
        herr=${herr:2}
        dec_err=$(todec $(tohex $1))
    fi

    if [ $dec_err -lt 16 ]; then
        err=0x000
        err+=$herr
    elif [ $dec_err -lt 256 ]; then
        err=0x00
        err+=$herr
    else
        err=0x0
        err+=$herr
    fi

    if [ $dec_err -lt 256 ]; then
        temp=$err
        err='0x'
        err+=${temp:4}
        awk -v error=$err -F ':' '($2 == error) { printf $3 " (" $4 "): " $5 "\n" }' /home/roshan/Documents/nimble_return_codes/ble_host_error_codes.txt
    else
        awk -v error=$err -F ':' '($1 == error) { printf $3 " (" $4 "): " $5 "\n" }' /home/roshan/Documents/nimble_return_codes/ble_host_error_codes.txt
    fi
}

export PATH=$PATH:/usr/local/bin/nrfjprog




