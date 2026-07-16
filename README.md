# zsh config

Personal Zsh configuration with a fast, dependency-free prompt and a small set
of command-line conveniences.

## Highlights

- Two-line prompt with Git status, command duration, exit status, and time
- Atuin-backed searchable history
- Autosuggestions and syntax highlighting
- Short aliases for Homebrew, Git, bat, and eza
- No prompt framework or plugin manager

## Install

Clone the repo:

~~~sh
git clone https://github.com/chriscorbell/zsh.git ~/zsh
~~~

Install the optional command-line tools:

~~~sh
brew bundle --file ~/zsh/Brewfile
~~~

Link the configuration and start a fresh shell:

~~~sh
~/zsh/install.sh
exec zsh
~~~

> [!NOTE]
> The installer backs up an existing Zsh configuration before linking this
> repo's .zshrc. Running it again is safe.

Because the configuration is linked rather than copied, future pulls take
effect in the next shell:

~~~sh
git -C ~/zsh pull
exec zsh
~~~
