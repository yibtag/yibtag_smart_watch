local Bridge = exports['community_bridge']:Bridge()

Bridge.Framework.RegisterUsableItem("smart_watch", function(src, itemData)
    TriggerClientEvent(
        "yibtag_smart_watch:client:EquipWatch",
        src
    )
end)