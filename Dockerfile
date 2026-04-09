# docker build -t omerozak/econgrowthug-deepnote:v3 .
# docker run -d -p 8888:8888 omerozak/econgrowthug-deepnote:v3
# docker push omerozak/econgrowthug-deepnote:v3
# Create docker for EconGrowthUG for use on Deeepnote
FROM condaforge/miniforge3

ENV DEBIAN_FRONTEND=noninteractive
ENV PROJ_LIB=/opt/conda/share/proj

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ghostscript \
 && rm -rf /var/lib/apt/lists/*

RUN conda install -y -c conda-forge --override-channels mamba \
 && conda clean -afy

RUN mamba install -y -c conda-forge -c r --override-channels \
    python=3.11 \
    pip \
    "plotly<6.1.1" \
    "python-kaleido<1" \
    "esda<2.9" \
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
    jupyter \
    jupyterlab \
    kiwisolver \
    matplotlib \
    matplotlib-base \
    nb_conda_kernels \
    networkx \
    nltk \
    nodejs \
    numba \
    numpy \
    openpyxl \
    opencv \
    "pandas<3" \
    "pandas-datareader==0.10.0" \
    platformdirs \
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

RUN python -m pip install --no-cache-dir \
    geonamescache \
    stargazer \
    dbnomics \
    rdrobust \
    pyfixest \
    lets-plot \
    RISE \
    jupyterlab-rise \
    palettable \
    pypng \
    tenacity \
    formulaic \
    maketables \
    jupyterlab-mathjax3 \
    "pdfminer-six>=20240706" \
    git+https://github.com/ozak/google-drive-downloader

RUN python -m pip install --no-cache-dir --upgrade --upgrade-strategy eager wbdata

RUN python - <<EOF
import plotly
import kaleido
import wbdata
print("plotly:", plotly.__version__)
print("kaleido:", kaleido.__version__)
print("wbdata OK")
EOF

RUN python -m pip check || true

WORKDIR /work

RUN git clone https://github.com/SMU-Econ-Growth/EconGrowthUG-Notebooks.git .

EXPOSE 9000

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=9000", "--no-browser", "--allow-root", "--NotebookApp.token=docker"]
