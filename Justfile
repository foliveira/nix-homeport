# Justfile
default: build-and-switch

define build =
    nix flake update --no-update-lockfiles
    nix build .#${1}
endef

targets := build, switch

define build-and-switch =
    $(call build, $(MACHINE_NAME))
    sudo cp -f result/bin/* /run/current-system/sw/bin/.
endef