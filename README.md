# zsh config

Personal Zsh configuration for macOS, Debian, Ubuntu, and Raspberry Pi OS, with
a fast dependency-free prompt and a small set of command-line conveniences.

## Highlights

- Two-line prompt with Git status, exit status, and time
- Atuin-backed searchable history
- Autosuggestions and syntax highlighting
- Platform-aware aliases for Homebrew or apt, Git, bat, and eza
- No prompt framework or plugin manager

## Install

Clone the repo:

~~~sh
git clone https://github.com/chriscorbell/zsh.git ~/zsh
~~~

Install the packages for your platform.

On macOS with Homebrew:

~~~sh
brew bundle --file ~/zsh/Brewfile
~~~

On Debian, Ubuntu, or Raspberry Pi OS:

~~~sh
sudo apt update
sudo apt install zsh zsh-autosuggestions zsh-syntax-highlighting
~~~

Then link the configuration and start a fresh shell:

~~~sh
~/zsh/install.sh
exec zsh
~~~

Atuin, bat, and eza are optional. When installed, the configuration enables
them automatically (including Debian's `batcat` command name).

You can optionally make Zsh your login shell with
`chsh -s "$(command -v zsh)"`.

> [!NOTE]
> The installer backs up an existing Zsh configuration before linking this
> repo's .zshrc. Running it again is safe.

Because the configuration is linked rather than copied, future pulls take
effect in the next shell:

~~~sh
git -C ~/zsh pull
exec zsh
~~~
