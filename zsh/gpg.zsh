[ -f ~/.gnupg/gpg-agent-info ] && source ~/.gnupg/gpg-agent-info
if [ ! -z $GPG_AGENT_INFO ] && [ -S ${GPG_AGENT_INFO%%:*} ]; then
  export GPG_AGENT_INFO
else
  eval $( gpg-agent --daemon --write-env-file ~/.gnupg/gpg-agent-info )
fi
