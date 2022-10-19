FROM jenkins/inbound-agent:jdk17

USER root
RUN apt-get update && apt-get install -y lsb-release curl
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/$(lsb_release -is | tr "[:upper:]" "[:lower:]")  \
 $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

#RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
#RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Hashicorp repo
RUN curl -fsSLo /usr/share/keyrings/hashicorp-archive-keyring.asc https://apt.releases.hashicorp.com/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.asc] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list


ARG NOMAD_VERSION=1.3.5-1
#docker-cli dos2unix jq nomad
RUN apt-get update && apt-get install -y docker-ce-cli dos2unix jq nomad=${NOMAD_VERSION} pandoc texlive-fonts-recommended texlive-latex-extra lmodern && \
  apt-get autoremove && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*


ARG LEVANT_VERSION="0.3.0"
ARG MAVEN_VERSION="3.8.6"
RUN apt install -y unzip && \
  curl -L -o levant-${LEVANT_VERSION}.zip https://releases.hashicorp.com/levant/${LEVANT_VERSION}/levant_${LEVANT_VERSION}_linux_amd64.zip && \
  unzip levant-${LEVANT_VERSION}.zip -d /usr/bin && \
  rm levant-${LEVANT_VERSION}.zip && \
  curl -L -o apache-maven-${MAVEN_VERSION}-bin.zip https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip && \
  unzip apache-maven-${MAVEN_VERSION}-bin.zip -d /opt && \
  rm apache-maven-${MAVEN_VERSION}-bin.zip && \
  apt remove -y unzip

ARG GRYPE_VERSION="0.35.0"
RUN curl -L -o grype_${GRYPE_VERSION}_linux_amd64.deb https://github.com/anchore/grype/releases/download/v${GRYPE_VERSION}/grype_${GRYPE_VERSION}_linux_amd64.deb && \
    dpkg -i grype_${GRYPE_VERSION}_linux_amd64.deb && \
    rm grype_${GRYPE_VERSION}_linux_amd64.deb

ENV M2_HOME="/opt/apache-maven-${MAVEN_VERSION}"
ENV PATH="$M2_HOME/bin:$PATH"

# goss
ARG GOSS_VERSION=v0.3.10
RUN  curl -L "https://github.com/aelsabbahy/goss/releases/download/${GOSS_VERSION}/goss-linux-amd64" -o /usr/local/bin/goss && \
  chmod +rx /usr/local/bin/goss

RUN curl -L "https://github.com/aelsabbahy/goss/releases/download/${GOSS_VERSION}/dgoss" -o /usr/local/bin/dgoss && \
  chmod +rx /usr/local/bin/dgoss
