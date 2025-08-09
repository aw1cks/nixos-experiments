{ pkgs, ... }:
{
  services.murmur = {
    enable = true;
    welcometext = "<br />Welcome to <strong>Alex's Mumble server</strong><br />";

    hostName = "*";
    users = 100;
    bandwidth = 130000;
    sendVersion = true;
    clientCertRequired = true;

    allowHtml = true;
    textMsgLength = 0;
    imgMsgLength = 0;

    autobanAttempts = 0;
    autobanTimeframe = 0;

    extraConfig = ''
      listenersperchannel=0
      listenersperuser=0

      suggestPushToTalk=true

      messageburst=9999
      messagelimit=9999
    '';
  };
}
