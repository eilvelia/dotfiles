#!/usr/bin/env bash

opam update

opam install -y \
  utop \
  merlin \
  ocamlbuild \
  dune \
  base \
  ppx_let
