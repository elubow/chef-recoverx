RecoverX Cookbook
=================
This installs and configures Datos.io RecoverX

Requirements
------------
#### Chef
Chef version 0.10.10+ and Ohai 0.6.12+ are required.

#### Platform
- Ubuntu Trusty 14.04

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### recoverx::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['recoverx']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### recoverx::recoverx
This is the recipe that is used to set up the RecoverX cluster.

Set up a role for the RecoverX cluster. Some notes about the role:

* For the SSH settings to take effect, the `ssh` cookbook must be installed

```ruby
name 'recoverx-mongodb-server'
description 'MongoDB backup role for RecoverX node'
run_list(
  'recipe[recoverx::recoverx]',
  'recipe[recoverx::mongo]'
)

default_attributes(
  ebs: {
    directory: '/data',
    size: 300,
    volume_type: 'gp2',
    filesystem: 'xfs',
    volume_name: 'MongoDB Data'
  },
  datos: {
    recoverx: {
      node_type: 'mongodb',
      version: '1.2.10_2017-03-09-20-11',
      download_url: 'https://s3.amazonaws.com/com.simplereach.packages/datos_1.2.10_2017-03-09-20-11_centos6.tar.gz',
      storage_type: 's3'
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

#### recoverx::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `recoverx` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[recoverx]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Authors
-------
* Author:: Eric Lubow (@elubow)
