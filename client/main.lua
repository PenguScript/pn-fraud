local QBCore = exports['qb-core']:GetCoreObject()

--REMOVED FROM HERE

-- local FraudCheckPos = Config.FraudCheckPosition

-- Citizen.CreateThread(function()
--     RequestModel(Config.FraudCheckModel)
--     while not HasModelLoaded(Config.FraudCheckModel) do
--         RequestModel(Config.FraudCheckModel)
--         Wait(1)
--     end
--     local FraudCheckPed = CreatePed(0, Config.FraudCheckModel, FraudCheckPos.x, FraudCheckPos.y, FraudCheckPos.z, FraudCheckPos.w, true)
--     SetEntityInvincible(FraudCheckPed, true)
--     SetBlockingOfNonTemporaryEvents(FraudCheckPed, true)
--     Citizen.Wait(1350)
--     TaskStartScenarioInPlace(FraudCheckPed, "CODE_HUMAN_CROSS_ROAD_WAIT", 0, true)
--     FreezeEntityPosition(FraudCheckPed, true)
--     exports['qb-target']:AddTargetEntity(FraudCheckPed, {
--         options = {
--             {
--                 type = "Client",
--                 event = "pn-fraud:FraudCheckMenu",
--                 icon = Config.FraudCheckIcon,
--                 label = Config.FraudCheckName,
--             }
--         },
--         distance = 2.5,
--     })
-- end)

--REMOVED TO HERE

CreateThread(function()
    for k,v in pairs(Config.Peds) do
        if v.Model and v.Coords then
            local model = ''
            model = v.Model
            local Icon = 'fa fa-money'
            local Name = "???"

            if v.Icon then
                Icon = v.Icon
            end
            if v.Name then
                Name = v.Name
            end

            RequestModel(model)
            while not HasModelLoaded(model) do
                RequestModel(model)
                Wait(1)
            end
            local FraudCheckPed = CreatePed(0, model, v.Coords.x, v.Coords.y, v.Coords.z, v.Coords.w, true)
            SetEntityInvincible(FraudCheckPed, true)
            SetBlockingOfNonTemporaryEvents(FraudCheckPed, true)
            Wait(1350)
            TaskStartScenarioInPlace(FraudCheckPed, "CODE_HUMAN_CROSS_ROAD_WAIT", 0, true)
            FreezeEntityPosition(FraudCheckPed, true)
            exports['qb-target']:AddTargetEntity(FraudCheckPed, {
                options = {
                    {
                        type = "Client",
                        event = "pn-fraud:FraudCheckMenu",
                        icon = Icon,
                        label = Name,
                    }
                },
                distance = 2.5,
            })
        else
            print("PN-Fraud:Model or Coords Not Configured Correctly")
        end
    end
end)

--[[local function hasCheck(type)
    QBCore.Functions.TriggerCallback('pn-fraud:GetChecks', function(cb)
        if cb ~= nil then
            if cb[type] ~= nil then return(cb[type])
        end
    end)
end]]

RegisterNetEvent("pn-fraud:FraudCheckMenu", function()
    QBCore.Functions.TriggerCallback('pn-fraud:GetChecks', function(cb)
        local checkHide = false
        local fraudHide = false
        local baseHide = true
        local checkAmount = cb[2].qty
        local fraudAmount = cb[1].qty
        if cb[2].qty == 0 then
            checkHide = true
        end
        if cb[1].qty == 0 then
            fraudHide = true
        end
        if checkHide and fraudHide == true then
            baseHide = false
        end
        exports['qb-menu']:openMenu({
            {
                header = "Cash Out Checks",
                isMenuHeader = true, -- Set to true to make a nonclickable title
            },
            {
                header = "Fraud Checks",
                txt = "You have "..fraudAmount.." Fraud Check(s)",
                hidden = fraudHide,
                params = {
                    event = "pn-fraud:CashCheck",
                    args = {
                        type = 'fraud',
                        amnt = fraudAmount
                    }    
                }
            },
            {
                header = "Checks",
                txt = "You have "..checkAmount.." Check(s)",
                -- hidden = true, -- doesnt create this at all if set to true
                hidden = checkHide,
                params = {
                    event = "pn-fraud:CashCheck",
                    args = {
                        type = 'real',
                        amnt = checkAmount
                    }    
                }
            },
            {
                header = "You have no checks",
                txt = "Please go get some checks to cash in!",
                hidden = baseHide,
                disabled = true,
                params = {
                    event = "pn-fraud:CashCheck",
                    args = {
                        type = 'fraud',
                        amnt = fraudAmount
                    }    
                }
            },

        })
    end)
end)

RegisterNetEvent('pn-fraud:CashCheck', function(args)
    local ctype = nil
    if args.type == 'fraud' then
        ctype = 'fraud'
    elseif args.type == 'real' then
        ctype = 'real'
    end

    if ctype == nil then
        local msg = "Error on line 102. Contact PenguScripts!"
        TriggerServerEvent('pn-fraud:ServerPrint', msg)
    else
        if args.amnt ~= 0 then
            QBCore.Functions.Progressbar('fraudCheck', 'Counting Checks...', 2000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = 'mp_common',
                anim = 'givetake1_a',
                flags = 16,
            }, {}, {}, function() -- Play When Done
                TriggerServerEvent('pn-fraud:GiveMoneyFromChecks', args)
                local chance = math.random(1,100)
                if chance >= 75 then
                    if Config.PSDispatch == true then
                        exports['ps-dispatch']:SuspiciousActivity()
                    else
                        TriggerServerEvent('police:server:policeAlert', 'Fraud check has been cashed. Catch the suspect leaving the Vinewood Bank area.')
                    end
                end
            end, function() -- Play When Cancel
                QBCore.Functions.Notify("I'll cash your checks next time. Get out of here.", 'error')
            end)
        end
    end
end)