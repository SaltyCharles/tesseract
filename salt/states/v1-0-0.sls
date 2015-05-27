###############################################
##
##   SaltStack Enterprise WebUI deployment
##   Version 1.0.0 
##
###############################################


##############################
##
## Create paths
##
##############################

# Create staging folders
"Create stage file location":
    file.directory:
        - name: "/stage"
        - mode: 755

# Create Salt State folders
"Create salt state location":
    file.directory:
        - name: "/srv/salt"
        - mode: 755
        - makedirs: true

# Create Salt Config folders
"Create salt config location":
    file.directory:
        - name: "/etc/salt/master.d"
        - mode: 755
        - makedirs: true


##############################
##
## File Downloads
##
##############################

# Download bootstrap for pip install
"Download PIP bootstrap":
    cmd.run:
        - name: "wget https://bootstrap.pypa.io/get-pip.py"
        - cwd: "/stage"
        - require:
            - file: "Create stage file location"

# Download SSE tar file
"Download SSE tar file":
    cmd.run:
        - name: "wget https://jenkins-production.saltstack.com/e-pkg/srv.tgz"
        - cwd: "/stage"
        - require:
            - file: "Create stage file location"

# Download bootstrap for salt install
"Download Salt bootstrap":
    cmd.run:
        - name: "curl -L https://bootstrap.saltstack.com -o install_salt.sh"
        - cwd: "/stage"
        - require:
            - file: "Create stage file location"



##############################
##
## Managed files
##
##############################

# Deploy SSE Config
"Deploy SSE Config":
    file.managed:
        - source: salt://sse/sse-v1-0-0.conf
        - name: /etc/salt/master.d/sse.conf
        - user: root
        - group: root
        - mode: 644
        - require:
            - file: "Create salt config location"


##############################
##
## Bootstrap installs
##
##############################

# Execute PIP bootstrap script
"Execute PIP bootstrap":
    cmd.run:
        - name: "python get-pip.py"
        - cwd: "/stage"
        - require:
            - cmd: "Download PIP bootstrap"

# Execute Salt bootstrap script
"Execute Salt bootstrap":
    cmd.run:
        - name: "sh install_salt.sh -M -P git v2015.5.0"
        - cwd: "/stage"
        - require:
            - cmd: "Download Salt bootstrap"


# Extract files for SSE
"Extract files for SSE":
    cmd.run:
        - name: "tar -xvf srv.tgz -C /"
        - cwd: "/stage"
        - require:
            - cmd: "Download SSE tar file"

##############################
##
## Create Certificate files
##
##############################

"create cert for salt-api":
  module.run:
    - name: tls.create_self_signed_cert
    - tls_dir: salt_api
    - require:
      - pip: "Install PyOpenSSL"

"Install PyOpenSSL":
  pip.installed:
    - name: PyOpenSSL
    - exists_action: i
    - reload_modules: True
    - require:
        - cmd: "Execute PIP bootstrap"

##############################
##
## Package installs
##
##############################

# Install Python MySQL
"Install Python MySQL plugin":
    pkg.installed:
        - name: python-mysqldb

##############################
##
## User creation
##
##############################

# Create the Ubuntu User
"Create Ubuntu User":
  user.present:
    - fullname: ubuntu
    - name: ubuntu
    - shell: '/bin/bash'
    - password: '$1$xyz$K1m3vkKZXL1p36LriRJHK0'
    - optional_groups:
      - wheel
      - admin
      - sudo


