# OpenNebula::Provider

[![Gem Version](https://badge.fury.io/rb/opennebula-provider.svg)](https://rubygems.org/gems/opennebula-provider)

This is a Vagrant 1.5+ plugin that add an OpenNebula provider to Vagrant.

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

## Usage

```
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :opennebula do |one, override|
    one.endpoint = 'http://opennebula.server:2633/RPC2'
    one.username = 'YOUR NAME'
    one.password = 'YOUR PASSWORD'
    one.template_id = 123
    one.title = 'my vm'
  end
end
```

## Configuration

* `endpoint` - OpenNebula RPC endpoint (like 'http://127.0.0.1:2633/RPC2')
* `username` - OpenNebula username
* `password` - OpenNebula password
* `template_id` - OpenNebula template id
* `template_name` - OpenNebula template name
* `title` - OpenNebula instance name
* `memory` - An instance memory in MB
* `cpu` - An instance cpus
* `vcpu` - An instance virtual cpus

You can use `template_name` parameters instead `template_id` to define template by name and if there are multiple templates with the same name will be used the most recent. 

You can use ONE_USER, ONE_PASSWORD, ONE_XMLRPC (or ONE_ENDPOINT) environment variables
instead of defining it in Vagrantfile.
However, Vagrantfile's provider config has more priority.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
