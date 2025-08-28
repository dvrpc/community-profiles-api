from jinja2 import Environment, FileSystemLoader
env = Environment()


def format_number(num):
    if isinstance(num, int):
        return "{:,}".format(num)
    elif isinstance(num, float):
        return "{:,.1f}".format(num)
    return ""


env = Environment(loader=FileSystemLoader('.'))
env.filters['format_number'] = format_number
