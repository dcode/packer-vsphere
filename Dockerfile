FROM fedora:32

ENV PACKER_VERSION=1.6.0
ENV PACKER_SHA256SUM=a678c995cb8dc232db3353881723793da5acc15857a807d96c52e96e671309d9

ENV LC_CTYPE=C
ENV OVFTOOL_VERSION 4.4.0-15722219
ENV OVFTOOL_INSTALLER VMware-ovftool-${OVFTOOL_VERSION}-lin.x86_64.bundle
# checksum verified at https://my.vmware.com/group/vmware/details?downloadGroup=OVFTOOL440&productId=742
ENV OVFTOOL_SHA256SUM=6238aef96079206982409254685ac9049fcef36e8b669a754d51af5e74feace6

# Needed to extract and install ovftool
#RUN dnf -y install libxcrypt-compat unzip libnsl ncurses-compat-libs && dnf clean all && rm -rf /var/cache/dnf
RUN dnf -y install unzip xerces-c libxcrypt-compat libnsl && dnf clean all && rm -rf /var/cache/dnf

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./
RUN echo "${PACKER_SHA256SUM} packer_${PACKER_VERSION}_linux_amd64.zip" | sha256sum -c -

RUN unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin
RUN rm -f packer_${PACKER_VERSION}_linux_amd64.zip

ADD https://inverse.ca/downloads/PacketFence/utils/VMware-ovftool-${OVFTOOL_VERSION}-lin.x86_64.bundle ./
RUN echo "${OVFTOOL_SHA256SUM} ${OVFTOOL_INSTALLER}" | sha256sum -c -

RUN echo "/etc/init.d" | bash ${OVFTOOL_INSTALLER} -p /usr/local --console --eulas-agreed --required
RUN rm ${OVFTOOL_INSTALLER}

WORKDIR /project
ENTRYPOINT ["/bin/packer"]
