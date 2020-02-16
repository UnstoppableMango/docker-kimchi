FROM ubuntu:19.10 as build

ENV TZ=America/Chicago

RUN apt-get update && \
    apt-get install -y \
        gcc \
        make \
        autoconf \
        automake \
        git \
        python3-pip \
        python3-requests \
        python3-mock \
        gettext \
        pkgconf \
        xsltproc \
        python3-dev \
        pep8 \
        pyflakes \
        python3-yaml

RUN git clone https://github.com/kimchi-project/kimchi.git && \
    cd kimchi && \
    pip3 install -r requirements-UBUNTU.txt && \
    ./autogen.sh --system && \
    make && \
    make deb
#    make install && \
#    cd / && \
#    rm -rf /var/lib/kimchi/isos /kimchi

FROM ubuntu:19.10
COPY --from=build
RUN DEBIAN_FRONTEND=noninteractive && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y \
        git \
        python3-configobj \
        python3-lxml \
        python3-magic \
        python3-paramiko \
        python3-ldap \
        spice-html5 \
        novnc \
        qemu-kvm \
        python3-libvirt \
        python3-parted \
        python3-guestfs \
        python3-pil \
        python3-cherrypy3 \
        libvirt0 \
        libvirt-daemon-system \
        libvirt-clients \
        nfs-common \
        sosreport \
        open-iscsi \
        libguestfs-tools \
        libnl-route-3-dev
