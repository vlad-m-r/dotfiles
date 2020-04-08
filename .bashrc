function git_url() {
        if [ -d ".git" ] || git rev-parse --git-dir > /dev/null 2>&1; then
                url=`git config --get remote.origin.url`
                echo " * $url"
        fi
}

function git_branch() {
        if [ -d ".git" ] || git rev-parse --git-dir > /dev/null 2>&1 ; then
                branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/\(.*\)/ \1/'`
                echo "$branch *"
        fi
}

function git_status() {
        if [ -d ".git" ] || git rev-parse --git-dir > /dev/null 2>&1 ; then
                gitstatus=`git status 2> /dev/null`
                output=""

                untracked=`git status --porcelain | sed -n -e 's/^?? //p' | wc -l`
                unstaged=`git diff --name-only | wc -l`
                staged=`git diff --name-only --staged | wc -l`

                if [ $untracked != 0 ]; then
                        output="Untracked: $untracked"
                fi

                if [ $unstaged != 0 ]; then
                        output="$output Unstaged: $unstaged"
                fi

                if [ $staged != 0 ]; then
                        output="$output Staged: $staged"
                fi

                echo "$output"
        fi
}

PS="""
\[\033[38;5;014m\]\t
\[\033[38;5;047m\] \u
\[\033[38;5;158m\]@
\[\033[38;5;035m\]\H 
\[\033[38;5;158m\][
\[\033[38;5;192m\]\w
\[\033[38;5;158m\]]
\[\033[38;5;051m\]\$(git_url)
\[\033[38;5;159m\]\$(git_branch) \[$(tput sgr0)\]
\[\033[48;5;001m\]\$(git_status)\[$(tput sgr0)\]
\[\033[38;5;050m\]\n\[$(tput sgr0)\]
\[\033[38;5;158m\]# > \[$(tput sgr0)\]
"""
export PS1=`echo "${PS}" | tr -d '\n'`
