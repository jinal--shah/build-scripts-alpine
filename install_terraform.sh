#!/bin/bash
# vim: et smartindent sr sw=4 ts=4:
#
# N.B. BASH does not come with alpine by default (ash is default shell)
#
APP=${APP:-terraform}
VERSION=${VERSION:-0.6.15}
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

# ... clean up

# ... lots of terraform binaries we just don't use.
#     so delete all but the ones we do ...
terraform_to_keep="
terraform
terraform-provider-aws
terraform-provider-consul
terraform-provider-docker
terraform-provider-github
terraform-provider-null
terraform-provider-template
terraform-provider-terraform
terraform-provider-tls
terraform-provisioner-file
terraform-provisioner-local-exec
terraform-provisioner-remote-exec
"

terraform_bins=$(
    ls -1 $BIN_DIR/terraform-*   \
    | xargs -n1 -i{} basename {} \
    | sort                       \
    | uniq
)

terraform_to_keep=$(
    echo "$terraform_to_keep" \
    | sort                    \
    | uniq                    \
    | sed '/^$/d'
)

delete_these=$(
    comm -13 <(echo "$terraform_to_keep") <(echo "$terraform_bins") \
    | sed -e "s#^#$BIN_DIR/#"
)

rm $ZIP $delete_these

# ... install vim plugin if needed
if [[ -w /etc/vim/bundle ]]; then
    echo "$0 INFO: installing vim terraform plugin"
    cd /etc/vim/bundle
    git clone https://github.com/hashivim/vim-terraform.git
    rm -rf vim-terraform/.git
    cd $OLDPWD
fi
exit 0
