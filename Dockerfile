### configuration of docker image for Quokka FPGA toolkit integration with RISC-V
 
FROM ubuntu:bionic
SHELL ["/bin/bash", "-c"]

### image prep
RUN apt-get update
RUN apt-get install -y wget gnupg apt-utils git sudo

### install webmin, this is optional tool, remote access to Docker\WSL can be setup differently, e.g. with VS Code
RUN echo deb https://download.webmin.com/download/repository sarge contrib >> /etc/apt/sources.list
RUN wget http://www.webmin.com/jcameron-key.asc
RUN apt-key add jcameron-key.asc
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes
RUN apt-get -o Acquire::GzipIndexes=false update
RUN apt-get -y install apt-show-versions webmin

# start webmin and update password. Login: root, Password: root
RUN /etc/init.d/webmin restart
RUN /usr/share/webmin/changepass.pl /etc/webmin root root

### install .NET Core
#### please refer to official guide for your OS
#### https://docs.microsoft.com/en-us/dotnet/core/install/
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get install -y software-properties-common
RUN add-apt-repository universe
RUN apt-get install -y apt-transport-https
RUN apt-get update
RUN apt-get install -y dotnet-sdk-3.1

# cleanup
RUN rm -rf /tmp/dotnet-installer

### install picorv32 and RISC-V toolchain 
# https://github.com/cliffordwolf/picorv32#building-a-pure-rv32i-toolchain
RUN apt-get install -y \
		autoconf automake autotools-dev curl libmpc-dev \
        libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
		gperf libtool patchutils bc zlib1g-dev libexpat1-dev

# place all stuff in home folder
RUN cd ~

RUN git clone https://github.com/cliffordwolf/picorv32.git
RUN cd ./picorv32 && make download-tools
RUN cd ./picorv32 && yes | make -j$(nproc) build-riscv32imc-tools

# cleanup
RUN rm -rf /var/cache/distfiles/riscv*
RUN rm -rf ./picorv32/riscv*

### TynyFPGA-BX repo for reference
RUN git clone https://github.com/tinyfpga/TinyFPGA-BX.git

### add RISCV toolchain into PATH
RUN source /etc/environment && rm -rf /etc/environment && echo PATH=\"$PATH:/opt/riscv32imc/bin\" >> /etc/environment && source /etc/environment


# configure Quokka integration server
RUN cd ~
RUN git clone https://github.com/EvgenyMuryshkin/Quokka.RISCV.Docker.Server.git
RUN cp -r ./Quokka.RISCV.Docker.Server/scripts/. ./
RUN chmod 766 ./update ./launch
RUN ./update

# expose integration port, not required for WSL
EXPOSE 10000 15000

CMD ["/bin/bash"]
