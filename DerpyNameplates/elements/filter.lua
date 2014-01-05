local C,M,L,V = unpack(select(2,...)) --

local names = {}

if M.L == "ruRU" then
	names = {
		["Earth Elemental Totem"] = "Тотем элементаля земли",
		["Fire Elemental Totem"] = "Тотем элементаля огня",
		["Flametongue Totem"] = "Тотем языка пламени",
		["Healing Stream Totem"] = "Тотем исцеляющего потока",
		["Magma Totem"] = "Тотем магмы",
		["Mana Spring Totem"] = "Тотем источника маны",
		["Searing Totem"] = "Опаляющий тотем",
		["Stoneclaw Totem"] = "Тотем каменного когтя",
		["Stoneskin Totem"] = "Тотем каменной кожи",
		["Strength of Earth Totem"] = "Тотем силы земли",
		["Windfury Totem"] = "Тотем неистовства ветра",
		["Totem of Wrath"] = "Тотем сопротивления силам стихий",
		["Wrath of Air Totem"] = "Тотем гнева воздуха",
		["Army of the Dead Ghoul"] = "Вурдалак из войска мертвых",
		["Venomous Snake"] = "Ядовитая змея",
		["Viper"] = "Гадюка",
	}
elseif M.L == "deDE" then
	names = {
		["Earth Elemental Totem"] = "Totem des Erdelementars",
		["Fire Elemental Totem"] = "Totem des Feuerelementars",
		["Flametongue Totem"] = "Totem der Flammenzunge",
		["Healing Stream Totem"] = "Totem des heilenden Flusses",
		["Magma Totem"] = "Totem des glühenden Magmas",
		["Mana Spring Totem"] = "Totem der Manaquelle",
		["Searing Totem"] = "Totem der Verbrennung",
		["Stoneclaw Totem"] = "Totem der Steinklaue",
		["Stoneskin Totem"] = "Totem der Steinhaut",
		["Strength of Earth Totem"] = "Totem der Erdstärke",
		["Windfury Totem"] = "Totem des Windzorns",
		["Totem of Wrath"] = "Totem des Elementarwiderstands",
		["Wrath of Air Totem"] = "Totem des stürmischen Zorns",
		["Army of the Dead Ghoul"] = "Ghul aus der Armee der Toten",
		["Venomous Snake"] = "Giftige Schlange",
		["Viper"] = "Viper",
	}
elseif M.L == "frFR" then
	names = {
		["Earth Elemental Totem"] = "Totem d'élémentaire de terre",
		["Fire Elemental Totem"] = "Totem d'élémentaire de feu",
		["Flametongue Totem"] = "Totem Langue de feu",
		["Healing Stream Totem"] = "Totem guérisseur",
		["Magma Totem"] = "Totem de magma",
		["Mana Spring Totem"] = "Totem Fontaine de mana",
		["Searing Totem"] = "Totem incendiaire",
		["Stoneclaw Totem"] = "Totem de griffes de pierre",
		["Stoneskin Totem"] = "Totem de peau de pierre",
		["Strength of Earth Totem"] = "Totem de force de la terre",
		["Windfury Totem"] = "Totem Furie-des-vents",
		["Totem of Wrath"] = "Totem de résistance élémentaire",
		["Wrath of Air Totem"] = "Totem de courroux de l'air",
		["Army of the Dead Ghoul"] = "Goule de l'armée des morts",
		["Venomous Snake"] = "Venomous Snake",
		["Viper"] = "Vipère",
	}
elseif M.L == "esES" then
	names = {
		["Earth Elemental Totem"] = "Tótem Elemental de Tierra",
		["Fire Elemental Totem"] = "Tótem Elemental de Fuego",
		["Flametongue Totem"] = "Tótem Lengua de Fuego",
		["Healing Stream Totem"] = "Tótem Corriente de sanación",
		["Magma Totem"] = "Tótem de Magma",
		["Mana Spring Totem"] = "Tótem Fuente de maná",
		["Searing Totem"] = "Tótem abrasador",
		["Stoneclaw Totem"] = "Tótem Garra de piedra",
		["Stoneskin Totem"] = "Tótem Piel de piedra",
		["Strength of Earth Totem"] = "Tótem Fuerza de la tierra",
		["Windfury Totem"] = "Tótem Viento Furioso",
		["Totem of Wrath"] = "Tótem de resistencia elemental",
		["Wrath of Air Totem"] = "Tótem cólera de aire",
		["Army of the Dead Ghoul"] = "Necrófago del Ejército de muertos",
		["Venomous Snake"] = "Serpent venimeux",
		["Viper"] = "Víbora",
	}
else
	names = {
		["Earth Elemental Totem"] = "Earth Elemental Totem",
		["Fire Elemental Totem"] = "Fire Elemental Totem",
		["Flametongue Totem"] = "Flametongue Totem",
		["Healing Stream Totem"] = "Healing Stream Totem",
		["Magma Totem"] = "Magma Totem",
		["Mana Spring Totem"] = "Mana Spring Totem",
		["Searing Totem"] = "Searing Totem",
		["Stoneclaw Totem"] = "Stoneclaw Totem",
		["Stoneskin Totem"] = "Stoneskin Totem",
		["Strength of Earth Totem"] = "Strength of Earth Totem",
		["Windfury Totem"] = "Windfury Totem",
		["Totem of Wrath"] = "Elemental Resistance Totem",
		["Wrath of Air Totem"] = "Wrath of Air Totem",
		["Army of the Dead Ghoul"] = "Army of the Dead Ghoul",
		["Venomous Snake"] = "Venomous Snake",
		["Viper"] = "Viper",
	}
end

local PlateBlacklist = {}
for r,t in pairs(V.nameplates_blacklist) do
	PlateBlacklist[names[r]] = t
end

C.names = names;

C.CheckBlacklist = function(frame, ...)
	if PlateBlacklist[frame.hp.name:GetText()] == true then
		frame:SetScript("OnUpdate", M.null)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.hp.oldlevel:Hide()
	end
end
