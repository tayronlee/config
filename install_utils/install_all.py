#!/usr/bin/env python3
import os
import subprocess

#vim
#tmux
#git
#fzf
#bat

packages = [ {'name':'vim', 'commands':['vim'], 'version_cmd':'vim --version | head -n 1'},
             {'name':'tmux', 'commands':['tmux'], 'version_cmd':'tmux -V'},
             {'name':'git', 'commands':['git'], 'version_cmd':'git --version'},
             {'name':'bat', 'commands':['bat', 'batcat'], 'version_cmd':'bat --version'},
             #{'name':'cargo', 'commands':['cargo'], 'version_cmd':'cargo --version'},
             {'name':'fzf', 'commands':['fzf'], 'version_cmd':'echo fzf `fzf --version`'} ]


def main():
    to_install = []
    for pkg in packages:
        if any(map(command_is_available, pkg['commands'])):
            run_command(pkg['version_cmd'], echo='yes')
        else:
            to_install.append(pkg['name'])

    if not to_install:
        exit()

    ok, upgrade_command = run_local_script('get_upgrade_cmd')
    if not ok:
        exit()

    ok, install_command = run_local_script('get_install_cmd')
    if not ok:
        exit()

    ok, _ = run_command(upgrade_command)
    if not ok:
        exit()

    for pkg_name in to_install:
        run_command(install_command + " " + pkg_name, echo='yes')


def command_is_available(command):
    ok, _ = run_command('which ' + command, echo='no')
    return ok


def run_command(cmd, echo = 'on_error'):
    echo_values = ['yes', 'no', 'on_error']
    if echo not in echo_values:
        raise ValueError("Invalid echo option. Expected one of %s" % echo_values)

    result = subprocess.run(cmd, shell='bash', text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    ok = result.returncode == 0
    msg = result.stdout.replace('\n','')

    if (not ok) and (echo != 'no'):
        print('Error: ' + msg)
    elif (echo == 'yes'):
        print(msg)

    return [ok, msg]


def run_local_script(script_name) :
    base_path = os.path.dirname(os.path.abspath(__file__)) + "/"
    return run_command(base_path + script_name)


if __name__ == "__main__":
    main()
