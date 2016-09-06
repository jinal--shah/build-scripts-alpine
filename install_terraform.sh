#!/bin/bash
# vim: et smartindent sr sw=4 ts=4:
#
# N.B. BASH does not come with alpine by default (ash is default shell)
#
APP=${APP:-terraform}
VERSION=${VERSION:-0.7.3}
BIN_DIR="/usr/local/bin"
ZIP="$BIN_DIR/${APP}.zip" 
BASE_URI="https://releases.hashicorp.com/${APP}"
DOWNLOAD_URI="$BASE_URI/$VERSION/${APP}_${VERSION}_linux_amd64.zip"

echo "... downloading: $APP $VERSION"
wget -q -T 60 -O $ZIP $DOWNLOAD_URI
unzip $ZIP -d $BIN_DIR

if $APP --version | grep $VERSION 2>/dev/null
then
    echo "$0 INFO: installed $APP $VERSION successfully"
else
    echo "$0 INFO: failed to install"
    exit 1
fi

rm $ZIP

# ... install vim plugin if needed
if [[ -w /etc/vim/bundle ]]; then
    echo "$0 INFO: installing vim terraform plugin"
    cd /etc/vim/bundle
    git clone https://github.com/hashivim/vim-terraform.git
    rm -rf vim-terraform/.git
    cd $OLDPWD
fi
exit 0
