# boinc-client-docker

Run the BOINC client in a Docker container

You can run as any user, doesn't need any special priveleges but must own /srv/boinc/client or wherever you put the files.
You can use any IP address and port you want, but this does not expose it to the Internet, which you probably want.
You can find the rpc passwrd in /srv/boinc/client/gui_rpc_auth.cfg.
You can adjust the number of cpus. Frankly I don't understand how boinc or docker does it's usage calculations so I just give it half for now.
This version automatically applies security updates.

Put this (suitably modified) into your compose.yaml file and make a copy of boinc/Dockerfile

    services:

        boinc:
            pull_policy: build
            image: boinc-client
            build: ./boinc
            user: 1000:1000
            ports:
            - 127.0.0.1:31416:31416
            volumes:
                source: /srv/boinc/client/
                target: /var/lib/boinc-client/
            restart: unless-stopped
            deploy:
                resources:
                    limits:
                        cpus: '6.0'

or just

    cd boinc-client-docker

Create the work dir if necessary

    sudo mkdirs /srv/boinc/client
    sudo chown 1000:1000 /srv/boinc/client

Start it up

    docker compose up -d boinc

Then connect with

    boincmgr --namehost 127.0.0.1 --gui_rpc_port 31416 --password=$(cat /srv/boinc/client/gui_rpc_auth.cfg)

It will automatically restart on reboot unless you stop it with

    docker compose down boinc
