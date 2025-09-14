const body = document.querySelector("body")

const health = document.getElementById("health")
const armour = document.getElementById("armour")
const stamina = document.getElementById("stamina")

RegisterNUICallback("open", function (data) {
    body.style.display = "block"
}, [])

RegisterNUICallback("update", function (data) {
    health.style.background = `conic-gradient(
        #fb1756 ${data.health}%,
        #4b1d28 0
    )`;
    armour.style.background = `conic-gradient(
        #a4ff02 ${data.armour}%,
        #364816 0
    )`;
    stamina.style.background = `conic-gradient(
        #03e9f6 ${data.stamina}%,
        #124443 0
    )`;
}, ["health", "armour", "stamina"])