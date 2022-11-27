.ONESHELL:

root_path_with_slash := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
root_path = $(shell echo $(root_path_with_slash) | gawk '{ print substr($$0, 0, length($$0)-1) }')
backend_path = $(root_path)/backend
api_path = $(root_path)/api
python_venv_path = $(backend_path)/venv
pip3=$(python_venv_path)/bin/pip3
python3=$(python_venv_path)/bin/python3
make=make -f $(root_path)/Makefile -C $(root_path)


build_api: api/
	@echo "Compiling protos..."
	$(shell test ! -e $(api_path)/python_api && mkdir $(api_path)/python_api)
	$(shell test ! -e $(api_path)/dart_api && mkdir $(api_path)/dart_api)
	$(shell test ! -e $(api_path)/__init__.py && touch $(api_path)/__init__.py)
	@protoc $(api_path)/*.proto --proto_path=$(api_path) --python_out="$(api_path)/python_api" --dart_out="$(api_path)/dart_api" --plugin="/Users/hazimmohamed/.pub-cache/bin/protoc-gen-dart"

clean_api:
	@rm -rf $(api_path)/python_api/* $(api_path)/dart_api/*


ifeq ($(shell test ! -e "$(pip list 2> /dev/null | grep "protobuf")"; echo $?),0)
install_python_protobuf: backend_venv
	@echo ""
else
install_python_protobuf: backend_venv
	echo "installing python protobuf..."
    ifeq ($(strip $(shell which git)),)
    	$(error could not find git. please install git.)
    endif
	$(eval protobuf_install_path = /tmp/protobuf_install_path)
	if [[ -e $(protobuf_install_path) ]]; then \
		rm -rf $(protobuf_install_path); \
  	fi
	mkdir $(protobuf_install_path)
	git clone https://github.com/protocolbuffers/protobuf.git $(protobuf_install_path)
	$(eval python_protobuf_path = $(protobuf_install_path)/python)
	cd $(python_protobuf_path); $(python3) setup.py install 1> /dev/null
endif

venv_search_results = $(shell test -e $(python_venv_path); echo $$?)
ifeq ($(venv_search_results), 0)
backend_venv:
	@echo $(venv_search_results)
else
backend_venv: $(wildcard $(backend_path)/venv/)
	@echo "Creating a virtual environment..."
	@echo $(venv_search_results)
	python3 -m venv $(python_venv_path)
endif

guarantee_requirements: $(backend_path)/requirements.txt
	@echo "Updating requirements..."
	@$(pip3) install -r $(backend_path)/requirements.txt 1> /dev/null

run_backend: build_api backend_venv guarantee_requirements install_python_protobuf
ifeq ($(strip $(shell which python3)),)
	$(error could not find python3. please install python.)
endif
ifeq ($(strip $(shell echo $$PYTHONPATH)),)
	export PYTHONPATH="$(api_path):$(backend_path)"
else
	export PYTHONPATH="$$PYTHONPATH:$(api_path):$(backend_path)"
endif
	$(make) backend_venv
	$(make) guarantee_requirements
	$(make) install_python_protobuf
	$(python3) -m flask -e $(backend_path)/.env run

clean_backend:
	rm -rf $(python_venv_path)


mongo_shell:
	mongosh mongodb+srv://aleaves-service:NI6WBX97J3P6vEdE@centipede.wfahzmu.mongodb.net/aleaves