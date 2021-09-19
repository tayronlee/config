#!/usr/bin/env python3
import datetime
import os
import shutil
import subprocess
import stat


def get_real_path(path):
    return os.path.expandvars(os.path.expanduser(path))


def get_install_dir():
    install_dir = os.environ.get('INSTALL_DIR')
    if not install_dir:
        install_dir = os.path.dirname(os.path.abspath(__file__)) + "/.."
    return install_dir + "/"


def run_command(cmd, echo = 'on_error'):
    echo_values = ['yes', 'no', 'on_error']
    if echo not in echo_values:
        raise ValueError("Invalid echo option. Expected one of %s" % echo_values)

    result = subprocess.run(cmd, shell='bash', text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    ok = result.returncode == 0
    msg = [s for s in result.stdout.split('\n') if s]

    if ((echo == 'yes') or ((not ok) and (echo != 'no'))):
        if not ok: print ("*** ERROR ***")
        for line in msg:
            print(line)
        if not ok: print ("*** ERROR ***")

    return [ok, ' '.join(msg)]


def command_is_available(command):
    ok, _ = run_command('which ' + command, echo='no')
    return ok


def run_local_script(script_name):
    return run_command(get_install_dir() + "install_utils/" + script_name)


def backup_config(file_name, remove = True):
    if not os.path.exists(file_name):
        return
    backup_dir = get_real_path("~/.backup_config")
    if not os.path.isdir(backup_dir):
        os.mkdir(backup_dir)
    new_name = backup_dir + "/" + os.path.basename(file_name) + "_" + datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    if os.path.islink(file_name):
        shutil.copy(file_name, new_name)
        if remove:
            os.remove(file_name)
    else:
        shutil.move(file_name, new_name)
        if not remove:
            shutil.copy(new_name, file_name)


def files_are_different(file_a, file_b):
    ok, msg = run_command("diff " + file_a + " " + file_b, echo = 'no')
    return ((not ok) or (msg != ""))


def set_config_file(src_file, dst_file, link = True):
    if not files_are_different(src_file, dst_file):
        return
    backup_config(dst_file)
    if link:
        os.symlink(src_file, dst_file)
    else:
        with open(src_file, 'r') as src, open(dst_file, "w+") as dst:
            for line in src.readlines():
                dst.write(line + "\n")


def append_config_if(dst_file, text, function):
    if not os.path.isfile(dst_file):
        return [False, False]
    if not function(dst_file):
        return [True, False]

    backup_config(dst_file, remove = False)
    with open(dst_file, "a") as f:
        for line in text:
            f.write(line + "\n")
    return [True, True]


def create_exec_file(file_name, contents, overwrite = True):
    bin_dir = get_real_path("~/bin")
    if not os.path.isdir(bin_dir):
        os.mkdir(bin_dir)
    file_path = bin_dir + "/" + file_name
    if os.path.isfile(file_path):
        if overwrite:
            os.remove(file_path)
        else:
            return
    with open(file_path, "w") as f:
        for line in contents:
            f.write(line + "\n")
    st = os.stat(file_path)
    os.chmod(file_path, st.st_mode | stat.S_IEXEC)

