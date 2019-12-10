# SSH-ENV container reach to root folder of machine
SSH connection in docker for development environment. And changing root folder with chroot command.

You should mount root folder to /workspace folder. (__WARNING EXTREMLY DANGEROUS__)

> https://hub.docker.com/r/ryts/ssh-env

```shell
docker run -d --rm -p 2222:22 -v /:/workspace --name ssh-env ryts/ssh-env
```

You don't have to add `-v /:/workspace` option.

## Get in with ssh
Connect ssh's `2222` port with `root1234` password
```shell
ssh -p 2222 root@localhost
```

## With shell script to build and run
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
