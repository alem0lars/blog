Introduction
------------

Gentoo installation and configuration using `Ansible`_.

This guide assumes you already have a *working machine, allowed to remotely
connect* to the machine you're going to install Gentoo.

.. _`Ansible`: http://docs.ansible.com/ansible/index.html


Glossary
--------

From now on, the following naming conventions will be used:

- ``target``: the machine where Gentoo's going to be setup.
- ``workstation``: the machine connected to the ``target`` which performs the
  setup, executing remote commands.


Environment variables
---------------------

The following environment variables will be used throughout the guide and inside
the code snippets:

+---------------------+------------------------------------+
| Name                | Description                        |
+=====================+====================================+
| ``_WORKSTATION_IP`` | IP address of the ``workstation``. |
+---------------------+------------------------------------+
| ``_TARGET_IP``      | IP address of the ``target``.      |
+---------------------+------------------------------------+
| ``_TARGET_NAME``    | Logical name of the ``target``     |
|                     | (can be anything).                 |
+---------------------+------------------------------------+
| ``_INVENTORY_NAME`` | Name of the Ansible inventory      |
|                     | where your host is saved.          |
+---------------------+------------------------------------+


Steps
-----

+---+------------------------------------------+
| N | Description                              |
+===+==========================================+
| 1 | Prepare the ``target`` for installation: |
|   | boot live and make it reachable.         |
+---+------------------------------------------+
| 2 | Prepare the ``workstation`` to be able   |
|   | to setup the ``target``                  |
+---+------------------------------------------+
| 3 | Perform remote Gentoo installation       |
|   | from ``workstation`` to ``target``.      |
+---+------------------------------------------+
| 4 | Setup the ``target``'s OS, including     |
|   | software installation and configuration  |
+---+------------------------------------------+


Step 1: Prepare the target
--------------------------

The target environment needs to be prepared, this entails:

1. **Booting to a Gentoo minimal disk**
2. **Ensuring that there's networking available**
3. **Setting a root password**
4. **Enabling SSH**


1.1: Boot
~~~~~~~~~

Insert the Gentoo live-cd (or live-usb or whatever) and boot it.

In the boot prompt just press ``<enter>`` if you don't need any particular boot
argument; otherwise, `this`_ is the list of some boot options.

.. _`this`:
  https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Media#Booting_the_CD


1.2: Ensure that there's networking available
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

First of all, the networking may already work properly. Check it by running:

.. code-block:: shell-session

   # ping "www.google.com"
   # ping "${_WORKSTATION_IP}"

If network is unreachable and you use a DHCP server, try to restart it:

.. code-block:: shell-session

   # kill $(ps aux | grep dhcpcd | grep -v grep | awk '{print $2}')
   # /etc/init.d/dhcpcd restart
   * Stopping DHCP Client Daemon ...
   * Starting DHCP Client Daemon ...

If you don't use a DHCP server, you need to setup your network manually.

For more informations take a look at the `Gentoo Handbook`_.

.. _`Gentoo Handbook`:
   https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking


1.3: Set root password
~~~~~~~~~~~~~~~~~~~~~~

To change the password for the ``root`` user, run:

.. code-block:: shell-session

   # passwd
   New password:
   Retype new password:
   passwd: password updated successfully


1.4: Enable SSH
~~~~~~~~~~~~~~~

SSH is disabled by default, but it needs to be enabled so the ``workstation``
can remotely reach the ``target``.

To enable SSH, run:

.. code-block:: shell-session

   # sed -r -i 's/#PermitRootLogin\s*.+/PermitRootLogin yes/g' /etc/ssh/sshd_config
   # /etc/init.d/sshd start
   ssh-keygen: generating new host keys: RSA DSA ED25519
   * Starting sshd ...


Step 2: Prepare the workstation
-------------------------------

Install the following software:

+---------+-----------------------------+-------------------------------+
| Name    | Purpose                     | Installation                  |
+=========+=============================+===============================+
| Ansible | Perform remote installation | `Ansible installation guide`_ |
+---------+-----------------------------+-------------------------------+
| Git     | Get Ansible's installation  | `Git installation guide`_     |
|         | playbook                    |                               |
+---------+-----------------------------+-------------------------------+

Now *prepare a working directory* to be used throughout the installation
process:

.. code-block:: shell-session

  $ _work_dir=$(mktemp -d)
  $ cd "${_work_dir}"

Finally, check you are inside the temporary directory just created.

.. _`Ansible installation guide`:
  http://docs.ansible.com/ansible/intro_installation.html
.. _`Git installation guide`:
  https://git-scm.com/book/en/v2/Getting-Started-Installing-Git


2.1: Get the setup playbook
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell-session

  $ git clone git@github.com:alem0lars/setup
  $ cd setup


Step 3: Install the OS
----------------------

This step performs an automatic installation of Gentoo, supporting the following features:

- UEFI boot
- GPT partition table
- Encrypted drives
- LVM
- System-d

1. Add your host to an inventory, *with the role* ``gentoo``.
2. Customize the host variables to suit your needs (stored inside ``host_vars/${_TARGET_NAME}``).
3. From inside the ``setup`` directory, run:

.. code-block:: shell-session

   $ ansible-playbook --ask-pass -e install=true -i inventories/${_INVENTORY_NAME} site.yml
