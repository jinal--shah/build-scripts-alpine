# build-scripts-alpine

## What?

Self contained scripts that should run under the default sh on Alpine, ash.

Each script is intended to install _something_ taking up as little room
on disk as possible.

## Why?

Alpine is tiny. Seems a shame to bloat it up unnecessarily with lazy 
installs of other software.

## How?

The scripts generally delete all unneeded files and avoid file-system caches
for package managers etc.

## ... Docker

For creating containers using alpine as a base, these scripts
will do stuff without polluting your Dockerfile or equivalent
with lots of commands.
  
This keeps your Dockerfile readable but also allows for more complex logic during the
build process inside your scripts without the creation of disk-consuming 
additional image layers.

### Example Dockerfile

        FROM gliderlabs/alpine:3.3
        MAINTAINER jinal--shah <jnshah@gmail.com>
        LABEL Name="librarian_packer_aws" Vendor="sortuniq" Version="0.0.1" \
            Description="assemble my_project using librarian-puppet and Make to packerise for aws"

        ARG PACKER_VERSION

        ENV APP="packer"                            \
            VERSION=$PACKER_VERSION                 \
            SCRIPT_DIR_LOCAL="build-scripts-alpine" \
            SCRIPT_DIR="/var/tmp/scripts"

        COPY $SCRIPT_DIR_LOCAL $SCRIPT_DIR/

        RUN chmod a+x $SCRIPT_DIR/*                        \
            && $SCRIPT_DIR/install_librarian_and_puppet.sh \
            && $SCRIPT_DIR/install_packer.sh               \
            && $SCRIPT_DIR/install_awscli.sh               \
            && rm -rf /var/cache/apk/* $SCRIPT_DIR         \
            && git clone http://github.com/me/my_project   \
            && cd my_project

        CMD ["/usr/bin/make", "-C", "my_project", "build"]


