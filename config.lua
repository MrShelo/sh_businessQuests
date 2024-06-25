Config = {}

Config.MaxBoxes = 3 -- Max boxes from one drive
Config.ItemsDropAmount = 10 -- Items Multiplier 
Config.Car = "rumpo"
Config.Lang = "pl"


--[[
    Add to config items.lua
	["deliverybox"]					= {["name"] = "deliverybox",			["label"] = "Box",   ["weight"] = 300,   ["type"] = "item",  ["image"] = "box.png",			   ["unique"] = false, ["useable"] = true,	   ["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Box with items for your business"},

]]
Config.Translations ={
    ["pl"] = {
        ["gotoloc"] = "Jedź po dostawę",
        ["pickupbox"] = "Odbieranie dostawy",
        ["needtopickup"] = "Odbierz dostawę",
        ["canceled"] = "Przerwano czynność",
        ["depositvan"] = "Aby odstawić pojazd dostawczy",
    },
    ["en"] = {
        ["gotoloc"] = "Go for delivery",
        ["pickupbox"] = "Picking up the delivery",
        ["needtopickup"] = "Pick up the delivery",
        ["canceled"] = "Action canceled",
        ["depositvan"] = "To return the delivery van",
    },
    
    ["de"] = {
        ["gotoloc"] = "Go for delivery",
        ["pickupbox"] = "Lieferung abholen",
        ["needtopickup"] = "Lieferung abholen",
        ["canceled"] = "Aktion abgebrochen",
        ["depositvan"] = "Um den Lieferwagen zurückzugeben",
    }
}

Config.Jobs ={

     ["mechanic"] = {
        deliveryCoords = vector3(-448.14, -2805.97, 7.3),
        spawnSpeedo = vector4(-812.3806, -752.6298, 22.9534, 97.5456),
        packageName = "Mechanic_Box",
        packageItems = {
            "fixkit", -- Add What u want Get
        }
   },
 --[[   
    TEMPLATE
    ----------------------
    ["pharmacy"] = {
        name = "pharmacy", --- job name
        deliveryCoords = vector3(-448.14, -2805.97, 7.3), --- Coords with boxes to pickup
        spawnSpeedo = vector4(-1245.73, -1434.21, 4.33, 311.65), --- Van Spawn & despawn location 
        packageName = "Apteka_Paczka", ---- Packagae name
        packageItems = {
            "apteczka_samochodowa", "plasterek", "paracetamol", "ashwaganda", "microdacyn", "rutinoscorbin" --- Package items inside
        }
    },
    ----------------------
    ]]
}