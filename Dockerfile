FROM fedora:32

ENV PACKER_VERSION=1.6.0
ENV PACKER_SHA256SUM=a678c995cb8dc232db3353881723793da5acc15857a807d96c52e96e671309d9

ENV PACKER_VSPHERE_BUILDER_VERSION=2.3
ENV PACKER_VSPHERE_BUILDER_CLONE_SHA256=6aea5b003bbdfbe8f7948dd6c905e224f8fe6b94ed9ccbf46917b01e1a0d8e70
ENV PACKER_VSPHERE_BUILDER_ISO_SHA256=6e432cc39503ac6604564ba33aaf10d7debb6b6d20429b0af168a00bee342c3b

ENV OVFTOOL_VERSION 4.4.0-15722219
ENV OVFTOOL_INSTALLER VMware-ovftool-${OVFTOOL_VERSION}-lin.x86_64.bundle
# checksum verified at https://my.vmware.com/group/vmware/details?downloadGroup=OVFTOOL440&productId=742
ENV OVFTOOL_SHA256SUM=6238aef96079206982409254685ac9049fcef36e8b669a754d51af5e74feace6

# Needed to extract and install ovftool
RUN dnf -y update && dnf -y install unzip libnsl ncurses-compat-libs && dnf clean all && rm -rf /var/cache/dnf

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./
RUN echo "${PACKER_SHA256SUM} packer_${PACKER_VERSION}_linux_amd64.zip" | sha256sum -c -

ADD https://github.com/jetbrains-infra/packer-builder-vsphere/releases/download/v${PACKER_VSPHERE_BUILDER_VERSION}/packer-builder-vsphere-clone.linux ./
RUN echo "${PACKER_VSPHERE_BUILDER_CLONE_SHA256} packer-builder-vsphere-clone.linux" | sha256sum -c - && mv packer-builder-vsphere-clone.linux /bin/packer-builder-vsphere-clone && chmod 0755 /bin/packer-builder-vsphere-clone

ADD https://github.com/jetbrains-infra/packer-builder-vsphere/releases/download/v${PACKER_VSPHERE_BUILDER_VERSION}/packer-builder-vsphere-iso.linux ./
RUN echo "${PACKER_VSPHERE_BUILDER_ISO_SHA256} packer-builder-vsphere-iso.linux" | sha256sum -c - && mv packer-builder-vsphere-iso.linux /bin/packer-builder-vsphere-iso && chmod 0755 /bin/packer-builder-vsphere-iso

RUN unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin
RUN rm -f packer_${PACKER_VERSION}_linux_amd64.zip

ADD https://inverse.ca/downloads/PacketFence/utils/VMware-ovftool-${OVFTOOL_VERSION}-lin.x86_64.bundle ./
RUN echo "${OVFTOOL_SHA256SUM} ${OVFTOOL_INSTALLER}" | sha256sum -c -

RUN sh ${OVFTOOL_INSTALLER} -p /usr/local --console --eulas-agreed --required
RUN rm ${OVFTOOL_INSTALLER}

ENTRYPOINT ["/bin/packer"]
