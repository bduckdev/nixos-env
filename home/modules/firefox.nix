{ pkgs, ... }:

let
  bibleIconUrl = "https://www.bible.com/apple-touch-icon.png";
  chatgptIconUrl = "https://chatgpt.com/cdn/assets/favicon-180x180.9e0103ce69.png";
in
{
  programs.firefox = {
    enable = true;

    nativeMessagingHosts = [
      pkgs.firefoxpwa
    ];

    profiles.default = {
      id = 0;
      isDefault = true;

      settings = {
        "extensions.autoDisableScopes" = 0;
      };

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        darkreader
        kagi-search
        privacy-badger
        pwas-for-firefox
        pywalfox
        untrap-for-youtube
        zotero-connector
      ];
    };
  };

  programs.firefoxpwa = {
    enable = true;

    #profiles."01ARZ3NDEKTSV4RRFFQ69G5FAV" = {
    #  name = "Web apps";

    #  sites."01ARZ3NDEKTSV4RRFFQ69G5FAW" = {
    #    name = "Bible.com";
    #    url = "https://www.bible.com/";
    #    manifestUrl = "data:application/manifest+json,{}";
    #    desktopEntry.icon = pkgs.fetchurl {
    #      name = "bible.png";
    #      url = bibleIconUrl;
    #      hash = "sha256-Q2w+i49oZFCb1V+gWwtmgs5Wa1ZcJjz1N6f4hyUYXgw=";
    #    };
    #    settings.config.icon_url = bibleIconUrl;
    #    settings.manifest = {
    #      scope = "https://www.bible.com/";
    #      display = "standalone";
    #    };
    #  };
    #  sites."01ARZ3NDEKTSV4RRFFQ69G5FAX" = {
    #    name = "ChatGPT";
    #    url = "https://www.chatgpt.com/";
    #    manifestUrl = "data:application/manifest+json,{}";
    #    desktopEntry.icon = pkgs.fetchurl {
    #      name = "chatgpt.png";
    #      url = chatgptIconUrl;
    #      hash = "sha256-xFCh48N1v1xtHbEDJ7WaWPW9bkmQ/9v28pLj0WHGaN4=";
    #    };
    #    settings.config.icon_url = chatgptIconUrl;
    #    settings.manifest = {
    #      scope = "https://www.chatgpt.com/";
    #      display = "standalone";
    #    };
    #  };
    #};
  };
}
