const TelegramBot = require('node-telegram-bot-api');
const { execSync } = require('child_process');
const fs = require('fs');

let token = process.env.TELEGRAM_TOKEN;
if (!token && fs.existsSync('/etc/tiendassh/bot.conf')) {
    const conf = fs.readFileSync('/etc/tiendassh/bot.conf', 'utf-8');
    const match = conf.match(/TOKEN=(.*)/);
    if (match) token = match[1].trim();
}

if (!token) {
    console.log("❌ TELEGRAM_TOKEN no configurado.");
    process.exit(1);
}

const bot = new TelegramBot(token, { polling: true });

bot.onText(/\/start|\/menu/, (msg) => {
    const chatId = msg.chat.id;
    const menuMsg = "⚡ *TIENDASSH TELEGRAM BOT* ⚡\n\nElija una opción del menú:";
    const opts = {
        parse_mode: 'Markdown',
        reply_markup: {
            inline_keyboard: [
                [{ text: "1️⃣ Comprar SSH", callback_data: "comprar" }, { text: "2️⃣ Demo Gratis", callback_data: "demo" }],
                [{ text: "3️⃣ Revendedores", callback_data: "revender" }, { text: "4️⃣ Monitor Estado", callback_data: "estado" }]
            ]
        }
    };
    bot.sendMessage(chatId, menuMsg, opts);
});

bot.on('callback_query', (query) => {
    const chatId = query.message.chat.id;
    const action = query.data;

    if (action === 'demo') {
        const user = "demo_" + Math.floor(Math.random() * 8999 + 1000);
        const pass = Math.random().toString(36).slice(-6);
        try {
            execSync(`useradd -M -s /bin/false ${user} && echo "${user}:${pass}" | chpasswd`);
            bot.sendMessage(chatId, `⚡ *Demo Generada:*\n👤 Usuario: \`${user}\`\n🔑 Clave: \`${pass}\`\n⏱️ Validez: 2 Horas`, { parse_mode: 'Markdown' });
        } catch (e) {
            bot.sendMessage(chatId, "❌ Error generando cuenta demo en el servidor.");
        }
    } else if (action === 'comprar') {
        bot.sendMessage(chatId, "🛒 Para compras directas contacte al administrador.");
    } else if (action === 'revender') {
        bot.sendMessage(chatId, "💼 Panel de Revendedores TiendaSSH Activo.");
    } else if (action === 'estado') {
        try {
            const usersCount = execSync("who | wc -l").toString().trim();
            bot.sendMessage(chatId, `📊 *Estado del Servidor:*\n👥 Usuarios conectados: ${usersCount}`, { parse_mode: 'Markdown' });
        } catch (e) {
            bot.sendMessage(chatId, "📊 Servidor en línea.");
        }
    }
});

bot.onText(/\/estado/, (msg) => {
    try {
        const usersCount = execSync("who | wc -l").toString().trim();
        bot.sendMessage(msg.chat.id, `📊 *Estado del Servidor:*\n👥 Usuarios conectados: ${usersCount}`, { parse_mode: 'Markdown' });
    } catch (e) {
        bot.sendMessage(msg.chat.id, "📊 Servidor activo.");
    }
});

console.log("🤖 Telegram Bot TiendaSSH listo e iniciado.");
