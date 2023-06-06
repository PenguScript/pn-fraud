local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('pn-fraud:ServerPrint', function(msg)
    print(tostring(msg))
end)

QBCore.Functions.CreateCallback('pn-fraud:GetChecks', function(source, cb)

    local items = {
        [1] = {qty = 0, itemname = 'fraudcheck'},
        [2] = {qty = 0, itemname = "check"}
    }

    local Player = QBCore.Functions.GetPlayer(source)
    for k,v in pairs(Player.PlayerData.items) do
        for key, info in pairs(items) do
            if v.name == info.itemname then
                info.qty = info.qty + v.amount
            else
                info.qty = info.qty + 0
            end
        end
    end
    cb(items)
end)

RegisterNetEvent('pn-fraud:GiveMoneyFromChecks', function(args)
    local Player = QBCore.Functions.GetPlayer(source)
    local ctype = args.type
    local amnt = args.amnt
    if ctype or amnt ~= nil or 0 then
        if ctype == "fraud" then
            local value = amnt*math.random(Config.FraudMoneyRewardValue)
            Player.Functions.RemoveItem('fraudcheck', amnt)
            Player.Functions.AddMoney(Config.FraudMoneyRewardType, value)
        elseif ctype == "real" then
            local value = amnt*math.random(Config.RealCheckMoneyRewardValue)
            Player.Functions.RemoveItem('check', amnt)
            Player.Functions.AddMoney(Config.RealCheckMoneyRewardType, value)
        else
            local msg = "There's an unknown error somewhere in this script. Please notify PenguScripts in a support ticket!"
            TriggerEvent('pn-fraud:ServerPrint', msg)
        end
    end
end)