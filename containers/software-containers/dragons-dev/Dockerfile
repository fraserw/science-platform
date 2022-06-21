# Dockerfile

FROM continuumio/miniconda3 as deploy

# Install text editors
RUN apt-get update -y --fix-missing && \
	apt-get install -y vim nano xterm curl
RUN apt-get install -y man-db manpages-dev
RUN apt-get install -y xorg gcc emacs
RUN apt-get install -y xauth locales && \
    /usr/sbin/update-locale LANG=C.UTF-8 && locale-gen C.UTF-8
#RUN wget http://http.us.debian.org/debian/pool/main/f/firefox/firefox_101.0.1-1_amd64.deb
RUN apt-get install -y chromium
RUN apt-get install -y epiphany

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN conda config --add channels http://astroconda.gemini.edu/public && \
	  conda config --add channels http://ssb.stsci.edu/astroconda && \
	  conda create -n dragons3 python=3.7 dragons stsci && \
   	conda install --name dragons3 astroquery
RUN	conda create -n dragons2 python=3.6 dragons=2.1.1 stsci

# Make sure to use latest version of DRAGONS
RUN conda update -n dragons2 dragons
RUN conda update -n dragons3 dragons && \
    conda clean --all -f -y

# Create entrypoint script
COPY src/init.sh /skaha/
RUN ["chmod", "+x", "/skaha/init.sh"]

# Arcade container requirements
COPY src/nsswitch.conf /etc/

RUN conda run -n dragons3 pip install --upgrade pip && \
	  conda run -n dragons3 pip install --no-cache-dir cadcutils && \
    conda run -n dragons3 pip install --no-cache-dir vos && \
    conda run -n dragons3 pip install --no-cache-dir pyvo

RUN conda run -n dragons2 pip install --upgrade pip && \
	  conda run -n dragons2 pip install --no-cache-dir cadcutils && \
    conda run -n dragons2 pip install --no-cache-dir 'astroquery==0.4' && \
    conda run -n dragons2 pip install --no-cache-dir pyvo && \
    conda run -n dragons2 pip install --no-cache-dir vos


# setup this container for skaha launching
#COPY src/start_lsst.sh /etc/profile.d/
COPY src/startup.sh /skaha/startup.sh
RUN chmod +x /skaha/startup.sh


# Two build sets, deploy and test
FROM deploy as test
RUN echo "Adding a test user to run local testing"
RUN mkdir -p /arc/home
RUN groupadd -g 1001 testuser
RUN useradd -u 1001 -g 1001 -s /bin/bash -d /arc/home/testuser -m testuser
USER testuser
COPY src/docker_test.sh /arc/home/testuser/docker_test.sh
#RUN chmod +x /arc/home/testuser/docker_test.sh
ENTRYPOINT ["/skaha/startup.sh"]
