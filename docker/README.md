# Docker

**Build the `base` image**

_run this on the parent directory (`cd ..`)_

```
$ docker build -t img-base -f docker/Dockerfile.master .
$ docker run --rm  -p 8080:8080 --name masterr img-base
$ docker run -d -v "$YOURLOCAL_DIRECTORY:/var/lib/postgresql/data" -p 8080:8080 --name masterr img-base

# in another shell, install the DB seed
$ docker exec masterr rake db:migrate db:seed
$ docker exec masterr rails s -p 8080 -b 0.0.0.0

# <CTRL+C>
$ docker exec -it masterr bash
# change branches... eg: passenger, then reinstall the gems and leave this sheel
# commit the current container to a new image
$ docker commit masterr img-base:passenger
$ docker images | grep img-base
```

**See the container's resource usage**

```
$ sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8888:8080 \
  --detach=true \
  --name=cadvisor \
  google/cadvisor:latest
``` 
