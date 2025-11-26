{
    security.acme = {
        acceptTerms = true;
        defaults.email = "matyas.pesek@gmail.com";

    };

    services.nginx = {
        enable = true;
        clientMaxBodySize = "1024M";

        virtualHosts = {
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
                        client_max_body_size 10G;
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

            "countdown.pesek.pro" = {
                enableACME = true;
                forceSSL = true;
                root = "/srv/countdown";
                locations."/" = {
                    extraConfig = ''
                        try_files $uri /index.html;
                        default_type text/plain;
                    '';
                };
            };
            
            "status.pesek.pro" = {
                enableACME = true;
                forceSSL = true;
                root = "/srv/status";
                locations."/" = {
                    index = "index.php";
                    extraConfig = ''
                        try_files $uri /index.php;
                        default_type text/html;
                    '';
                };
                locations."~ \.php$" = {
                    index = "index.php";
                    extraConfig = ''
                        #try_files $uri =404;
                        fastcgi_pass			127.0.0.1:6904;
                        fastcgi_index			index.php;
                        fastcgi_buffers			8 16k;
                        fastcgi_buffer_size		32k;
                        #fastcgi_param DOCUMENT_ROOT $document_root;
                        #fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                        fastcgi_param DOCUMENT_ROOT /var/www/html;  # Path inside the container
                        fastcgi_param SCRIPT_FILENAME /var/www/html$fastcgi_script_name;
                        include /nix/store/3ngcig2iczqd8d8zfknipfzls8pzk671-nginx-1.26.2/conf/fastcgi_params;
                    '';
                };
                locations."~ \.json$" = {
                    extraConfig = ''
                        types {
                            application/json  json;
                        }
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
            "pass.pesek.pro" = {
                enableACME = true;
                forceSSL = true;
                locations."/" = {
                    proxyPass = "http://127.0.0.1:6908";
                    extraConfig = ''
                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    '';
                };
            };
        };
    };
}
