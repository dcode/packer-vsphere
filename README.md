# packer-ovftool
[![Docker Repository on Quay](https://quay.io/repository/dcode/packer-vsphere/status "Docker Repository on Quay")](https://quay.io/repository/dcode/packer-vsphere)

Docker image with Packer + VMware ovftool + JetBrains vSphere driver

Container build from this repo hosted on Quay. To use

```
docker pull quay.io/dcode/packer-vsphere
```

Then just run the container as if you were running packer directly, except pass in your project directory at `/project` which is the working directory of the image.

```
docker run -ti -v $(pwd):/project quay.io/dcode/packer-vsphere:latest centos-8-x86_64.json
```
