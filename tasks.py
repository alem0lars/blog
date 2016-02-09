# ------------------------------------------------------------------------------
# IMPORTS ----------------------------------------------------------------------

import os, shutil, sys
if sys.version_info >= (3, 0):
    import socketserver
else:
    import SocketServer as socketserver

import invoke
from pelican.server import ComplexHTTPRequestHandler

# ------------------------------------------------------------------------------
# CONFIGURATION ----------------------------------------------------------------

# Local configuration.
ROOTDIR    = os.path.dirname(os.path.realpath(__file__))
OUTPUTDIR  = os.path.join(ROOTDIR, 'output')
SERVE_PORT = 8000

# Remote server configuration.
SSH_HOSTNAME = 'anapnea.net'
SSH_USERNAME = 'alem0lars'
SSH_PORT     = 22
WWWDIR       = '/home/www/alem0lars'
WWWDIRPERMS  = 755
WWWFILEPERMS = 644

# ------------------------------------------------------------------------------
# TASKS ------------------------------------------------------------------------

@invoke.task
def clean():
    """Remove generated files"""
    if os.path.isdir(OUTPUTDIR):
        shutil.rmtree(OUTPUTDIR)
        os.makedirs(OUTPUTDIR)

@invoke.task
def build(production=False):
    """Build site"""
    if production:
        invoke.run('pelican -s pelicanconf.py')
    else:
        invoke.run('pelican -s publishconf.py')

@invoke.task
def regenerate():
    """Automatically regenerate site upon file modification"""
    invoke.run('pelican -r -s pelicanconf.py')

@invoke.task
def serve():
    """Serve site at http://localhost:{port}/""".format(port=SERVE_PORT)
    os.chdir(OUTPUTDIR)
    class AddressReuseTCPServer(socketserver.TCPServer):
        allow_reuse_address = True
    server = AddressReuseTCPServer(('', SERVE_PORT), ComplexHTTPRequestHandler)
    sys.stderr.write('Serving on port {} ...\n'.format(SERVE_PORT))
    server.serve_forever()

@invoke.task(pre=[clean, build])
def rebuild():
    """Perform `clean` and `build`"""
    pass

@invoke.task(pre=[build, serve])
def reserve():
    """Perform `build` and `serve`"""
    pass

@invoke.task(pre=[clean, invoke.call(build, production=True)])
def publish():
    """Publish to production via SSH and RSync"""
    invoke.run(('rsync -e "ssh -p {port}" -P -rvzc --delete {outputdir}/ '
                '{username}@{hostname}:{wwwdir} --cvs-exclude').format(
                username=SSH_USERNAME, hostname=SSH_HOSTNAME, port=SSH_PORT,
                outputdir=OUTPUTDIR, wwwdir=WWWDIR))

    # Fix permissions.
    _remotecommand([
        'find {wwwdir} -type d -exec chmod {dirperms} {{}} +'.format(
            wwwdir=WWWDIR, dirperms=WWWDIRPERMS),
        'find {wwwdir} -type f -exec chmod {fileperms} {{}} +'.format(
            wwwdir=WWWDIR, fileperms=WWWFILEPERMS)])

# ------------------------------------------------------------------------------
# PRIVATE UTILITIES ------------------------------------------------------------

def _remotecommand(command):
    """Run a remote command (using SSH)"""
    if not isinstance(command, list):
        command = [command]

    for cmd in command:
        print('Executing command: {}'.format(cmd))
        invoke.run('ssh {username}@{hostname} -p {port} "{command}"'.format(
                   username=SSH_USERNAME, hostname=SSH_HOSTNAME, port=SSH_PORT,
                   command=cmd))

# ------------------------------------------------------------------------------
# vim: set filetype=python :
