A proof of concept PaaS built on top of Nix.

What it does
============

It allows you to create users and repos. A repo represent an
application that can be run. When you push to the repo, deployment is
automatically triggered based on a `default.nix` file, see
`sample-app/default.nix` for an example. When the build is successful,
its closure is copied to the other machine (`host`) where the
resulting runner is installed and started as a systemd service. The
application is then available under `http://host:someport`.

Currently there's no load balancer in front yet, and ports are also
not automatically assigned, that is for later.

How to setup and use
====================

    $ ./generate-keys.sh
    $ nixops create network.nix infra-vbox.nix -d nixcloud
    $ nixops deploy

This deploys two servers:

* builder: which hosts the application repositories the user can push to and performs builds
* host: which runs the application (eventually there will be many hosts, but currently only one is supported)

To create a new user:

    $ nixops ssh -d nixcloud builder nixcloud-create-user zef

To setup a public key:

    $ nixops ssh -d nixcloud builder nixcloud-add-key zef ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjWpdyDIsS09lWlOsMG9OMTHB/N/afVU12BwKcyjjhbezPdFEgHK4cZBN7m1bvoFKl832BdB+ZjeRH4UGBcUpvrFu1vE7Lf/0vZDU7qzzWQE9V+tfSPwDiXPf9QnCYeZmYPDHUHDUEse9LKBZbt6UKF1tuTD8ussV5jvEFBaesDhCqD1TJ4b4O877cdx9+VTOuDSEDm32jQ2az27d1b/5DoEKBe5cJSC3PhObAQ7OAYrVVBFX9ffKpaSvV6yqo+rhCmXP9DjNgBwMtElreoXL3h5Xbw2AiER5oHNUAEA2XGpnOVOr7ZZUAbMC0/0dq387jQZCqe7gIDZCqjDpGhUa9

To create a new repository:

    $ nixops ssh -d nixcloud builder nixcloud-create-repo zef mynewrepo

To push to that repo:

    $ mkdir mynewrepo
    $ cd mynewrepo
    $ git init
    $ git remote add origin zef@<ip-of-builder>:repo/mynewrepo

Now, create some content, or use the sample app:

    $ cp -r ~/git/nixcloud/sample-app/* .
    $ git add *
    $ git commit -a -m "Initial checkin"
    $ git push origin master

