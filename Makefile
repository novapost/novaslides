SHELL = /usr/bin/env bash

ROOT_DIR = $(shell pwd)
BIN_DIR = $(ROOT_DIR)/bin
PYTHON = $(shell which python)
BUILDOUT_DIR = $(ROOT_DIR)/lib/buildout
BUILDOUT_VERSION = 1.7.0
BUILDOUT = $(BIN_DIR)/buildout
BUILDOUT_CONFIGURATION = $(ROOT_DIR)/etc/buildout.cfg
BUILDOUT_BOOTSTRAP = $(BUILDOUT_DIR)/bootstrap.py
BUILDOUT_BOOTSTRAP_ARGS = --distribute -c $(BUILDOUT_CONFIGURATION) 
BUILDOUT_ARGS = -c $(BUILDOUT_CONFIGURATION)
LANDSLIDE = $(BIN_DIR)/landslide
LANDSLIDE_CONFIGURATION = etc/landslide.cfg
LANDSLIDE_ARGS = $(LANDSLIDE_CONFIGURATION)


install: buildout


clean:
	find . -name "*.pyc" -delete


realclean: clean
	rm -rf bin/ lib/


buildout:
	if [ ! -d $(BUILDOUT_DIR) ]; then \
		mkdir -p $(BUILDOUT_DIR); \
	fi
	if [ ! -f $(BUILDOUT_BOOTSTRAP) ]; then \
		wget -O $(BUILDOUT_BOOTSTRAP) https://raw.github.com/buildout/buildout/1.7.0/bootstrap/bootstrap.py; \
	fi
	if [ ! -x $(BUILDOUT) ]; then \
		$(PYTHON) $(BUILDOUT_DIR)/bootstrap.py --distribute -c $(BUILDOUT_CONFIGURATION) -v $(BUILDOUT_VERSION) buildout:directory=$(ROOT_DIR); \
	fi
	$(BUILDOUT) -N -c $(BUILDOUT_CONFIGURATION) buildout:directory=$(ROOT_DIR)


slides:
	$(LANDSLIDE) $(LANDSLIDE_ARGS)
