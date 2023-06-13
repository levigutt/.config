# vim or bust
export EDITOR=vim
export VISUAL=$EDITOR
bindkey -v
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line
# allow backspace beyond start
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# aliases
alias ll='ls -la'
alias l.='ls -d .*'
alias tcd='function _tcd(){ cd $(tcd.pl -return $*) };_tcd'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%dT%T"'
alias sha1='shasum'
alias sha256='shasum -a 256'
alias expr=$'perl -wl -e \'print eval "@ARGV"\''
alias repl=$'perl -wn -e \'BEGIN{undef @ARGV; print ">"}
chomp;
print eval;
print STDERR $@ =~ s/ at \\(eval \\d+\\) line \\d+, <> line \\d+\\.\\n?/./r if $@;
print "\n>";\''

# paths
export PATH=/opt/homebrew/bin:$PATH
export PATH=/Users/levi/go/bin:$PATH
PATH="/Users/levi/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/levi/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/levi/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/levi/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/levi/perl5"; export PERL_MM_OPT;
export PATH=/Users/levi/utils:$PATH
