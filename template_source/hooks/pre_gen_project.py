#cookiecutter.json has only const values definitions in it, all derived values are defined here to discourage their editing and to
#not clutter cookiecutter.json with their generation.

{{ cookiecutter.update({"service_name_spaces": cookiecutter.service_name | replace('-', ' ')}) }}

{{ cookiecutter.update({"service_name_underscored": cookiecutter.service_name | replace('-', '_')}) }}
{{ cookiecutter.update({"process_name_underscored": cookiecutter.process_name | replace('-', '_')}) }}

{{ cookiecutter.update({"base_repo_name": cookiecutter.process_name_underscored + "_tf"}) }}
{{ cookiecutter.update({"services_repo_name": cookiecutter.process_name_underscored + "_services_tf"}) }}

{{ cookiecutter.update({"base_session_name": cookiecutter.base_repo_name.upper() | replace('-', '_')}) }}
{{ cookiecutter.update({"local_base_session_name": cookiecutter.base_session_name + "_LOCAL"}) }}

{{ cookiecutter.update({"services_session_name": cookiecutter.services_repo_name.upper() | replace('-', '_')}) }}
{{ cookiecutter.update({"local_services_session_name": cookiecutter.services_session_name + "_LOCAL"}) }}

#Since all user-defined values are filled only in cookiecutter.json - validate only their values.

import re
import sys
from collections import OrderedDict

def check_context(contexts):
    for context, rendered in contexts.items():
        ctx_rendered = rendered[0]
        regex = rendered[1]

        if not re.match(regex, ctx_rendered):
            print("ERROR: {0} is not a valid {1}".format(ctx_rendered, context))
            sys.exit(1)

def main():
    contexts = OrderedDict()

    contexts["process_name"] = (
        "{{cookiecutter.process_name}}",
        r"^([a-z]+-[a-z]+)+$"
    )

    contexts["service_name"] = (
        "{{cookiecutter.service_name}}",
        r"^([a-z]+-?[a-z]+)+$"
    )

    contexts["short_name"] = (
        "{{cookiecutter.short_name}}",
        r"^([a-z]+-?[a-z]+){2,20}$"
    )

    check_context(contexts)

if __name__ == "__main__":
    main()