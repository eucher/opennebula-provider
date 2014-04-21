# OpenNebula::Provider

[![Gem Version](https://badge.fury.io/rb/opennebula-provider.png)](https://rubygems.org/gems/opennebula-provider) 

This is a Vagrant 1.5 plugin that add an OpenNebula provider to Vagrant.

**NOTE:** This plugin requires occi-api gem and works with rOCCI-server.

## Features

* Boot OpenNebula instances
* SSH into instances
* Provision the instances with any built-in Vagrant provisioner
* Minimal synced folder support via `rsync`

## Installation

```
$ vagrant plugin install opennebula-provider
...
$ vagrant up --provider=opennebula
...
```

## Box Format

TODO: Write box format creation instruction here.

## Usage

```
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :opennebula do |one, override|
    one.endpoint = 'http://rOCCI-server:PORT'
    one.username = 'YOUR NAME'
    one.password = 'YOUR PASSWORD'
    one.os_tpl = 'OS template'
  end
end
```

## Configuration

* `endpoint` - rOCCI server url
* `username` - OpenNebula username
* `password` - OpenNebula password
* `auth` - OpenNebula authorization method, default: basic
* `os_tpl` - OpenNebula os template
* `resource_tpl` - OpenNebula resource template, default: small

## Contributing

1. Fork it ( http://github.com/<my-github-username>/opennebula-provider/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
