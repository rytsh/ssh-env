# SSH-ENV container
SSH connection in docker for development environment.

Change expose port number inside run.sh to fit your app.

```shell
chmod u+x run.sh
./run.sh
```

```
OPTIONS:
    --image
        Set image name default ryts/ssh-env
    --con
        Set container name default ssh-env
    --build
        Build image if not exists
    --download
        Download image in dockerhub if not exists
    -s, --shell
        Open new shell in container
    --remove
        Remove con, image
        (--remove con --remove image)
    -h, --help
        This help page
```

## Get in with ssh
Connect ssh's `2222` port with `root1234` password
```shell
ssh -p 2222 root@localhost
```
