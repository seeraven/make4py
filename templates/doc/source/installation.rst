Installation
============

The following installation methods are provided:

* a self-contained executable generated using PyInstaller_


Installation as the Self-Contained Executable on Linux
------------------------------------------------------

|project_name| is distributed as a single executable packaged using PyInstaller_.
So all you have to do is to download the latest executable from the release page
|release_url| and copy it to a location of your choice, for example
:code:`/usr/local/bin`.

It is recommended to rename the binary to |binary| and ensure it has set the
executable bit:

.. parsed-literal::

    $ sudo chmod +x /usr/local/bin/|project_name|

Then call |project_name| on the command line to start it.


Installation as the Self-Contained Executable on Windows
--------------------------------------------------------

Download the latest executable for Windows from the release page |release_url|.
Copy the executable to a location of your choice, e.g., into :code:`C:\Windows`.

Then start |project_name| by double-clicking it.


Configuration
-------------

<INSERT DESCRIPTION HERE>


.. _PyInstaller: http://www.pyinstaller.org/
