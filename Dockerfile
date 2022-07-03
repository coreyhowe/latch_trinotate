FROM 812206152185.dkr.ecr.us-west-2.amazonaws.com/latch-base:02ab-main

RUN apt-get update -y &&\
    apt-get install -y wget libncurses5 &&\
    apt-get install gzip

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 


RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

RUN conda install trinotate 
RUN conda install -c conda-forge sqlite

RUN sed -i 's/32767/3276700/' /root/miniconda3/bin/Trinotate_report_writer.pl

#COPY data /root

# STOP HERE:
# The following lines are needed to ensure your build environment works
# correctly with latch.
COPY wf /root/wf
RUN  sed -i 's/latch/wf/g' flytekit.config
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
RUN python3 -m pip install --upgrade latch
WORKDIR /root
