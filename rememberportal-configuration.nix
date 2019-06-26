{
  network.description = "rememberportal";

  rememberportal =
    { config, pkgs, ... }:
    {
      imports = [
        ./rememberportal/module.nix
      ];

      networking.hostName = "rememberportal";
      networking.firewall.allowedTCPPorts = [ 22 80 443 ];

      services.rememberportal.enable = true;
      services.nginx = {
        enable = true;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        virtualHosts."memberportal.example.com" = {
          default = true;
          #enableACME = true;
          #forceSSL = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
          };
        };
      };

      environment.systemPackages = with pkgs; [ msmtp vim tmux sqlite ];
      environment.etc."msmtprc.example" = {
        mode = "0600";
        text = ''
        account default
        host smtp.example.com
        port 587
        tls on
        tls_starttls on
        auth on
        user user@example.com
        from user@example.com
        password FIXMEbadbadbadFIXME
        '';
      };
    };
}
