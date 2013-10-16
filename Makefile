# Makefile for novaslides' development.
# See INSTALL for details.

# Configuration.
SHELL = /bin/bash
ROOT_DIR = $(shell pwd)
BIN_DIR = $(ROOT_DIR)/bin
DATA_DIR = $(ROOT_DIR)/var
WGET = wget
BUILDOUT_CFG = $(ROOT_DIR)/etc/buildout.cfg
BUILDOUT_DIR = $(ROOT_DIR)/lib/buildout
BUILDOUT_VERSION = 2.2.1
BUILDOUT_BOOTSTRAP_URL = https://raw.github.com/buildout/buildout/$(BUILDOUT_VERSION)/bootstrap/bootstrap.py
BUILDOUT_BOOTSTRAP = $(BUILDOUT_DIR)/bootstrap.py
BUILDOUT_BOOTSTRAP_ARGS = -c $(ROOT_DIR)/etc/buildout.cfg --version=$(BUILDOUT_VERSION) buildout:directory=$(ROOT_DIR)
BUILDOUT = $(BIN_DIR)/buildout
BUILDOUT_ARGS = -N buildout:directory=$(ROOT_DIR)
VIRTUALENV_DIR = $(ROOT_DIR)/lib/virtualenv
PIP = $(VIRTUALENV_DIR)/bin/pip
NOSE = $(BIN_DIR)/nosetests
PYTHON = $(VIRTUALENV_DIR)/bin/python
LANDSLIDE = $(BIN_DIR)/landslide
LANDSLIDE_CONFIGURATION = etc/landslide.cfg
LANDSLIDE_ARGS = $(LANDSLIDE_CONFIGURATION)


install: buildout


py27:
	if [ ! -d $(VIRTUALENV_DIR)/bin/ ]; then virtualenv --no-site-packages $(VIRTUALENV_DIR); fi
	$(PIP) install -r $(ROOT_DIR)/etc/virtualenv.cfg


buildout: py27
	if [ ! -d $(BUILDOUT_DIR) ]; then mkdir -p $(BUILDOUT_DIR); fi
	if [ ! -f $(BUILDOUT_BOOTSTRAP) ]; then wget -O $(BUILDOUT_BOOTSTRAP) $(BUILDOUT_BOOTSTRAP_URL); fi
	if [ ! -x $(BUILDOUT) ]; then $(PYTHON) $(BUILDOUT_BOOTSTRAP) $(BUILDOUT_BOOTSTRAP_ARGS); fi
	$(BUILDOUT) -c $(ROOT_DIR)/etc/buildout.cfg $(BUILDOUT_ARGS)


clean:
	find $(ROOT_DIR)/ -name "*.pyc" -delete


distclean: clean
	rm -rf $(ROOT_DIR)/*.egg-info
	rm -rf $(ROOT_DIR)/demo/*.egg-info


maintainer-clean: distclean
	rm -rf $(BIN_DIR)
	rm -rf $(ROOT_DIR)/lib/


slides:
	$(LANDSLIDE) $(LANDSLIDE_ARGS)
