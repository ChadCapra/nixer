{ userSettings, pkgs, ... }:

{

	home.packages = with pkgs; [
		# firefox
		inkscape
		audacity
		ffmpeg-full
		nerd-fonts.droid-sans-mono
		nerd-fonts.ubuntu
	];

	fonts.fontconfig.enable = true;

	programs.obs-studio = {
		enable = true;
		plugins = with pkgs.obs-studio-plugins; [
		  wlrobs
		  obs-backgroundremoval
		  obs-pipewire-audio-capture
		];
	};

}
