# make4py Framework for Python based Tools

This framework is intended as a common base for small python tools that are
distributed as binaries created with [pyInstaller]. It supports the development
by providing:

  - A common interface using the good old `make`.
  - Style checking using [pylint], [pycodestyle] and [flake8].
  - Type checking using [mypy].
  - Testing (unit and functional tests) using [pytest] with code coverage reporting.
  - Version freezing of pip-dependencies using [pip-tools].
  - Providing a virtual environment using [venv].
  - Documentation and man-page using [sphinx].
  - Multi-platform support using [docker] for Linux platforms and [vagrant] for Windows.
  - VSCode support
  - Generating the distributables using [pyInstaller].


## Usage

To use this framework, you should add it as a git submodule to your repository.


[pyInstaller]: https://pyinstaller.org/en/stable/
[pylint]: https://www.pylint.org/
[pycodestyle]: https://pycodestyle.pycqa.org/en/latest/intro.html
[flake8]: https://flake8.pycqa.org/en/latest/
[mypy]: https://mypy-lang.org/
[pytest]: https://pytest.org/
[pip-tools]: https://github.com/jazzband/pip-tools
[venv]: https://docs.python.org/3/library/venv.html
[sphinx]: https://www.sphinx-doc.org/en/master/
[docker]: https://www.docker.com/
[vagrant]: https://www.vagrantup.com/
