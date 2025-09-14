/**
 * Internal map used by fivemjs.
 */
const callbacks = new Map()

/**
 * Register a callback for the lua SendNUIMessage.
 * @param {string} event 
 * @param {Function} func
 * @param {object} args
 */
function RegisterNUICallback(event, func, args) {
    if (callbacks.has(event)) return

    callbacks.set(event, {
        func: func,
        args: args
    })
}

/**
 * Unregister a callback for the lua SendNUIMessage.
 * @param {string} event 
 */
function UnregisterNUICallback(event) {
    if (!callbacks.has(event)) return

    callbacks.delete(event)
}

/**
 * Internal event listener used by fivemjs.
 */
window.addEventListener("message", (event) => {
    const data = event.data
    const type = data.type

    for (const [event, callback] of callbacks) {
        if (type !== event) continue

        let args = {}
        
        for (const index in callback.args) {
            const arg = callback.args[index]

            args[arg] = data[arg]
        }

        callback.func(args)
        break
    }
})

/**
 * Internal map used by fivemjs.
 */
const keybinds = new Map()

/**
 * Register a keybind for nui.
 * @param {string} key
 * @param {Function} func
 */
function RegisterKeybind(key, func) {
    if (keybinds.has(key)) return

    keybinds.set(key, func)
}

/**
 * Unregister a keybind for nui.
 * @param {string} key  
 */
function UnregisterKeybind(key) {
    if (!keybinds.has(key)) return

    keybinds.delete(key)
}

/**
 * Internal event listener used by fivemjs.
 */
document.addEventListener('keydown', (event) => {
    for (const [key, func] of keybinds) {
        if (event.key !== key) continue

        func()
        break
    }
})

/**
 * Sends a message to the client lua script.
 * @param {string} event 
 * @param {object} data
 * @returns {object}
 */
async function SendNUIMessage(event, data) {
    const response = await fetch(`https://${GetParentResourceName()}/${event}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    });

    return response.json()
}