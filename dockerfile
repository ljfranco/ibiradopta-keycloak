# Etapa de construcción
FROM quay.io/keycloak/keycloak:26.0.4 AS builder

ARG KC_HEALTH_ENABLED KC_METRICS_ENABLED KC_FEATURES KC_DB KC_HTTP_ENABLED PROXY_ADDRESS_FORWARDING QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY KC_HOSTNAME KC_LOG_LEVEL KC_DB_POOL_MIN_SIZE

# Copiar temas y proveedores personalizados
COPY /themes/. /opt/keycloak/themes
COPY /providers/. /opt/keycloak/providers

# Construir Keycloak con los recursos personalizados
RUN /opt/keycloak/bin/kc.sh build

# Etapa final (runtime)
FROM quay.io/keycloak/keycloak:26.0.4

COPY java.config /etc/crypto-policies/back-ends/java.config

# Copiar el Keycloak compilado desde la etapa de construcción
COPY --from=builder /opt/keycloak /opt/keycloak

# Exponer el puerto predeterminado de Keycloak
EXPOSE 8080

# Comando de inicio de Keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start-dev"]
