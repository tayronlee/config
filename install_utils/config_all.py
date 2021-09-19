#!/usr/bin/env python3
import utils

def main():
    config_bash()
    config_tmux()
    config_vim()
    config_git()


def config_bash():
    print("Configuring bash...")

    bash_config = ["if [ -f ~/.bashrc.tayron ]; then",
                   "    . ~/.bashrc.tayron",
                   "fi"]
    def not_configured(file_name):
        ok, msg = utils.run_command("grep \"bashrc.tayron\" " + file_name, echo = 'no')
        return not msg

    exist, _ = utils.append_config_if(utils.get_real_path("~/.bashrc"), bash_config, not_configured)
    if not exist:
        utils.set_config_file(get_config_dir() + ".bashrc" , utils.get_real_path("~/.bashrc"))
    utils.set_config_file(get_config_dir() + ".inputrc" , utils.get_real_path(".inputrc"))
    utils.set_config_file(get_config_dir() + ".bashrc.tayron" , utils.get_real_path(".bashrc.tayron"))
    ok, msg = utils.run_command("grep tayron.*bin/bash /etc/passwd", echo = 'no')
    if not msg:
        utils.run_command("sudo usermod --shell /bin/bash tayron")


def config_tmux():
    print("Configuring tmux...")
    utils.set_config_file(get_config_dir() + ".tmux.conf" , utils.get_real_path(".tmux.conf"))


def config_vim():
    print("Configuring vim...")
    utils.backup_config(utils.get_real_path("~/.vim"))
    utils.set_config_file(get_config_dir() + ".vimrc" , utils.get_real_path(".vimrc"))
    utils.run_command("git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim")
    print("Configuring vim plugins...")
    utils.run_command("vim -E +PluginInstall +qall", echo='no')
    utils.set_config_file(get_config_dir() + "one_tayron.vim" , utils.get_real_path("~/.vim/bundle/lightline.vim/autoload/lightline/colorscheme/one_tayron.vim"))


def config_git():
    print("Configuring git...")
    utils.run_command("git config --global user.name \"tayronlee\"")
    utils.run_command("git config --global user.email \"tayron@hotmail.com\"")
    utils.run_command("git config --global core.editor vim")


def get_config_dir():
    return utils.get_install_dir() + "local/"


if __name__ == "__main__":
    main()

