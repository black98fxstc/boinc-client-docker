# BOINC Client in Docker Container

[Run the BOINC client in a Docker container](https://github.com/black98fxstc/boinc-client-docker.git)

You can use any user and directory you want.
The user doesn't need any special priveleges but the directory must exist and be owned by the user.
You can use any IP address and port you want, but this does not expose it to the Internet, which you probably want.
You can find the rpc passwrd in /srv/boinc/client/gui_rpc_auth.cfg.
You can adjust the number of cpus. Frankly I don't understand how boinc or docker does it's usage calculations.
If you give it half the number of real cpus and then tell the client to use 50%, then it does what you want, each process runs at full speed.
This version automatically applies security updates to the OS but does not update boinc itself.

Put this (suitably modified) into your compose.yaml file

    services:

        boinc:
            image: black98fxstc/boinc-client:latest
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

    docker compose up --detach boinc

Then connect with

    boincmgr --namehost 127.0.0.1 --gui_rpc_port 31416 --password=$(cat /srv/boinc/client/gui_rpc_auth.cfg)

It will automatically restart on reboot unless you stop it with

    docker compose down boinc

You can also use docker directly if you insist. You can figure out the resource restrictions yourself.

     docker run --user 1000:1000 --publish 127.0.0.1:31416:31416 \
       --mount type=bind,source=/srv/boinc/client,target=/var/lib/boinc-client \
       --detach --restart unless-stopped black98fxstc/boinc-client
