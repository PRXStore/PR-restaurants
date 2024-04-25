local QBCore = exports['qb-core']:GetCoreObject()




CreateThread(function()
    exports['oxmysql']:execute("SELECT * FROM `prx-realestate`", function(result)
        if result[1] then 
            local ToDay = os.date("%A")
            local CutDay = {
                ["Tuesday"] = true,
            }
            local menu = result

            if CutDay[ToDay] then 
                for i = 1, (#menu), 1 do
                    Wait(100)
                    if tonumber(menu[i].flag) == 0 then 
                        if tonumber(menu[i].total) < Config.Price then 
                            local PlayerData = MySQL.Sync.prepare('SELECT * FROM players where citizenid = ?', { menu[i].owner })
                            if PlayerData then 
                                PlayerData.money = json.decode(PlayerData.money)
                                if PlayerData.money then 
                                    if tonumber(PlayerData.money.bank) >= Config.menu.Rent then 
                                        PlayerData.money.bank = PlayerData.money.bank - Config.menu.Rent
                                        MySQL.Async.prepare('UPDATE players SET money = ? WHERE citizenid = ?', { json.encode(PlayerData.money), menu[i].owner })
                                        Wait(50)
                                        menu[i].total += Config.menu.Rent
    
                                        if Config.menu[menu[i].id] then 
                                            Config.menu[menu[i].id].isOwned = true
                                        end
                                    else
                                        MySQL.query("DELETE FROM prx-realestate WHERE id = ?", {
                                            menu[i].id
                                        })
                                    end
                                else
                                    MySQL.query("DELETE FROM prx-realestate WHERE id = ?", {
                                        menu[i].id
                                    })
                                end
                            else
                                MySQL.query("DELETE FROM prx-realestate WHERE id = ?", {
                                    menu[i].id
                                })
                            end
                        elseif tonumber(menu[i].total) >= Config.Price then 
                            if Config.menu[menu[i].id] then 
                                Config.menu[menu[i].id].isOwned = true
                            end
                        end
                    else
                        if Config.menu[menu[i].id] then 
                            Config.menu[menu[i].id].isOwned = true
                        end
                    end
                end
            else
                for i = 1, (#menu), 1 do
                    Wait(50)
                    if Config.menu[menu[i].id] then 
                        Config.menu[menu[i].id].isOwned = true
                    end
                end
            end
            Wait(1000)
            TriggerClientEvent('prx-res:client:Updateres', -1, Config.menu)
        end
    end)
end)

RegisterNetEvent("prx:server:buy", function(data)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local Bank = Player.PlayerData.money.bank
    if Config.menu.isOwned then return end 
    if Player and Bank then 
        if tonumber(Bank) ~= 0 then 
            if tonumber(Bank) >= tonumber(Config.Price) then 
                if Config.menu.isOwned then return end
                if Player.Functions.RemoveMoney('bank', tonumber(Config.Price)) or Player.Functions.RemoveMoney('cash', tonumber(Config.Price))  then 
                    if Config.menu.isOwned then return end
                    MySQL.Async.insert('INSERT INTO `prx-realestate` (id , owner, company) VALUES (:id,:owner, :company)', {
                        id = data.id,
                        owner = Player.PlayerData.citizenid,
                        company = data.company,
                    })
                    if Config.job == true then
                        Player.Functions.SetJob(data.company, 3)  
                    end
                    if Config.Company == true then
                        Player.Functions.SetCompany(data.company, 3)  

                    end
                
                    Config.menu.isOwned = true
                    Config.menu.owner = Player.PlayerData.citizenid     
                    TriggerClientEvent('prx-res:client:Updateres', -1, Config.menu)
                else
                    QBCore.Functions.Notify(src, "You don\'t have money", 'error', 7000)
                end
            else
                QBCore.Functions.Notify(src, "You don\'t have money", 'error', 7000)
            end
        end
    end
end) 
QBCore.Functions.CreateCallback('prx-restrants:server:GetmenuConfig', function(source, cb)
    cb(Config.menu)
end)