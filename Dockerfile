# build on JetPack 5.1.2 (L4T 35.4.1), CUDA 11.4.19
FROM nvcr.io/nvidia/l4t-cuda:11.4.19-runtime

# add runtime
ENV DEBIAN_FRONTEND=noninteractive
ADD /usr/local/cuda-11.4/targets/aarch64-linux/lib/libcupti.* /usr/local/cuda-11.4/targets/aarch64-linux/lib/
RUN apt update && apt install -y --no-install-recommends python3 python3-pip curl libcudnn8=8.6.0.166-1+cuda11.4 && apt clean && rm -rf /var/lib/apt/lists/*

# install python3.10
RUN apt update && apt install -y --no-install-recommends software-properties-common && add-apt-repository -y ppa:deadsnakes/ppa && apt update && apt install -y --no-install-recommends python3.10 python3.10-distutils && rm /usr/bin/python3 && ln -s /usr/bin/python3.10 /usr/bin/python3 && curl -fkLS https://bootstrap.pypa.io/get-pip.py | python3.10 && apt clean && rm -rf /var/lib/apt/lists/*

# install sd-webui dependents, pytorch2.1.2 has been compiled for sm_72(Xavier) and sm_87(Orin)
ENV LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libGLdispatch.so.0
RUN apt update && apt install -y --no-install-recommends git libgl1 libglib2.0-0 gcc python3.10-dev && apt clean && rm -rf /var/lib/apt/lists/*
RUN curl -fkLO https://github.com/Z841973620/stable-diffusion-tegra/releases/download/whl/torch-2.1.2+cu114.tegra-cp310-cp310-linux_aarch64.whl && curl -fkLO https://github.com/Z841973620/stable-diffusion-tegra/releases/download/whl/torchvision-0.16.2+cu114.tegra-cp310-cp310-linux_aarch64.whl && curl -fkLO https://github.com/Z841973620/stable-diffusion-tegra/releases/download/whl/torchaudio-2.1.2+cu114.tegra-cp310-cp310-linux_aarch64.whl && curl -fkLO https://github.com/Z841973620/stable-diffusion-tegra/releases/download/whl/xformers-0.0.23.post1+cu114.tegra-cp310-cp310-linux_aarch64.whl && \
	pip3 install *.whl numpy==1.22.2 scipy==1.10.1 pyyaml==6.0.1 pandas==1.5.3 onnx==1.14.0 matplotlib pillow==9.2.0 clip open-clip-torch pytorch_lightning==1.9 GitPython==3.1.32 accelerate==0.21.0 blendmodes==2022 clean-fid==0.1.35 diskcache==5.6.3 einops==0.4.1 facexlib==0.3.0 fastapi==0.94.0 gradio==3.41.2 httpcore==0.15 httpx==0.24.1 inflection==0.5.1 jsonmerge==1.8.0 kornia==0.6.7 lark==1.1.2 omegaconf==2.2.3 piexif==1.1.3 psutil==5.9.5 resize-right==0.0.2 scikit-image==0.21.0 spandrel==0.1.6 tomesd==0.1.3 torchdiffeq==0.2.3 torchsde==0.2.6 ngrok fsspec==2024.9.0 transformers==4.30.2 xformers==0.0.23.post1+cu114.tegra markupsafe==2.1.5 && rm -rf ~/.cache/pip && rm -rf *.whl
ADD stable-diffusion-webui /stable-diffusion-webui/

WORKDIR /stable-diffusion-webui
ENTRYPOINT ["./launch.sh"]
