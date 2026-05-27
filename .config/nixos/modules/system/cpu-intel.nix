{ config, pkgs, ... }:

{
	boot.kernelParams = [ "intel_pstate=active" ];
}
