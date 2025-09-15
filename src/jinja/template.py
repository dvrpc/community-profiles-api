from jinja2 import Environment, FileSystemLoader
from pathlib import Path
env = Environment()


def format_number(num):
    if isinstance(num, int):
        return "{:,}".format(num)
    elif isinstance(num, float):
        return "{:,.1f}".format(num)
    return ""


BASE_DIR = Path(__file__).resolve().parent
env = Environment(loader=FileSystemLoader(Path(BASE_DIR, 'templates')))
env.filters['format_number'] = format_number
