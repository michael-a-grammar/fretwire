docker run                                                \
       -p ${LIVEBOOK_PORT}:${LIVEBOOK_PORT}               \
       -p ${LIVEBOOK_IFRAME_PORT}:${LIVEBOOK_IFRAME_PORT} \
       --pull always                                      \
       -u $(id -u):$(id -g)                               \
       -v $(pwd)/notebooks:/data                          \
       -v $(pwd):/data/fretwire                           \
       -e LIVEBOOK_PASSWORD=${LIVEBOOK_PASSWORD}          \
       -e LIVEBOOK_PORT=${LIVEBOOK_PORT}                  \
       -e LIVEBOOK_IFRAME_PORT=${LIVEBOOK_IFRAME_PORT}    \
       ghcr.io/livebook-dev/livebook
