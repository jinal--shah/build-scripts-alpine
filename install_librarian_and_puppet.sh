#!/bin/sh
# vim: et smartindent sr sw=4 ts=4:
#
# install_librarian_and_puppet.sh
#
# N.B. BASH does not come with alpine by default (ash is default shell)
#
# - librarian-puppet requires puppet, git and ssh to be useful.
# - make is installed as a nicety, not a requirement.
#
# - NOTE: puppet requires a monkeypatch to a monkeypatch to work with ruby>=2.2
#         (see ruby -pie line below)
#
puppet_ver=${PUPPET_VERSION:-3.8.7}
gemstore=/usr/lib/ruby/gems/*/gems
safe_yaml_lib=$gemstore/puppet-$puppet_ver/lib/puppet/vendor/safe_yaml/lib/safe_yaml
file_to_patch=$safe_yaml_lib/syck_node_monkeypatch.rb

echo "$0 INFO: installing make, puppet3.x, ruby, librarian-puppet, git, ssh"

apk add --no-cache  \
    bash            \
    build-base      \
    git             \
    libc-dev        \
    libxml2-dev     \
    libxslt-dev     \
    linux-headers   \
    make            \
    openssh         \
    openssl         \
    openssl-dev     \
    postgresql-dev  \
    ruby            \
    ruby-dev        \
    ruby-io-console \
    ruby-irb        \
    ruby-rdoc       \
&& gem install --no-document --no-update-sources --clear-sources syck                                                                        \
&& gem install --no-document --no-update-sources --clear-sources -v $puppet_ver puppet                                                       \
&& gem install --no-document --no-update-sources --clear-sources librarian-puppet                                                            \
&& ruby -pi.bak -e 'gsub(/^( )*(Syck.module_eval monkeypatch *)$/, "\\1require \"syck\" if RUBY_VERSION >= \"2.2\"\n\\1\\2")' $file_to_patch \
&& for app in git puppet; do if $app --version >/dev/null; then echo "$0 INFO: $app appears to work"; else exit 1; fi; done                  \
&& if librarian-puppet version >/dev/null; then echo "$0 INFO: librarian-puppet appears to work"; else exit 1; fi                            #

