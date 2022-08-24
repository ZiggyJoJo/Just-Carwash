Config = {}

Config.UseMythicProgbar = true -- Enable or dissable using mythic progressbar

Config.UseMythicNotify = false -- Enable or dissable using mythic notify

Config.CleaningTime = 15 -- Seconds

Config.CleaningCost = 25 


Config.CarWash = {
    {
        label = "Hands On Carwash", 
        zone = {name = 'StrawberryCarwash', x = 21.36, y = -1391.85, z = 29.33, l = 20.0, w = 6.0, h = 270, minZ = 28, maxZ = 33}, 
        blip = {
            scale = 0.7,
            sprite = 100,
            colour = 0
        },
    },

    {
        label = "CarwashTwo", 
        zone = {name = 'CarwashTwo', x = -699.96, y = -933.37, z = 19.01, l = 14.0, w = 6.0, h = 0, minZ = 18, maxZ = 22}, 
        blip = {
            scale = 0.7,
            sprite = 100,
            colour = 0
        },
    },

    {
        label = "CarwashThree", 
        zone = {name = 'CarwashThree', x = 169.59, y =-1716.59, z = 29.29, l = 8.0, w = 8.0, h = 320, minZ = 28, maxZ = 33}, 
        blip = {
            scale = 0.7,
            sprite = 100,
            colour = 0
        },
    },

    {
        label = "CarwashFour", 
        zone = {name = 'CarwashFour', x = 1361.59, y = 3594.45, z = 34.92, l = 6.5, w = 13.5, h = 290, minZ = 33, maxZ = 38}, 
        blip = {
            scale = 0.7,
            sprite = 100,
            colour = 0
        },
    },

    {
        label = "CarwashFive", 
        zone = {name = 'CarwashFive', x = -73.07, y = 6426.49, z = 31.44, l = 8.0, w = 10.0, h = 45, minZ = 30, maxZ = 35}, 
        blip = {
            scale = 0.7,
            sprite = 100,
            colour = 0
        },
    },

    --[[
        TEMPLATE:
        {
            label = "", 
            zone = {name = 'A name', x = X, y = X, z = X, l = X, w = X, h = X, minZ = X, maxZ = x}, 
            blip = {
                scale = 0.7,
                sprite = 100,
                colour = 0
            },
        },
    ]]
}