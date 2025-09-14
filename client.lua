-- Variables

local object = nil
local inspecting = false
local model = joaat("prop_yibtag_smart_watch")

-- Functions

local function StartInspecting()
    CreateThread(function ()
        if inspecting then
            return
        end

        inspecting = true

        while not HasAnimDictLoaded("yibtag_smart_watch@inspect") do
            RequestAnimDict("yibtag_smart_watch@inspect")

            Wait(100)
        end

        local ped = PlayerPedId()

        TaskPlayAnim(
            ped,
            "yibtag_smart_watch@inspect",
            "enter",
            8.0,
            -8.0,
            -1,
            48,
            0,
            false,
            false,
            false
        )
        Wait(999)
        TaskPlayAnim(
            ped,
            "yibtag_smart_watch@inspect",
            "idle",
            8.0,
            -8.0,
            -1,
            49,
            0,
            false,
            false,
            false
        )

        if Config.first_pearson then
            SetFollowPedCamViewMode(4)
        end
    end)
end

local function StopInspecting()
    CreateThread(function ()
        if not inspecting then
            return
        end

        inspecting = false

        while not HasAnimDictLoaded("yibtag_smart_watch@inspect") do
            RequestAnimDict("yibtag_smart_watch@inspect")

            Wait(100)
        end

        local ped = PlayerPedId()

        ClearPedTasks(ped)
        TaskPlayAnim(
            ped,
            "yibtag_smart_watch@inspect",
            "exit",
            8.0,
            -8.0,
            -1,
            48,
            0,
            false,
            false,
            false
        )

        if Config.first_pearson then
            SetFollowPedCamViewMode(0)
        end
    end)
end

-- Commands

RegisterCommand("inspect_smart_watch", function (source, args, raw)
    if not object then
        return
    end

    if inspecting then
        StopInspecting()
    else
        StartInspecting()
    end
end, false)

-- Keybinds

RegisterKeyMapping(
    "inspect_smart_watch",
    "Inspect smart watch",
    "keyboard",
    "i"
)

-- Events

RegisterNetEvent("yibtag_smart_watch:client:EquipWatch", function ()
    if object then
        DeleteObject(object)
        object = nil
    else
        local coords = GetEntityCoords(PlayerPedId())

        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(100)
        end

        object = CreateObject(
            model,
            coords.x,
            coords.y + 1.0,
            coords.z,
            false,
            false,
            false
        )

        AttachEntityToEntity(
            object,
            PlayerPedId(),
            71,
            0.018053690444845,
            -0.0035284175788603,
            0.025300459420153,
            0,
            0,
            0,
            true,
            true,
            false,
            true,
            1,
            true
        )
    end
end)

-- Threads

CreateThread(function ()
    local txdName = "yibtag_smart_watch_dui"
    local txd = CreateRuntimeTxd(txdName)

    local dui = CreateDui("nui://yibtag_smart_watch/web/index.html", 512, 512)
    local dui_handle = GetDuiHandle(dui)

    local txName = "yibtag_smart_watch_screen"
    local tx = CreateRuntimeTextureFromDuiHandle(txd, txName, dui_handle)

    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(100)
    end

    SendDuiMessage(dui, json.encode({
        type="open"
    }))

    AddReplaceTexture(
        "prop_yibtag_smart_watch",
        "prop_yibtag_smart_watch_screen_diffuse",
        txdName,
        txName
    )

    while true do
        local ped = PlayerPedId()

        local health = GetEntityHealth(ped) - 100
        local amour = GetPedArmour(ped)
        local stamina = GetPlayerStamina(PlayerId())

        SendDuiMessage(dui, json.encode({
            type="update",
            health=health,
            amour=amour,
            stamina=stamina
        }))

        Wait(0)
    end
end)