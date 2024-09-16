ON_ERROR	?= cleanup

.DEFAULT_GOAL := build

package:
	tar cfzv flakes.tar.gz -C ../ laptop

build: package
	reset
	packer build -on-error=${ON_ERROR} .

build_debug:
	reset
	PACKER_LOG=1 packer build -on-error=ask .
