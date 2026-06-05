package com.redhat;
import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.jboss.logging.Logger;

@ApplicationScoped
public class EventConsumer {
    private static final Logger LOG = Logger.getLogger(EventConsumer.class);

    @Incoming("incoming-events")
    public void consume(String message) {
        LOG.infof("[CONSUMER v3.3] Evento recebido: %s", message);
    }
}