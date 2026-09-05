const { default: makeWASocket, useMultiFileAuthState, DisconnectReason } = require('@whiskeysockets/baileys');
const { execSync } = require('child_process');
const http = require('https');

async function startBot() {
    const { state, saveCreds } = await useMultiFileAuthState('auth_info_baileys');
    const sock = makeWASocket({
        auth: state,
        printQRInTerminal: true
    });

    sock.ev.on('creds.update', saveCreds);

    sock.ev.on('connection.update', (update) => {
        const { connection, lastDisconnect } = update;
        if (connection === 'close') {
            const shouldReconnect = (lastDisconnect.error?.output?.statusCode !== DisconnectReason.loggedOut);
            if (shouldReconnect) startBot();
        } else if (connection === 'open') {
            console.log('✅ Bot de WhatsApp TiendaSSH conectado.');
        }
    });

    sock.ev.on('messages.upsert', async (m) => {
        const msg = m.messages[0];
        if (!msg.message || msg.key.fromMe) return;

        const from = msg.key.remoteJid;
        const text = (msg.message.conversation || msg.message.extendedTextMessage?.text || '').trim().toLowerCase();

        if (text === 'menu' || text === 'hola' || text === 'start') {
            const menuText = "⚡ *TIENDASSH BOT - MENÚ PRINCIPAL* ⚡\n\n" +
                             "1️⃣ *comprar* - Crear cuenta SSH\n" +
                             "2️⃣ *demo* - Probar acceso temporal\n" +
                             "3️⃣ *revender* - Panel de revendedores\n" +
                             "4️⃣ *estado* - Ver monitor en tiempo real\n\n" +
                             "Responde con el comando deseado.";
            await sock.sendMessage(from, { text: menuText });
        } else if (text === '1' || text === 'comprar') {
            const pass = Math.random().toString(36).slice(-6);
            const user = "wa_" + Math.floor(Math.random() * 8999 + 1000);
            try {
                execSync(`useradd -M -s /bin/false ${user} && echo "${user}:${pass}" | chpasswd`);
                await sock.sendMessage(from, { text: `✅ *Cuenta SSH creada con éxito:*\n👤 Usuario: ${user}\n🔑 Clave: ${pass}\n📅 Vencimiento: 30 días` });
            } catch (err) {
                await sock.sendMessage(from, { text: "❌ Error creando cuenta en el servidor." });
            }
        } else if (text === '2' || text === 'demo') {
            const pass = Math.random().toString(36).slice(-6);
            const user = "demo_" + Math.floor(Math.random() * 8999 + 1000);
            try {
                execSync(`useradd -M -s /bin/false ${user} && echo "${user}:${pass}" | chpasswd`);
                await sock.sendMessage(from, { text: `⚡ *Demo Generada (2 horas):*\n👤 Usuario: ${user}\n🔑 Clave: ${pass}` });
            } catch (err) {
                await sock.sendMessage(from, { text: "❌ Error creando cuenta demo." });
            }
        } else if (text === '3' || text === 'revender') {
            await sock.sendMessage(from, { text: "💼 *Sistema de Reventa TiendaSSH*\nConsulte disponibilidad y asignación de créditos con el administrador." });
        } else if (text === '4' || text === 'estado') {
            try {
                const output = execSync("who | wc -l").toString().trim();
                await sock.sendMessage(from, { text: `📊 *Monitor de Conexiones:* ${output} usuarios en línea.` });
            } catch (e) {
                await sock.sendMessage(from, { text: "📊 Monitor activo." });
            }
        }
    });
}

startBot();
