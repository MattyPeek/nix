{

  security.acme = {
    acceptTerms = true;
    defaults.email = "matyas.pesek@gmail.com";

    #certs = {
    #  "transfer.pesek.pro" = {
    #    webroot = "/srv/transfer";
    #  };
#
    #  "wiki.pesek.pro" = {
    #    webroot = "/srv/wikijs";
    #  };
    #};
  };

  services.nginx = {
    enable = true;

    clientMaxBodySize = "1024M";

    virtualHosts = {
      #"transfer.pesek.pro" = {
      "transfer.pesek.pro" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:6903";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };

      "script.pesek.pro" = {
        enableACME = true;
        forceSSL = true;
        root = "/srv/script";
        locations."/" = {
          extraConfig = ''
            autoindex on;
            default_type text/plain;
          '';
        };
        locations."/secure" = {
          extraConfig = ''
            autoindex on;
            default_type text/plain;
            auth_basic "Secure Access";
            auth_basic_user_file /srv/script/secure/.htpasswd;
          '';
        };
      };

      "wiki.pesek.pro" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:6907";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
        locations."~* ^.+\.(jpeg|gif|png|jpg)$" = {
          proxyPass = "http://127.0.0.1:6907";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_pass_header Content-Type;
          '';
        };
      };
    };
  };


}
