#!/usr/bin/env bash

opam update

opam install -y \
  utop \
  merlin \
  ocp-indent \
  ocp-index \
  ocamlbuild \
  dune \
  base \
  ppx_deriving \
  ppx_let \
  cstruct
