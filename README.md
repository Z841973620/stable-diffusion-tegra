### Build stable-diffusion-webui container for Jetson platform

![IMG](./IMG.png)

container environments:<br>
jetpack4.6.1(ubuntu18.04), cuda10.2.460, python3.10, pytorch1.13.1, compiled for sm_53(TX1/Nano), sm_62(TX2) and sm_72(Xavier)
<br><br><br>
pull and run built container:
```
docker run -it --rm --runtime=nvidia -p 80:80 -v /path/to/MODELS:/stable-diffusion-webui/models/Stable-diffusion docker.841973620.net:8888/build/stable-diffusion:cuda10.2-tegra-base
```

pull and run built container for meinapastel 2:
```
docker run -it --rm --runtime=nvidia -p 80:80 docker.841973620.net:8888/build/stable-diffusion:cuda10.2-tegra-meinapastel2
```
