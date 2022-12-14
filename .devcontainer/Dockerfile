# R version: 4, 4.1, 4.0
ARG VARIANT="4.2"
# Includes packages: devtools tidyverse tidymodels glmnet randomForest xgboost 
FROM rocker/tidyverse:${VARIANT}
# FROM eddelbuettel/r2u:20.04 AS r2u

LABEL maintainer="john <john@1x2.ltd>"

# Use the [Option] comment to specify true/false arguments that should appear in VS Code UX
#
# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"


# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1001
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive 
RUN /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" 
RUN usermod -a -G sudo vscode 
# vscode and rstudio in same group then give group rwx access
# RUN sudo groupadd staff 
RUN usermod -a -G staff vscode
RUN usermod -a -G sudo rstudio 
RUN usermod -a -G staff rstudio
#    && usermod -a -G staff ${USERNAME} 

RUN apt-get -y install \
        python3-pip \
        libgit2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libxt-dev \
        rsync
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts \
    && python3 -m pip --no-cache-dir install radian \
    && pip --disable-pip-version-check --no-cache-dir install pybryt \
    && pip --disable-pip-version-check --no-cache-dir install pylint \
    #&& pip --disable-pip-version-check --no-cache-dir install jupyter \
    #&& pip --disable-pip-version-check --no-cache-dir install datascience \
    #&& pip --disable-pip-version-check --no-cache-dir install otter-grader \
    && pip --disable-pip-version-check --no-cache-dir install numpy \
    && pip --disable-pip-version-check --no-cache-dir install pandas \
    #&& pip --disable-pip-version-check --no-cache-dir install scipy \
    #&& pip --disable-pip-version-check --no-cache-dir install folium>=0.9.1 \
    #&& pip --disable-pip-version-check --no-cache-dir install matplotlib \
    #&& pip --disable-pip-version-check --no-cache-dir install ipywidgets>=7.0.0 \
    #&& pip --disable-pip-version-check --no-cache-dir install bqplot \
    #&& pip --disable-pip-version-check --no-cache-dir install nbinteract>=0.0.12 \
    #&& pip --disable-pip-version-check --no-cache-dir install otter-grader \
    #&& pip --disable-pip-version-check --no-cache-dir install okpy \
    #&& pip --disable-pip-version-check --no-cache-dir install scikit-learn \
    && install2.r --error --skipinstalled --ncpus -1 \
        languageserver #\
        #httpgd \
        #statip \
        #patchwork \
        #paletteer \
        #doParallel \
        #janitor \
        #vip \
        #ranger \
        #palmerpenguins \
        #skimr \
        #nnet \
        #kernlab \
        #plotly \
        #factoextra \
        #cluster \
        #tidymodels \
        #markdown \ 
        #ottr \
    # && rm -rf /tmp/downloaded_packages
    && rm -rf /tmp/*

# install.r is NA in rocker/tidyverse
RUN install2.r remotes here devtools \
  reticulate \
  tidyverse 


## Install summarytools and load some R package off the bat
#RUN R -e "devtools::install_github('https://github.com/dcomtois/summarytools/tree/0-8-9')"
#RUN R -e "library(ottr)"
# RUN installGithub.r ucbds-infra/ottr@stable
RUN R -e "library(here)"
RUN R -e "library(languageserver)"


# VSCode R Debugger dependency. Install the latest release version from GitHub without using GitHub API.
# See https://github.com/microsoft/vscode-dev-containers/issues/1032
RUN export TAG=$(git ls-remote --tags --refs --sort='version:refname' https://github.com/ManuelHentschel/vscDebugger v\* | tail -n 1 | cut --delimiter='/' --fields=3) \
    && Rscript -e "remotes::install_git('https://github.com/ManuelHentschel/vscDebugger.git', ref = '"${TAG}"', dependencies = FALSE)"

# R Session watcher settings.
# See more details: https://github.com/REditorSupport/vscode-R/wiki/R-Session-watcher
RUN echo 'source(file.path(Sys.getenv("HOME"), ".vscode-R", "init.R"))' >> ${HOME}/.Rprofile

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update \
#     && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this section to install additional R packages.
# RUN install2.r --error --skipinstalled --ncpus -1 <your-package-list-here>


# [Optional] Uncomment this section to install vscode-jupyter dependencies.
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libzmq3-dev \
    && install2.r --error --skipinstalled --ncpus -1 IRkernel \
    && python3 -m pip --no-cache-dir install jupyter \
    && R --vanilla -s -e 'IRkernel::installspec(user = FALSE)'

# create Linux group and user, both called app. 
# 'app' instead of the default root user:
# https://hosting.analythium.io/dockerizing-shiny-applications/
#RUN addgroup --system rstudio \
#     && adduser --system --ingroup rstudio rstudio
# USER rstudio

# Expose Rstudio port. Log in with rstudio/rstudio
# but only from FROM rocker/tidyverse:${VARIANT} not r2u
# EXPOSE 8787

# Expose Jupyter port
EXPOSE 8888

CMD ["/init"]
# CMD ["R", "-e", "shiny::runApp('/home/app')"]

# link github folder inside rstudio 
# RUN sudo ln -s /workspaces/devcontainers-rstudio/* /home/rstudio
# sudo unlink /workspaces/devcontainers-rstudio/*
# https://unix.stackexchange.com/questions/492777/how-should-i-merge-two-folders-on-the-same-filesystem
# RUN  rsync -PHACcviuma --copy-unsafe-links --exclude="*~"  /workspaces/devcontainers-rstudio/  /home/rstudio/ 
USER vscode
# RUN usermod -a -G sudo rstudio 
RUN sudo mkdir -p /workspaces/devcontainers-rstudio \
    && sudo chmod g+rwx /workspaces/devcontainers-rstudio \
    && sudo touch /workspaces/devcontainers-rstudio/zzz2.txt 
# chown -R vscode:staff Resources
RUN sudo mkdir -p /home/rstudio \
    && sudo chmod g+rwx /home/rstudio \
    && sudo touch /home/rstudio/zzz.txt 
RUN sudo chgrp -R staff /workspaces/devcontainers-rstudio/
RUN sudo chgrp -R staff /home/rstudio/
RUN sudo ln -s /workspaces/devcontainers-rstudio/* /home/rstudio
# RUN sudo rsync -PHACcvium --copy-unsafe-links --exclude="*~"  /home/rstudio /workspaces/devcontainers-rstudio  
#RUN sudo rsync -avzPtu /workspaces/devcontainers-rstudio/* /home/rstudio
#RUN sudo rsync -avzPtu /home/rstudio/* /workspaces/devcontainers-rstudio
# avzP

