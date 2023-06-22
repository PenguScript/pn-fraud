Config = {}

Config.PSDispatch = false
Config.Peds = {
    {
        Model = 'a_m_y_business_03',
        Coords = vector4(283.8, 265.19, 104.59, 337.05),
        Icon = 'fa fa-money',
        Name = "???",
    },
}
--REMOVED FROM HERE

-- Config.FraudCheckModel = "a_m_y_business_03"
-- Config.FraudCheckPosition = vector4(283.8, 265.19, 104.59, 337.05)
-- Config.FraudCheckIcon = 'fa fa-money'
-- Config.FraudCheckName = "???"

--REMOVED TO HERE


Config.FraudMoneyRewardType = "cash"
Config.FraudMoneyRewardValue = { min = 500, max = 1500 } -- min,max

Config.RealCheckMoneyRewardType = "cash"
Config.RealCheckMoneyRewardValue = { min = 250, max = 800 } -- min,max