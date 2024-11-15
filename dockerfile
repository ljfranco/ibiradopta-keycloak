# Etapa de construcción
FROM quay.io/keycloak/keycloak:26.0.4 AS builder

# Copiar temas y proveedores personalizados
COPY /themes/. /opt/keycloak/themes
COPY /providers/. /opt/keycloak/providers

# Construir Keycloak con los recursos personalizados
RUN /opt/keycloak/bin/kc.sh build

# Etapa final (runtime)
FROM quay.io/keycloak/keycloak:26.0.4

# Copiar el Keycloak compilado desde la etapa de construcción
COPY --from=builder /opt/keycloak /opt/keycloak

# Exponer el puerto predeterminado de Keycloak
EXPOSE 8080

# Comando de inicio de Keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start-dev"]
