{ config, pkgs, ... }:

{
	fileSystem."/" = {
		device = "/dev/"
	}
}
