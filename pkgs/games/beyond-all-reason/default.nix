{ lib, appimageTools, fetchurl }:

let

  pname = "beyond-all-reason";
  version = "1.2988.0";

  src = fetchurl {
    url = "https://github.com/beyond-all-reason/BYAR-Chobby/releases/download/v${version}/Beyond-All-Reason-${version}.AppImage";
    hash = "sha256-ZJW5BdxxqyrM2TJTO0SBp4BXt3ILyi77EZx73X8hqJE=";
  };

  # get the .desktop file from the AppImage
  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/beyond-all-reason.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
    '';
  };

in

appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: [
    pkgs.binutils
    pkgs.fuse3
    pkgs.gtk3
    pkgs.nss
    pkgs.openal
    pkgs.SDL2
    pkgs.zlib
  ];

  # place the .desktop file where a desktop environment can read it
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/beyond-all-reason.desktop $out/share/applications/beyond-all-reason.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/beyond-all-reason.png $out/share/icons/hicolor/256x256/apps/beyond-all-reason.png
  '';

  meta = with lib; {
    description = "Total Annihilation Inspired RTS";
    mainProgram = "beyond-all-reason";
    homepage = "https://www.beyondallreason.info/";
    downloadPage = "https://github.com/beyond-all-reason/BYAR-Chobby/releases";
    changelog = "https://github.com/beyond-all-reason/BYAR-Chobby/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ xtechon ];
    platforms = platforms.linux;
  };
}
