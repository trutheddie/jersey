PYTHON3_VERSION = $(shell python3 -c "import sys; print(sys.version_info.minor)")
PYTHON3_PATH = $(shell which python3)
MIN_PYTHON3_MINOR_REQUIRED = 6
PYTHON36_PATH = $(shell which python36)
PYTHON3_BIN=$(shell if [ ${PYTHON3_VERSION} -ge ${MIN_PYTHON3_MINOR_REQUIRED} ] ; then \
	echo ${PYTHON3_PATH}; \
else \
	if [ ${PYTHON36_PATH} ] ; then \
		echo ${PYTHON36_PATH}; \
	fi \
fi)
BIN_NAME=nj
INSTALL_DIR=/usr/local/bin
CWD=$(shell pwd)
VENV_PYTHON=${CWD}/venv/bin/python

install: dev
	@if [ -f ${INSTALL_DIR}/${BIN_NAME} ] ; then \
			sudo rm ${INSTALL_DIR}/${BIN_NAME}; \
	fi

	@sudo /bin/bash -c "echo -e '#!/bin/bash\n' >> ${INSTALL_DIR}/${BIN_NAME} && \
		echo '${VENV_PYTHON} ${CWD}/nj/nj.py \"\$$@\"' >> '${INSTALL_DIR}/${BIN_NAME}' && \
		chmod 755 '${INSTALL_DIR}/${BIN_NAME}'"
	echo ... installation complete ...

dev: clean
	@echo "creating virtual environment"
	${PYTHON3_BIN} -m venv venv
	ls venv
	echo "installing dependencies"; \
	${VENV_PYTHON} -m pip install -r requirements.txt

clean:
	@echo "cleaning dev environment"
	@rm -rf venv

.PHONY: dev clean install
