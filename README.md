# OpenLDAP docker image based on centos7     

The image produces immutable containers, i.e. data volumes are outside the
containers COW file system. A container can be removed and re-created
any time without loss of data, because data is stored on data volumes.

## Configuration

1. Clone this repository and change into the directory 
2. Copy conf.sh.default to conf.sh
3. Run `git submodule update --init` and `cd dscripts && git checkout master && cd ..`
4. Modify conf.sh (optional)
5. dscripts/build.sh  # For local images only

## Usage

### Setup

    dscripts/run.sh -ir /tests/init_sample_config_xxx.sh    # initialize sample xxx configuration, set root-pw
    dscripts/run.sh -p # start slapd in daemon mode
    dscripts/exec.sh   # start interactive shell
        /tests/init_sample_data_xxx.sh    # initialize sample xxx data, see install/scripts/
        /tests/dump_testuser.sh   
        /tests/authn_testuser.sh   

### Operation

    cd <project root>
    dscripts/run.sh [-p] # start slapd in daemon mode
    dscripts/exec.sh -i  # open a second shell

## User Namespace Mapping

If the docker daemon does not support user namespace maaping, the image will run with the
default ldap uid/gid (55:55).