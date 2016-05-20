#!/bin/sh
# vim: et smartindent sr sw=4 ts=4:
#
# N.B. bash does not come with alpine by default (ash is default shell)
#
APP=${APP:-packer}
VERSION=${VERSION:-0.10.0}
BIN_DIR="/usr/local/bin"
ZIP="$BIN_DIR/${APP}.zip"
BASE_URI="https://releases.hashicorp.com/${APP}"
DOWNLOAD_URI="$BASE_URI/$VERSION/${APP}_${VERSION}_linux_amd64.zip"

echo "$0 INFO: installing $APP ($VERSION)"
echo "... downloading: $APP from $DOWNLOAD_URI"
wget -q -T 60 -O $ZIP $DOWNLOAD_URI
unzip $ZIP -d $BIN_DIR

rm $ZIP

if $APP --version | grep $VERSION 2>/dev/null
then
    echo "$0 INFO: installed $APP $VERSION successfully"
else
    echo "$0 INFO: failed to install"
    exit 1
fi

# ... install vim plugin if needed
if [[ -w /etc/vim/bundle ]]; then
    echo "$0 INFO: installing vim packer plugin"
    cd /etc/vim/bundle
    git clone https://github.com/hashivim/vim-packer.git
    rm -rf vim_packer/.git
    cd $OLDPWD
fi
exit 0

