import os
import shutil

ALL_ENVS = [
    "alpha",
    "dev",
    "staging",
    "prod",
    "dr"
]

def get_envs():
    envs = "{{ cookiecutter.envs }}"

    if envs == "All":
        envs = ALL_ENVS
    else:
        envs = envs.split("|")
        wrong_envs = list(set(envs) - set(ALL_ENVS))

        if wrong_envs:
            raise ValueError('Invalid env(s) specified in cookiecutter.json: ', wrong_envs)

    return envs

def del_file_in_base(base_repo_dir, is_needed, filename):
    if is_needed == "false":
        os. remove(os.path.join(base_repo_dir, "modules", "silo", filename))

def del_file_in_service(services_repo_dir, is_needed, filename):
    if is_needed == "false":
        os. remove(os.path.join(services_repo_dir, "modules", "apps", "{{ cookiecutter.service_name }}", filename))

def create_all_symlinks(envs, base_repo_dir, services_repo_dir):
    files = [
        "initialize.tf",
        "main.tf",
        "variables.tf"
    ]

    create_symlinks(envs, base_repo_dir, files + ["outputs.tf"])
    create_symlinks(envs, services_repo_dir, files)

def create_symlinks(envs, repo_dir, files):
    for env_ in envs:
        os.chdir(os.path.join(repo_dir, "env-" + env_))

        for file_ in files:
            try:
                os.symlink(os.path.join("..", file_), file_)
            except Exception as e:
                raise e

        os.chdir(repo_dir)

def remove_all_envs(envs, base_repo_dir, services_repo_dir):
    envs_to_remove = list(set(ALL_ENVS) - set(envs))

    remove_envs(base_repo_dir, envs_to_remove)
    remove_envs(services_repo_dir, envs_to_remove)

def remove_envs(repo_dir, envs_to_remove):
    for env_ in envs_to_remove:
        dir_to_remove = os.path.join(repo_dir, "env-" + env_)

        try:
            shutil.rmtree(dir_to_remove)
        except Exception as e:
            raise e

def main():
    cwd = os.getcwd()
    base_repo_dir = os.path.join(cwd, "{{ cookiecutter.base_repo_name }}")
    services_repo_dir = os.path.join(cwd, "{{ cookiecutter.services_repo_name }}")

    envs = get_envs()

    del_file_in_service(services_repo_dir, "{{ cookiecutter.is_es }}", "es.tf")
    del_file_in_service(services_repo_dir, "{{ cookiecutter.is_sqs }}", "messaging.tf")
    del_file_in_service(services_repo_dir, "{{ cookiecutter.is_dynamo }}", "dynamo.tf")

    del_file_in_base(base_repo_dir, "{{ cookiecutter.is_apigw }}", "apigw.tf")
    del_file_in_service(services_repo_dir, "{{ cookiecutter.is_apigw }}", "apigw.tf")

    del_file_in_base(base_repo_dir, "{{ cookiecutter.is_base_rds }}", "rds.tf")
    del_file_in_service(services_repo_dir, "{{ cookiecutter.is_service_rds }}", "rds.tf")

    del_file_in_base(base_repo_dir, "{{ cookiecutter.ec_base.create }}", "ec.tf")
    del_file_in_service(services_repo_dir, "{{ cookiecutter.ec_service.create }}", "ec.tf")
    
    #cookiecutter replaces symlinks with file contents - fix it by not having any symlinks in the template and creating them afterwards
    create_all_symlinks(envs, base_repo_dir, services_repo_dir)

    #remove envs, which are not needed
    remove_all_envs(envs, base_repo_dir, services_repo_dir)

if __name__ == "__main__":
    main()