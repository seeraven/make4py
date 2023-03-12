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

To use this framework, you should add it as a git submodule to your repository:

    $ git submodule add https://github.com/seeraven/make4py .make4py
    $ git commit -m "feature: Added make4py submodule."

Then you should copy the contents of the `templates` directory into your project
repository and adjust the following files:

  - `Makefile`
  - `pyproject.toml`
  - The documentation and manpage of the `doc` directory, especially the
    reference to the API documentation in `doc/source/development.rst`.

The layout of the sources is as follows:

  - `src` contains your main script and all your custom modules.
  - `test/unittests` contains the unit tests.
  - `test/functional_tests` contains the functional tests. With functional tests
     we refer to tests of the main script from a user perspective, without testing
     any internas (as they should already be tested by the unit tests). The
     functional tests can also be used to test the generated distributables.

Once everything is set up, you should be able to get the help by calling

    $ make help
    $ make help-all


## Configuration of your Project

You can overwrite the defaults of make4py by set the corresponding variable *before*
including the `.make4py/make4py.mk` file in your `Makefile`. The following configuration
variables are supported:

| Makefile Variable      | Default Value                 | Description                                                      |
|------------------------|-------------------------------|------------------------------------------------------------------|
| `ALL_TARGET`           | `help`                        | The default target run when no target is specified.              |
| `BUILD_DIR`            | `build`                       | The subdirectory used for venvs and pyinstaller envs.            |
| `UBUNTU_DIST_VERSIONS` | `18.04 20.04 22.04`           | List of Ubuntu versions to support.                              |
| `PYCODESTYLE_CONFIG`   | `.make4py/.pycodestyle`       | The configuration file for [pycodestyle].                        |
| `SRC_DIRS`             | `src test`                    | A list of directories containing the source files.               |
| `DOC_MODULES`          | all modules under `src`       | A list of modules to document.                                   |
| `UNITTEST_DIR`         | `test/unittests`              | The directory of the unit tests.                                 |
| `FUNCTEST_DIR`         | `test/functional_tests`       | The directory of the functional tests.                           |
| `RELEASE_DIR`          | `releases`                    | The subdirectory used to store the distributables.               |
| `PYINSTALLER_ARGS`     | `--clean --onefile`           | Arguments to [pyInstaller].                                      |
| `USE_VENV`             | `1`                           | If set to `1` a venv is used (highly recommended).               |
| `PIP_DEPS_DIR`         | `pip_deps`                    | The subdirectory used to store the pip-dependencies.             |
| `DOCKER_STAMPS_DIR`    | `.dockerstamps`               | The subdirectory used to store the stamps for the docker images. |
| `MAKE4PY_DOCKER_IMAGE` | `make4py`                     | The name of the generated docker images.                         |


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
