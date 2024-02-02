# boinc-client-docker

Run the BOINC client in a Docker container

You can run as any user, doesn't need any special priveleges but must own /srv/boinc/client or wherever you put the files

    services:

    boinc:
        pull_policy: build
        image: boinc-client
        build: ./boinc
        user: 1000:1000
        ports:
        - 127.0.0.1:31416:31416
        volumes:
        - type: bind
            source: /srv/boinc/client/
            target: /var/lib/boinc-client/
        deploy:
        resources:
            limits:
            cpus: '6.0'
