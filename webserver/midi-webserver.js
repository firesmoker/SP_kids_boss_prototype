const WebSocket = require('ws');
const MIDI = require('midi'); // Import the midi library
const readline = require('readline'); // To read input from the command line
const mdns = require('mdns'); // Import the mDNS library

// Create a WebSocket server
const wss = new WebSocket.Server({ port: 8099 });

const midiInput = new MIDI.Input(); // Create a new MIDI Input instance

// Function to open a selected MIDI input port
function openMidiInput(portIndex) {
    const portName = midiInput.getPortName(portIndex);
    midiInput.openPort(portIndex);
    console.log(`Listening for MIDI input: ${portName}`);

    // Listen for MIDI messages on the selected port
    midiInput.on('message', (deltaTime, message) => {
        console.log(`MIDI message received on ${portName}: ${message}`);
        broadcast(message); // Send MIDI message to all clients
    });
}

// Function to broadcast MIDI messages to all connected clients
function broadcast(data) {
    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(data);
        }
    });
}

// Function to list available MIDI input ports and prompt the user to select one
function listMidiDevices() {
    const portCount = midiInput.getPortCount();
    console.log(`Found ${portCount} MIDI input ports:`);

    if (portCount === 0) {
        console.error('No MIDI input ports available. Exiting...');
        process.exit(1);
    }

    for (let i = 0; i < portCount; i++) {
        const portName = midiInput.getPortName(i);
        console.log(`${i + 1}: ${portName}`);
    }

    // Prompt the user to select a MIDI port
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    rl.question('Select a MIDI port number to listen to: ', (answer) => {
        const portIndex = parseInt(answer) - 1;

        if (portIndex >= 0 && portIndex < portCount) {
            openMidiInput(portIndex);
            console.log('WebSocket server is running on ws://localhost:8099');
            advertiseService();
            rl.close();
        } else {
            console.error('Invalid port number. Exiting...');
            rl.close();
            process.exit(1);
        }
    });
}

// Function to advertise the WebSocket server using mDNS
function advertiseService() {
    const ad = mdns.createAdvertisement(mdns.tcp('ws'), 8099, {
        name: 'MIDI WebSocket Server'
    });

    ad.start();
}

// Handle WebSocket connections
wss.on('connection', (ws) => {
    console.log('Client connected');

    ws.on('message', (message) => {
        console.log(`Received message: ${message}`);
    });

    ws.on('close', () => {
        console.log('Client disconnected');
    });
});

// List available MIDI devices and prompt for selection
listMidiDevices();
