FROM ubuntu:xenial
LABEL maintainer "kusmirekwiktor@gmail.com"

RUN apt-get update && apt-get upgrade -y -q

RUN apt-get install -y -q \
    software-properties-common \
    libboost-iostreams-dev libboost-system-dev libboost-filesystem-dev \
    zlibc gcc-multilib apt-utils zlib1g-dev python \
    cmake tcsh build-essential g++ git wget gzip perl cpanminus

COPY gm_et_linux_64.tar.gz /

RUN tar -xzf gm_et_linux_64.tar.gz

RUN wget http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.3.2.tar.gz

RUN tar -xzf augustus-3.3.2.tar.gz

RUN apt-get install bamtools -y -q

RUN wget http://bioinf.uni-greifswald.de/augustus/binaries/old/BRAKER_v2.0.1.tar.gz 2>/dev/null

RUN tar -xzf BRAKER_v2.0.1.tar.gz

RUN apt-get install samtools -y -q

#RUN cpanm File::Spec::Functions
RUN cpanm Hash::Merge
RUN cpanm List::Util
RUN cpanm Logger::Simple
RUN cpanm Module::Load::Conditional
RUN cpanm Parallel::ForkManager
RUN cpanm POSIX
RUN cpanm Scalar::Util::Numeric
RUN cpanm YAML

RUN adduser --disabled-password --gecos '' dockeruser
RUN mkdir /data
RUN chown -R dockeruser /data
RUN chmod a+w -R /augustus-3.3.2/config
USER dockeruser
WORKDIR /data

COPY gm_key_64.gz /
RUN zcat /gm_key_64.gz > ~/.gm_key

ENV PATH $PATH:/BRAKER_v2.0:/augustus-3.3.2/bin/
ENV PATH $PATH:/augustus-3.3.2/scripts:/gm_et_linux_64/gmes_petap/
ENV AUGUSTUS_CONFIG_PATH /augustus-3.3.2/config
ENV GENEMARK_PATH /gm_et_linux_64/gmes_petap/
ENV BAMTOOLS_PATH /usr/bin/

#To download example data files
#RUN git clone https://github.com/Gaius-Augustus/BRAKER
