local QBCore = exports['qb-core']:GetCoreObject()




local function loaded(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do 
       Wait (0)
    end
end
CreateThread(function ()
    local coord = vector4(-703.54, 265.84, 81.62, 27.1)
    local hash = 'g_m_y_korlieut_01'
    loaded(hash)
    ped = CreatePed(4,hash, coord.x, coord.y, coord.z, coord.w, true, false)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_SEAT_ARMCHAIR", 0,1)
    exports['qb-target']:AddTargetEntity(ped, { -- The specified entity number
    options = {
        {
            type = "client",
            event = "prx:realestate:menu:main",
            icon = "fas fa-business-time",
            label = "Rent a Company",
            job = "all",
        },
    },
    distance = 2.5
  })
end)



RegisterNetEvent('prx-res:client:Updateres', function(Info)
    Config.menu = Info
end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.TriggerCallback('prx-restrants:server:GetmenuConfig', function(restrantsconfig)
        Config.menu = restrantsconfig
    end)
end)


RegisterNetEvent("prx:realestate:menu:main",function() 
    exports['qb-menu']:openMenu({
        {
            header = 'Company Menu',
            icon = '',
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        -- {
        --     header = 'Mechanics',
        --     txt = 'Here You Can Rent Mechanics',
        --     icon = 'fa-light fa-screwdriver-wrench',
        --     params = {
        --         event = 'qb-menu:client:testButton',
        --     }
        -- },  
        {
            header = 'Restrants',
            txt = 'Here You Can Rent Restrants',
            icon = 'fas fa-shop',
            -- disabled = false, -- optional, non-clickable and grey scale
            -- hidden = true, -- optional, hides the button completely
            params = {
                -- isServer = false, -- optional, specify event type
                event = 'prx:realestate:restrants:menu',
            }
        },
        {
            header = 'Close',
            txt = '',
            icon = 'fas fa-circle-xmark',
            -- disabled = false, -- optional, non-clickable and grey scale
            -- hidden = true, -- optional, hides the button completely
            params = {
                -- isServer = false, -- optional, specify event type
                event = '',
            }
        },
    })
end)


RegisterNetEvent("prx:realestate:restrants:menu",function() 
    local GlobalConfig = Config

        local Main = {{
            header = 'Rent Business',
            icon = '',
            isMenuHeader = true, -- Set to true to make a nonclickable title
         },}

        
        for k, v in next, (GlobalConfig.menu) do
                Main[#Main + 1] = {
                    header = '<center><img src='.. v.img ..' width="265px"> <p>'.. v.header ..'</p></center> <br>',
                    txt = 'You Can Rent This Business For : ' .. Config.Price,
                    icon = '',
                    disabled = v.isOwned,
                    params = {
                        isServer = true, 
                        event = 'prx:server:buy',
                        args = {
                            company = v.company,
                            id = v.id,
                        },
                    }
                } 
        end

        Main[#Main+1] = {
        
                header = 'Return',
                txt = 'Return t main menu',
                icon = 'fas fa-rotate-left',
                params = {
                    event = 'prx:realestate:menu:main',
                    args = {
            
                    }
                }
            
            
        }
        exports['qb-menu']:openMenu(Main)
end)