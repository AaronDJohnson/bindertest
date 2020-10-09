FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# System packages
RUN apt update && apt install -y curl

# Install miniconda to /miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda

# More apt stuff
RUN apt install -y libtool autoconf libsuitesparse-dev
RUN apt-get install -y libopenmpi-dev automake
RUN apt install -y gcc g++ gfortran cmake git

# Packages
RUN conda install -y -c anaconda basemap libtool curl
RUN conda install -y Cython

RUN pip install numpy scipy matplotlib \
    pandas astropy jupyter notebook ephem \
    mpi4py h5py healpy

RUN conda install -y -c conda-forge healpy scikit-sparse
RUN pip install jplephem corner

# The important stuff
RUN pip install git+https://github.com/vallis/libstempo@master --install-option="--force-tempo2-install"

RUN pip install git+https://github.com/dfm/acor@master
RUN pip install git+https://github.com/jellis18/PTMCMCSampler@master
RUN pip install git+https://github.com/nanograv/PINT@master

RUN pip install git+https://github.com/nanograv/enterprise@master
RUN pip install git+https://github.com/nanograv/enterprise_extensions@master

# add contents to folders
ADD data $HOME/src/data
ADD notebooks $HOME/src/notebooks

WORKDIR /src/notebooks

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]















