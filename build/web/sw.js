// ConsulTex - Service Worker para Notificaciones de Medicamentos


const CACHE_NAME = 'consultex-sw-v1';

self.addEventListener('install', event => {
    console.log('[SW] Instalado - ConsulTex Medicamentos');
    self.skipWaiting();
});

self.addEventListener('activate', event => {
    console.log('[SW] Activado - ConsulTex Medicamentos');
    event.waitUntil(clients.claim());
});

// Escuchar mensajes del cliente para programar notificaciones
self.addEventListener('message', event => {
    if (event.data && event.data.type === 'PROGRAMAR_RECORDATORIOS') {
        const medicamentos = event.data.medicamentos;
        programarRecordatorios(medicamentos);
    }
});

// Manejar clic en la notificación -> abre la app en Mis Recordatorios
self.addEventListener('notificationclick', event => {
    event.notification.close();
    event.waitUntil(
        clients.matchAll({ type: 'window', includeUncontrolled: true }).then(windowClients => {
            // Buscar si ya hay una pestaña de la app abierta
            for (let client of windowClients) {
                if (client.url.includes('/consultex') || client.url.includes('localhost')) {
                    client.focus();
                    client.postMessage({ type: 'ABRIR_RECORDATORIOS' });
                    return;
                }
            }
            // Si no hay pestaña abierta, abrir una nueva
            return clients.openWindow(event.notification.data ? event.notification.data.url : '/');
        })
    );
});

// Lógica de programación de alertas escalonadas

// Registro de timeouts activos para no duplicar
let timeoutsActivos = [];

function programarRecordatorios(medicamentos) {
    // Limpiar timeouts anteriores
    timeoutsActivos.forEach(id => clearTimeout(id));
    timeoutsActivos = [];

    const ahora = new Date();

    medicamentos.forEach(med => {
        const proximaToma = calcularProximaToma(med, ahora);
        if (!proximaToma) return;

        const diffMs = proximaToma - ahora;

        // Alertas escalonadas: 30, 15, 10, 5, 2 minutos antes
        const alertas = [
            { minutos: 30, emoji: '⏰', urgencia: 'Recordatorio' },
            { minutos: 15, emoji: '⚠️', urgencia: 'Próximamente' },
            { minutos: 10, emoji: '🔔', urgencia: 'Atencion' },
            { minutos: 5,  emoji: '🚨', urgencia: '¡Urgente!' },
            { minutos: 2,  emoji: '‼️', urgencia: '¡Ahora!' }
        ];

        alertas.forEach(alerta => {
            const tiempoParaAlerta = diffMs - (alerta.minutos * 60 * 1000);

            // Solo programar si todavía no ha pasado ese momento
            if (tiempoParaAlerta > 0) {
                const timeoutId = setTimeout(() => {
                    mostrarNotificacionSW(med, alerta);
                }, tiempoParaAlerta);
                timeoutsActivos.push(timeoutId);
            } else if (tiempoParaAlerta > -60000) {
                // Pasó hace menos de 1 min, mostrar inmediatamente
                mostrarNotificacionSW(med, { ...alerta, minutos: 0 });
            }
        });

        // Notificación exacta cuando es la hora
        if (diffMs > 0 && diffMs < 24 * 60 * 60 * 1000) {
            const timeoutExacto = setTimeout(() => {
                mostrarNotificacionExacta(med);
            }, diffMs);
            timeoutsActivos.push(timeoutExacto);
        }
    });
}

function calcularProximaToma(med, ahora) {
    try {
        if (!med.fechaInicio) return null;
        const partes = med.fechaInicio.split('-');
        let inicio = new Date(partes[0], partes[1] - 1, partes[2], 8, 0, 0);
        const freqMs = med.frecuenciaHoras * 60 * 60 * 1000;

        if (isNaN(inicio.getTime()) || freqMs <= 0) return null;

        let proxima = new Date(inicio);
        while (proxima <= ahora) {
            proxima = new Date(proxima.getTime() + freqMs);
        }

        // Solo tomas dentro de las próximas 25 horas
        if (proxima - ahora > 25 * 60 * 60 * 1000) return null;
        return proxima;
    } catch (e) {
        return null;
    }
}

function mostrarNotificacionSW(med, alerta) {
    const minutos = alerta.minutos;
    let cuerpo = '';
    if (minutos === 0) {
        cuerpo = `¡Es la hora! Toma "${med.nombre}" ahora. Dosis: ${med.dosis}.`;
    } else {
        cuerpo = `En ${minutos} minuto${minutos === 1 ? '' : 's'} te toca tomarte "${med.nombre}". Sé puntual. Dosis: ${med.dosis}.`;
    }

    const opciones = {
        body: cuerpo,
        icon: '/consultex/img/pill-icon.png',
        badge: '/consultex/img/pill-icon.png',
        vibrate: [200, 100, 200],
        requireInteraction: minutos <= 5,
        tag: `med-${med.nombre}-${minutos}`,
        renotify: true,
        data: { url: '/consultex/ControladorMedicamento?accion=misRecordatorios' },
        actions: [
            { action: 'ver', title: 'Ver mis medicamentos' },
            { action: 'ok',  title: 'Entendido' }
        ]
    };

    self.registration.showNotification(
        `${alerta.emoji} ${alerta.urgencia}: ${med.nombre}`,
        opciones
    );
}

function mostrarNotificacionExacta(med) {
    const opciones = {
        body: `¡Es la hora de tomar "${med.nombre}"! Dosis: ${med.dosis}. No lo olvides.`,
        icon: '/consultex/img/pill-icon.png',
        badge: '/consultex/img/pill-icon.png',
        vibrate: [300, 150, 300, 150, 300],
        requireInteraction: true,
        tag: `med-exacto-${med.nombre}`,
        renotify: true,
        data: { url: '/consultex/ControladorMedicamento?accion=misRecordatorios' },
        actions: [
            { action: 'ver', title: 'Ver mis medicamentos' },
            { action: 'ok',  title: 'Lo tomé' }
        ]
    };

    self.registration.showNotification(
        `‼️ ¡HORA DE MEDICAMENTO: ${med.nombre}!`,
        opciones
    );
}
