FROM busybox:1.36.1-uclibc as busybox
FROM cloudflare/cloudflared:latest
COPY --from=busybox /bin/sh /bin/sh
COPY --from=busybox /bin/cat /bin/cat
ENTRYPOINT [ "/bin/sh", "-c", "export TUNNEL_TOKEN=$(cat /run/secrets/cloudflare_tunnel_token) ;  cloudflared --no-autoupdate tunnel run" ]

