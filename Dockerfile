FROM continuumio/miniconda3:4.10.3
MAINTAINER Lukas Forer <lukas.forer@i-med.ac.at> / Sebastian Schönherr <sebastian.schoenherr@i-med.ac.at>
COPY environment.yml .
RUN \
   conda env update -n root -f environment.yml \
&& conda clean -a

RUN apt-get --allow-releaseinfo-change update && apt-get install -y procps unzip libgomp1

# Install jbang (not as conda package available)
WORKDIR "/opt"
RUN wget https://github.com/jbangdev/jbang/releases/download/v0.87.0/jbang-0.87.0.zip && \
    unzip -q jbang-*.zip && \
    mv jbang-0.87.0 jbang  && \
    rm jbang*.zip
ENV PATH="/opt/jbang/bin:${PATH}"

RUN apt-get --allow-releaseinfo-change update && apt-get install -y bcftools
