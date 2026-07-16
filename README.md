# zsh config

Personal Zsh configuration for macOS, Debian, Ubuntu, and Raspberry Pi OS, with
a fast dependency-free prompt and a small set of command-line conveniences.

## Highlights

- Two-line prompt with Git status, command duration, exit status, and time
- Atuin-backed searchable history
- Autosuggestions and syntax highlighting
- Platform-aware aliases for Homebrew or apt, Git, bat, and eza
- No prompt framework or plugin manager

## Install

Clone the repo:

~~~sh
git clone https://github.com/chriscorbell/zsh.git ~/zsh
~~~

Install Zsh, plugins, and the optional command-line tools available for your
platform, then link the configuration:

~~~sh
~/zsh/install.sh --packages
~~~

On macOS this uses Homebrew. On Debian, Ubuntu, and Raspberry Pi OS it uses apt
and asks for sudo when necessary. Tools that are not available from the
configured apt repositories are skipped; the configuration works without them.

Start a fresh shell:

~~~sh
exec zsh
~~~

To link only, without installing packages, run `~/zsh/install.sh` instead. You
can optionally make Zsh your login shell with `chsh -s "$(command -v zsh)"`.

> [!NOTE]
> The installer backs up an existing Zsh configuration before linking this
> repo's .zshrc. Running it again is safe.

Because the configuration is linked rather than copied, future pulls take
effect in the next shell:

~~~sh
git -C ~/zsh pull
exec zsh
~~~
