.PHONY: clean lint requirements venv test

#################################################################################
# GLOBALS                                                                       #
#################################################################################
VENV_DIR =  env
PYTHON_INTERPRETER = $(VENV_DIR)/bin/python3
PIP = $(VENV_DIR)/bin/pip

#################################################################################
# COMMANDS                                                                      #
#################################################################################
all: clean requirements lint test


## Install Python Dependencies
requirements: venv
	$(PIP) install -U pip setuptools wheel
	$(PIP) install -e .
ifneq ($(wildcard ./requirements.txt),)
	$(PIP) install -r requirements.txt
endif

## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

test:
	@$(PYTHON_INTERPRETER) -W ignore::DeprecationWarning -m unittest discover --verbose

## Install virtual environment
venv:
ifeq ($(wildcard $(VENV_DIR)/*),)
	@echo "Did not find $(VENV_DIR), creating..."
	mkdir -p $(VENV_DIR)
	python -m venv $(VENV_DIR)
endif

## Lint using flake8
lint:
	@$(PYTHON_INTERPRETER) -m flake8 --max-line-length=90 marketsim test
