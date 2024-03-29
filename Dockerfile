FROM ubuntu:16.04
LABEL author="artur.manukyan@umassmed.edu"  description="Docker image containing all requirements for the dolphinnext/slamseq_pipeline"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git libtbb-dev g++

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# configure image
RUN apt-get -y update
RUN apt-get -y install software-properties-common build-essential
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran40/'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN apt-get -y install apt-transport-https
RUN apt-get -y update

RUN apt-get update && apt-get install -y gcc unzip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN aws --version

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY environment.yml /
RUN conda update -n base -c defaults conda
RUN conda env create -f /environment.yml && conda clean -a
# Install dolphin-tools
RUN git clone https://github.com/dolphinnext/tools /usr/local/bin/dolphin-tools
RUN mkdir -p /project /nl /mnt /share
ENV PATH /opt/conda/envs/dolphinnext-slamseq-1.0/bin:/usr/local/bin/dolphin-tools/:$PATH

# MultiQC
RUN pip install "multiqc==1.7"

# Hisat3n
RUN git clone https://github.com/DaehwanKimLab/hisat2.git hisat-3n
WORKDIR "/hisat-3n"
RUN git checkout -b hisat-3n origin/hisat-3n
RUN make
WORKDIR "/"

# Java 16.0.2 for SlamTools.jar
RUN wget https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-x64_bin.tar.gz
RUN gzip -d openjdk-16.0.2_linux-x64_bin.tar.gz 
RUN tar xvf openjdk-16.0.2_linux-x64_bin.tar 
RUN export PATH="/jdk-16.0.2/bin:$PATH"
