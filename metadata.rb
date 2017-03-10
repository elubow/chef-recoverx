name             'recoverx'
maintainer       'EBL'
maintainer_email 'eric@lubow.org'
license          'All rights reserved'
description      'Installs/Configures Datos RecoverX'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

supports 'ubuntu'

depends 'ark', '>=0.1.0'
depends 'hostsfile'
depends 'limits', '>=1.0.0'
depends 'ssh'
depends 'sudo'

provides 'service::recoverx'

source_url 'https://github.com/elubow/recoverx'
issues_url 'https://github.com/elubow/recoverx/issues'
chef_version '>= 11.0' if respond_to?(:chef_version)
