#!/usr/bin/env bash

opam update

opam install -y \
  utop \
  merlin \
  dune \
  ocamlformat \
  ocp-indent \
  ocp-index \
  ppx_deriving \
  base
