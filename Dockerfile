FROM fedora:28

ENV PACKER_VERSION=1.3.5
ENV PACKER_SHA256SUM=14922d2bca532ad6ee8e936d5ad0788eba96f773bcdcde8c2dc7c95f830841ec

ENV OVFTOOL_VERSION 4.3.0-7948156
ENV OVFTOOL_INSTALLER VMware-ovftool-${OVFTOOL_VERSION}-lin.x86_64.bundle
# checksum verified at https://my.vmware.com/group/vmware/details?downloadGroup=OVFTOOL430&productId=742
ENV OVFTOOL_SHA256SUM=d327c8c7ebaac7432a589b1207410889d00c1ffd3fe18fa751b14459644de980

# Needed to extract and install ovftool
RUN dnf -y update && dnf -y install unzip ncurses-compat-libs && dnf clean all && rm -rf /var/cache/dnf

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./
RUN echo "${PACKER_SHA256SUM} packer_${PACKER_VERSION}_linux_amd64.zip" | sha256sum -c -

RUN unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin
RUN rm -f packer_${PACKER_VERSION}_linux_amd64.zip

ADD https://www.dropbox.com/s/n5pepfatetp55q2/VMware-ovftool-4.3.0-7948156-lin.x86_64.bundle?dl=1 ./
RUN echo "${OVFTOOL_SHA256SUM} ${OVFTOOL_INSTALLER}" | sha256sum -c -

RUN sh ${OVFTOOL_INSTALLER} -p /usr/local --console --eulas-agreed --required
RUN rm ${OVFTOOL_INSTALLER}

ENTRYPOINT ["/bin/packer"]
