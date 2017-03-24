RecoverX Cookbook
=================
This installs and configures Datos.io RecoverX

Requirements
------------
#### Chef
Chef version 0.11.0+ and Ohai 0.7.0+ are required.

#### Platform
- Ubuntu Trusty 14.04

Attributes
----------

Usage
-----
#### recoverx::recoverx
This is the recipe that is used to set up the RecoverX cluster.

Set up a role for the RecoverX cluster. Some notes about the role:

* For the SSH settings to take effect, the `openssh` cookbook must be installed

```ruby
name 'recoverx-mongodb-server'
description 'MongoDB backup role for RecoverX node'
run_list(
  'recipe[recoverx::recoverx]',
  'recipe[openssh]'
)

default_attributes(
  datos: {
    recoverx: {
      node_type: 'mongodb',
      version: '1.2.10_2017-03-09-20-11',
      download_url: 'https://s3.amazonaws.com/com.mycompany.packages/datos_1.2.10_2017-03-09-20-11_centos6.tar.gz',
      storage_type: 's3'
    },
    mongodb: {
      mongodb_group: 'mongodb'
    }
  },
  openssh: {
    server: {
      'max_sessions': '500',
      'max_startups': '500:1:500'
    }
  }
)
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Authors
-------
* Author:: Eric Lubow (@elubow)
