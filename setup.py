from setuptools import setup, find_packages

def read_readme():
    with open("README.md") as fp:
        long_desc = fp.read()
    return long_desc

setup(
    name = "quickserve",
    version = "0.0.1",
    author = "Team Xeon",
    description = ("Quickly build inference engines from jupyter notebooks and deploy on web and edge in 3 lines of code"),
    license = "MIT",
    long_description = read_readme(),
    url = "https://github.com/pranjaldatta/quickserve",

    packages = find_packages(),
    include_package_data = True,
)