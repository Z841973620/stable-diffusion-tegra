# build on JetPack 4.2.6 (L4T 32.7.1), CUDA 10.2.460
FROM nvcr.io/nvidia/l4t-cuda:10.2.460-runtime

# add runtime
ENV DEBIAN_FRONTEND=noninteractive
ADD /usr/local/cuda-10.2/targets/aarch64-linux/lib/libcupti.* /usr/local/cuda-10.2/targets/aarch64-linux/lib/
ADD /usr/lib/aarch64-linux-gnu/libopenblas.so.0 /usr/lib/aarch64-linux-gnu/
ADD /usr/lib/aarch64-linux-gnu/libgfortran.so.4 /usr/lib/aarch64-linux-gnu/
RUN rm /etc/apt/sources.list.d/cuda.list && apt-key adv --fetch-key https://repo.download.nvidia.com/jetson/jetson-ota-public.asc && echo 'deb https://repo.download.nvidia.com/jetson/common r32.7 main' > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && apt update && apt install -y --no-install-recommends python3 python3-pip vim curl libcudnn8=8.2.1.32-1+cuda10.2 && apt clean && rm -rf /var/lib/apt/lists/*

# install python3.10
RUN apt update && apt install -y --no-install-recommends make gcc && curl -fkLO https://github.com/Z841973620/stable-diffusion-tegra/releases/download/jetpack-4.6/Python-3.10.12.tar && tar -xvf *.tar && cd Python-3.10.12 && make install && cd .. && rm -rf Python-3.10.12 *.tar && apt autoremove -y make gcc && apt clean && rm -rf /var/lib/apt/lists/* && rm /usr/bin/python3 && ln -s /usr/local/bin/python3.10 /usr/bin/python3

# install sd-webui dependents, pytorch1.13.1 has been compiled for sm_53(TX1/Nano), sm_62(TX2) and sm_72(Xavier)
ENV LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libGLdispatch.so.0
RUN apt update && apt install -y --no-install-recommends git libgl1 libglib2.0-0 gcc && apt clean && rm -rf /var/lib/apt/lists/*
RUN curl -fkLO https://github.com/Z841973620/stable-diffusion-tegra/releases/download/whl/torch-1.13.1+cu102.tegra-cp310-cp310-linux_aarch64.whl && curl -fkLO https://github.com/Z841973620/stable-diffusion-tegra/releases/download/whl/torchvision-0.14.1+cu102.tegra-cp310-cp310-linux_aarch64.whl && curl -fkLO https://github.com/Z841973620/stable-diffusion-tegra/releases/download/whl/torchaudio-0.13.1+cu102.tegra-cp310-cp310-linux_aarch64.whl && curl -fkLO https://github.com/Z841973620/stable-diffusion-tegra/releases/download/whl/xformers-0.0.20+cu102.tegra-cp310-cp310-linux_aarch64.whl && \
	    pip3 install *.whl psutil==5.9.5 clip open-clip-torch pytorch_lightning==1.9.1 GitPython==3.1.32 accelerate==0.21.0 blendmodes==2022 clean-fid==0.1.35 diskcache==5.6.3 einops==0.4.1 facexlib==0.3.0 fastapi==0.94.0 gradio==3.41.2 httpcore==0.15 httpx==0.24.1 inflection==0.5.1 jsonmerge==1.8.0 kornia==0.6.7 lark==1.1.2 omegaconf==2.2.3 piexif==1.1.3 resize-right==0.0.2 scikit-image==0.21.0 spandrel==0.1.6 tomesd==0.1.3 torchdiffeq==0.2.3 torchsde==0.2.6 ngrok numpy==1.22.2 matplotlib pillow==9.2.0 fsspec==2024.9.0 transformers==4.30.2 markupsafe==2.1.5 && rm -rf ~/.cache/pip
ADD stable-diffusion-webui /stable-diffusion-webui/

WORKDIR /stable-diffusion-webui
ENTRYPOINT ["./launch.sh"]
