#!/usr/bin/env python3
import utils

packages = [ {'name':'vim',
              'commands':['vim'],
              'version_cmd':'vim --version | head -n 1'},
             {'name':'tmux',
              'commands':['tmux'],
              'version_cmd':'tmux -V'},
             {'name':'git',
              'commands':['git'],
              'version_cmd':'git --version'},
             {'name':'htop',
              'commands':['htop'],
              'version_cmd':'htop --v | head -n 1'},
             {'name':'bat',
              'commands':['bat', 'batcat'],
              'version_cmd':'bat --version'},
             {'name':'fzf',
              'commands':['fzf'],
              'version_cmd':'echo fzf `fzf --version`'} ]


def main():
    install_packages()
    create_execs()


def install_packages():
    to_install = []
    for pkg in packages:
        if any(map(utils.command_is_available, pkg['commands'])):
            ok, msg = utils.run_command(pkg['version_cmd'])
            print("Found " + msg)
        else:
            to_install.append(pkg['name'])

    if not to_install:
        exit()

    ok, update_command = utils.run_local_script('get_update_cmd')
    if not ok:
        exit()

    ok, install_command = utils.run_local_script('get_install_cmd')
    if not ok:
        exit()

    print("Updating...")
    ok, _ = utils.run_command(update_command)
    if not ok:
        exit()

    for pkg_name in to_install:
        print("Installing " + pkg_name + "...")
        utils.run_command(install_command + " " + pkg_name)


def create_execs():
    utils.create_exec_file("copy", ["#!/bin/bash",
                                    "if [ $# -eq 0 ]; then",
                                    "  xclip -i -sel clipboard 2>&1 > /dev/null",
                                    "  #/mnt/c/Windows/system32/clip.exe 2>&1 > /dev/null",
                                    "else",
                                    "  echo $@ | xclip -i -sel clipboard 2>&1 > /dev/null",
                                    "  #echo -n $@ | /mnt/c/Windows/system32/clip.exe 2>&1 > /dev/null",
                                    "fi"])
    utils.create_exec_file("paste", ["#!/bin/bash",
                                     "xclip -o -sel clipboard",
                                     "#powershell.exe -c \"& {Get-Clipboard -raw}\" | dos2unix | sed -z '$ s/\\n$//'"])
    ok, update_command = utils.run_local_script('get_update_cmd')
    if ok:
        utils.create_exec_file("update", ["#!/bin/bash",
                                          update_command + " && \\",
                                          "vim +PluginUpdate +qall && \\",
                                          "sudo snap refresh"])


if __name__ == "__main__":
    main()

