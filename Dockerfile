FROM continuumio/miniconda3:4.10.3
MAINTAINER Lukas Forer <lukas.forer@i-med.ac.at> / Sebastian Schönherr <sebastian.schoenherr@i-med.ac.at>
COPY environment.yml .
RUN \
   conda env update -n root -f environment.yml \
&& conda clean -a

RUN apt-get --allow-releaseinfo-change update && apt-get install -y procps unzip libgomp1
# Install genomic-utils
WORKDIR "/opt"
ENV GENOMIC_UTILS_VERSION="v0.3.7"
RUN wget https://github.com/genepi/genomic-utils/releases/download/${GENOMIC_UTILS_VERSION}/genomic-utils.jar

ENV JAVA_TOOL_OPTIONS="-Djdk.lang.Process.launchMechanism=vfork"
RUN apt-get --allow-releaseinfo-change update && apt-get install -y bcftools
