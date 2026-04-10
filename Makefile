# SPDX-License-Identifier: GPL-3.0-or-later

#    ----------------------------------------------------------------------
#    Copyright © 2024, 2025, 2026  Pellegrino Prevete
#
#    All rights reserved
#    ----------------------------------------------------------------------
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

SHELL ?= bash
PREFIX ?= /usr/local
_PROJECT=evm-chains
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/$(_PROJECT)
BIN_DIR=$(DESTDIR)$(PREFIX)/bin
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man
LIB_DIR=$(DESTDIR)$(PREFIX)/lib

_INSTALL_FILE=\
  install \
    -vDm644
_INSTALL_DIR=\
  install \
    -vdm755
_INSTALL_EXE=\
  install \
    -vDm755

DOC_FILES=\
  $(wildcard \
      *.rst) \
  $(wildcard \
      *.md)

_BUILD_TARGETS=\
  build \
  build-split
_BUILD_TARGETS_ALL=\
  all \
  $(_BUILD_TARGETS)
_CHECK_TARGETS=\
  shellcheck
_CHECK_TARGETS_ALL=\
  check \
  $(_CHECK_TARGETS)
_INSTALL_SCRIPTS_TARGETS=\
  install-json
INSTALL_DOC_TARGETS=\
  install-doc \
  install-man
_INSTALL_TARGETS=\
  $(_INSTALL_DOC_TARGETS)
_INSTALL_TARGETS_ALL=\
  install \
  $(_INSTALL_TARGETS) \
  $(_INSTALL_SCRIPTS_TARGETS)

_PHONY_TARGETS=\
  $(_BUILD_TARGETS_ALL) \
  $(_CHECK_TARGETS_ALL) \
  $(_INSTALL_TARGETS_ALL) \
  publish-npm
  
all: build-man build build-split

check: shellcheck

shellcheck:

	cat \
	  "chains.json" | \
	  jq \
	    . \
	    1>&"/dev/null"

build:

	mkdir \
	 -p \
	 "build/chains"
	if [[ ! -e "chains.json" ]]; then \
	  evmfs \
	    get \
	    -o \
	      "chains.json" \
	    "evmfs://100/0x87003Bd6C074C713783df04f36517451fF34CBEf/168bdbec23925a4f61ad97a1fd9cabeff0540ce15ad200d9da7b70c15a16f533"; \
	fi
	install \
	  -vDm644 \
	  "chains.json" \
	  "build/chains"


build-man:

	git \
	  submodule \
	    update \
	      --init \
	      "man"
	mkdir \
	  -p \
	  "build"
	cp \
	  -r \
	  "man" \
	  "build/"
	cd \
	  "build/man" && \
	make \
	  "build-man"

build-npm:

	mkdir \
	 -p \
	 "build/chains"
	npm \
	  pack

build-split:

	mkdir \
	 -p \
	 "build/chains"
	$(_INSTALL_FILE) \
	  "COPYING" \
	  "build/COPYING"
	$(_INSTALL_FILE) \
	  "package.json" \
	  "build/package.json"
	_chains_amount="$$( \
	  cat \
	    "chains.json" | \
	    jq \
	      length)"; \
	_msg=( \
	  "Found '$${_chains_amount}'" \
	  "chains." \
	); \
	echo \
	 "$${_msg[*]}"; \
	_index_end="$$(( \
	  "$${_chains_amount}" - \
	  1 ))"; \
	for _index \
	  in $$(seq \
	         "0" \
	         "$${_index_end}"); do \
	  _jq_query="[.[]][$${_index}]"; \
	  _network="$$( \
	    jq \
	      "$${_jq_query}" \
	      "chains.json")"; \
	  _chain_id="$$( \
	    echo \
	      "$${_network}" | \
	      jq \
	        ".chainId")"; \
	  if [[ -e "build/chains/$${_chain_id}.json" ]]; then \
	    _msg=( \
	      "Configuration file" \
	      "for network with chain ID" \
	      "'$${_chain_id}'" \
	      "already written." \
	      "('$${_index}'" \
	      "out of '$${_index_end}')." \
	    ); \
	    echo \
	     "$${_msg[*]}"; \
	  elif [[ ! -e "build/chains/$${_chain_id}.json" ]]; then \
	    echo \
	      "$${_network}" | \
	      jq \
	        "[.]" > \
	        "build/chains/$${_chain_id}.json"; \
	    _msg=( \
	      "Written configuration file" \
	      "for network with chain ID" \
	      "'$${_chain_id}'" \
	      "('$${_index}'" \
	      "out of '$${_index_end}')." \
	    ); \
	    echo \
	     "$${_msg[*]}"; \
	  fi \
	done

install: $(_INSTALL_TARGETS)

install:

	for _file \
	  in $$(find \
	          -type \
	            "f" \
	          "build/chains"); do \
	  $(_INSTALL_FILE) \
	    "build/chains/$${_file}" \
	    "$(LIB_DIR)/$(_PROJECT)/$${_file}"; \
	done

install-doc:

	$(_INSTALL_FILE) \
	  $(DOC_FILES) \
	  -t \
	  "$(DOC_DIR)/"

install-man:

	git \
	  submodule \
	    update \
	      --init \
	      "man"
	mkdir \
	  -p \
	  "build"
	cp \
	  -r \
	  "man" \
	  "build"
	cd \
	  "build/man" && \
	make \
	  "install-man"

publish:

	evmfs \
	  publish \
	  "build/chains/chains.json"

publish-npm:

	cd \
	  "build"; \
	npm \
	  publish \
	  --access \
	    "public"

.PHONY: $(_PHONY_TARGETS)
