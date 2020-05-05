FROM nvidia/cuda:latest

# Install system dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        curl \
        wget \
        git \
        unzip \
        screen \
        vim \
    && apt-get clean

# Install python miniconda3 + requirements
ENV MINICONDA_HOME="/opt/miniconda"
ENV PATH="${MINICONDA_HOME}/bin:${PATH}"
RUN curl -o Miniconda3-latest-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod +x Miniconda3-latest-Linux-x86_64.sh \
    && ./Miniconda3-latest-Linux-x86_64.sh -b -p "${MINICONDA_HOME}" \
    && rm Miniconda3-latest-Linux-x86_64.sh

RUN conda install conda install -c conda-forge librosa  && \
    conda install numpy

RUN pip install pyrubberband

RUN wget https://github.com/cdr/code-server/releases/download/3.2.0/code-server-3.2.0-linux-x86_64.tar.gz && \
    tar -xzvf code-server-3.2.0-linux-x86_64.tar.gz && chmod +x code-server-3.2.0-linux-x86_64/code-server && \
    rm code-server-3.2.0-linux-x86_64.tar.gz
 
COPY . /LetItBee
WORKDIR /LetItBee
RUN pip install requirements.txt

# Start container in notebook mode
CMD /code-server-3.2.0-linux-x86_64/code-server --bind-addr 0.0.0.0:8080 & \
    python3 -m visdom.server & \
    jupyter-lab --ip="*" --no-browser --allow-root

# docker build -t letitbee .
# docker run -p 8080:8080 -p 8097:8097 -p 8888:8888 -it tetitbee
