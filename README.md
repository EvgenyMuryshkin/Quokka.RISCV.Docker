# Quokka.RISCV.Docker
Docker configuration for RISCV integration with Quokka.FPGA

* Ubuntu 18.04 (bionic)
* .NET Core 3.1
* PicoRV32 repo
* RISCV toolchain (riscv32imc)
* Quokka RISC-V Integration Server

# Image on Docker Hub (pull.cmd)
```
docker pull evgenymuryshkin/quokka-riscv:latest
```

# Building from scratch (make.cmd)
```
docker build . -t evgenymuryshkin/quokka-riscv:rookie
```

# Running container (launch.cmd)
```
docker run --rm -p 15000:15000 -it evgenymuryshkin/quokka-riscv:latest bash -c ~/launch
```

## Output
```
PID: 6
Path: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/riscv32imc/bin
info: Microsoft.Hosting.Lifetime[0]
      Now listening on: http://0.0.0.0:15000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /opt/qrs
```
