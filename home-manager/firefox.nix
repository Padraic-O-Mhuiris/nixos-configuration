{ config, lib, pkgs, defaultUser, ... }:

let

  bookmarkUrls = lib.forEach [
    "https://mail.google.com/mail/u/0/?hl=en#inbox"
    "https://chat.openai.com/"
    "https://www.youtube.com/"
    "https://twitter.com/home"
    "https://www.instagram.com/"
    "https://web.whatsapp.com/"
    "https://github.com/"
    "https://old.reddit.com/"
    "https://www.twitch.tv/"
    "https://www.netflix.com/browse"
    "https://news.ycombinator.com/news"
    "https://lobste.rs/"
    "https://www.daft.ie/property-for-sale/galway-city"
    "https://www.coingecko.com/en"

  ] (url: {
    inherit url;
    name = "";
  });


  firefoxPkg = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    extraPolicies = {
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      BlockAboutAddons = false;
      BlockAboutConfig = false;
      BlockAboutProfiles = true;
      BlockAboutSupport = true;
      Bookmarks = [ ];
      CaptivePortal = false;
      DefaultDownloadDirectory = config.xdg.userDirs.download;
      DisableAppUpdate = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisableFirefoxScreenshots = true;
      DisableForgetButton = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "always";
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = false;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      HardwareAcceleration = true;
      InstallAddonsPermission = { Default = true; };
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        CryptoMining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponseredPocked = false;
        Snippets = false;
        Locked = true;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
      Homepage = {
        Locked = true;
        StartPage = "none";
      };
    };
  };

in {
  programs.firefox = {
    enable = true;
    package = firefoxPkg;
    profiles."${defaultUser.name}" = {
      id = 0;
      isDefault = true;
      name = defaultUser.name;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        metamask
        bitwarden
        old-reddit-redirect
        i-dont-care-about-cookies
        reddit-enhancement-suite
        org-capture
      ];
      search = {
        default = "DuckDuckGo";
        force = true;
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "type";
                  value = "options";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
          "HomeManager Options" = {
            urls = [{
              template = "https://mipmip.github.io/home-manager-option-search/";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }];
            icon =
              "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nho" ];
          };
        };
      };
      bookmarks = [{
        name = "Toolbar Bookmarks";
        toolbar = true;
        bookmarks = bookmarkUrls;
      }];
      userChrome = '''';
      userContent = '''';
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.tabs.tabMinWidth" = 66;
        "browser.tabs.tabClipWidth" = 86;
        "browser.tabs.tabmanager.enabled" = false;
      };
    };
  };
}
