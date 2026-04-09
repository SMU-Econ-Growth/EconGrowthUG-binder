# docker build -t omerozak/econgrowthug-deepnote:v3 .
# docker run -d -p 8888:8888 omerozak/econgrowthug-deepnote:v3
# docker push omerozak/econgrowthug-deepnote:v3
# Create docker for EconGrowthUG for use on Deeepnote
FROM condaforge/miniforge3

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ghostscript \
 && rm -rf /var/lib/apt/lists/*

ENV PROJ_LIB=/opt/conda/share/proj
WORKDIR /work

# Install mamba
RUN conda install -y -c conda-forge mamba && conda clean -afy

# Install conda packages (with version constraints for plotly/kaleido)
RUN mamba install -y -c conda-forge -c r --override-channels \
    python=3.11 \
    pip \
    camelot-py \
    dask-geopandas \
    geocoder \
    geopy \
    georasters \
    geopandas \
    geoplot \
    geotiff \
    html5lib \
    ipykernel \
    ipympl \
    ipyparallel \
    ipython \
    ipywidgets \
    jinja2 \
    jupyterlab \
    kiwisolver \
    matplotlib \
    nb_conda_kernels \
    networkx \
    nltk \
    nodejs \
    numba \
    numpy \
    openpyxl \
    opencv \
    pandas \
    pandas-datareader \
    "plotly<6.1.1" \
    "python-kaleido<1" \
    plotnine \
    pycountry \
    scikit-image \
    scikit-learn \
    scipy \
    seaborn \
    spatialpandas \
    stata_kernel \
    statsmodels \
    xlrd \
    r-base \
    r-dagitty \
    r-dplyr \
    r-irkernel \
    r-tibble \
    r-tidyr \
    rpy2 \
 && conda clean -afy

# Pip packages WITHOUT dependency resolution
RUN python -m pip install --no-cache-dir --no-deps \
    geonamescache \
    stargazer \
    dbnomics \
    rdrobust \
    pyfixest \
    lets-plot \
    RISE \
    jupyterlab-rise \
    git+https://github.com/ozak/google-drive-downloader

# Pip packages WITH dependency resolution (important for wbdata)
RUN python -m pip install --no-cache-dir --upgrade --upgrade-strategy eager \
    wbdata \
 && python -m pip check

# Verify plotly + kaleido + wbdata
RUN python - <<EOF
import plotly
import kaleido
import wbdata
print("plotly:", plotly.__version__)
print("kaleido:", kaleido.__version__)
print("wbdata OK")
EOF

# Clone notebooks (last for caching)
RUN git clone https://github.com/SMU-Econ-Growth/EconGrowthUG-Notebooks.git .

EXPOSE 9000

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=9000", "--no-browser", "--allow-root", "--NotebookApp.token=docker"]
