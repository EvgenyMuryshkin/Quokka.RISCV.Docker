### configuration of docker image for Quokka FPGA toolkit integration with RISC-V
 
FROM ubuntu:bionic
SHELL ["/bin/bash", "-c"]

### image prep
RUN apt-get update
RUN apt-get install -y wget gnupg apt-utils git sudo

### install webmin
RUN echo deb http://download.webmin.com/download/repository sarge contrib >> /etc/apt/sources.list
RUN wget http://www.webmin.com/jcameron-key.asc
RUN apt-key add jcameron-key.asc
RUN rm /etc/apt/apt.conf.d/docker-gzip-indexes
RUN apt-get -o Acquire::GzipIndexes=false update
RUN apt-get -y install apt-show-versions webmin

# start webmin and update password. Login: root, Password: root
RUN /etc/init.d/webmin restart
RUN /usr/share/webmin/changepass.pl /etc/webmin root root

### install .NET Core 2.2
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get install -y software-properties-common
RUN add-apt-repository universe
RUN apt-get install -y apt-transport-https
RUN apt-get update
RUN apt-get install -y dotnet-sdk-2.2

# cleanup
RUN rm -rf /tmp/dotnet-installer

### install picorv32 and RISC-V toolchain 
# https://github.com/cliffordwolf/picorv32#building-a-pure-rv32i-toolchain
RUN apt-get install -y \
		autoconf automake autotools-dev curl libmpc-dev \
        libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
		gperf libtool patchutils bc zlib1g-dev libexpat1-dev

RUN git clone https://github.com/cliffordwolf/picorv32.git
RUN cd /picorv32 && make download-tools
RUN cd /picorv32 && yes | make -j$(nproc) build-riscv32imc-tools

# cleanup
RUN rm -rf /var/cache/distfiles/riscv*
RUN rm -rf /picorv32/riscv*

### TynyFPGA-BX repo for reference
RUN git clone https://github.com/tinyfpga/TinyFPGA-BX.git

### add RISCV toolchain into PATH
RUN source /etc/environment && rm -rf /etc/environment && echo PATH=\"$PATH:/opt/riscv32imc/bin\" >> /etc/environment && source /etc/environment

CMD ["/bin/bash"]