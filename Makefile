TARGET_USER ?= root
TARGET_HOST ?=

laptop-sync:
	rsync -av --delete-before --exclude='.git' ./ root@laptop:/home/husjon/nixos-config

laptop: laptop-sync
	ssh root@laptop 'cd /home/husjon/nixos-config; nixos-rebuild --flake '.#laptop' switch'
	ssh root@laptop 'pkill hypridle'

laptop-trace: laptop-sync
	ssh root@laptop 'cd /home/husjon/nixos-config; nixos-rebuild --flake '.#laptop' test' --show-trace

laptop-activate: laptop-sync
	ssh root@laptop 'cd /home/husjon/nixos-config; nixos-rebuild --flake '.#laptop' dry-activate'

laptop-activate-trace: laptop-sync
	ssh root@laptop 'cd /home/husjon/nixos-config; nixos-rebuild --flake '.#laptop' dry-activate --show-trace'





sops-get_host_key:
	$(call check_defined, TARGET_HOST)
	# ssh root@${TARGET_HOST} "cat /etc/ssh/ssh_host_rsa_key" | nix-shell -p ssh-to-pgp --run "ssh-to-pgp -o server01.asc"

	ssh root@${TARGET_HOST} "cat /etc/ssh/ssh_host_rsa_key" | \
	nix-shell \
		-p ssh-to-pgp \
		--run "ssh-to-pgp -name ${TARGET_USER} -email ${TARGET_USER}@${TARGET_HOST} -o ${TARGET_USER}-${TARGET_HOST}.asc"


# https://stackoverflow.com/a/10858332
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))
