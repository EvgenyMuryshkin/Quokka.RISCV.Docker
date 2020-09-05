### configuration of docker image for Quokka FPGA toolkit integration with RISC-V
 
FROM ubuntu:focal
SHELL ["/bin/bash", "-c"]

### image prep
RUN cd ~ && git clone https://github.com/EvgenyMuryshkin/Quokka.RISCV.Server.git qrs
RUN cd ~/qrs && chmod 766 ./install 
RUN cd ~/qrs && ./install

EXPOSE 15000 15000

CMD ["/bin/bash"]