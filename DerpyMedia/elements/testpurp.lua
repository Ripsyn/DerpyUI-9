--[[																
				      		   !         !          
                              ! !       ! !          
                             ! . !     ! . !          
                               ^^^^^^^^^ ^            
                             ^             ^          
                           ^  (0)       (0)  ^       
                          ^        ""         ^       
                         ^   ***************    ^     
                       ^   *                 *   ^    
                      ^   *   /\   /\   /\    *    ^   
                     ^   *                     *    ^
                    ^   *   /\   /\   /\   /\   *    ^
                   ^   *                         *    ^
                   ^  *                           *   ^
                   ^  *                           *   ^
                    ^ *                           *  ^  
                     ^*                           * ^ 
                      ^ *                        * ^
                      ^  *                      *  ^
                        ^  *       ) (         * ^
                            ^^^^^^^^ ^^^^^^^^^ 
					
--]]																

local M,L = unpack(select(2,...))
local abs = abs

local frame = CreateFrame("Frame","DerpyDynHolder",UIParent)

local frame_functions = {
	["width"] 	= 	function(self,x) self:SetWidth(x) end,
	["height"] 	= 	function(self,x) self:SetHeight(x) end,
	["strata"] 	= 	function(self,x) self:SetFrameStrata(x) end,
	["scale"]	= 	function(self,x) self:SetScale(x) end,
	["size"]	= 	function(self,x) self:SetSize(x,x) end,
	["parent"]	=	function(self,x) self:SetParent(x) end,
	["level"]	=	function(self,x) self:SetFrameLevel(x) end,
	--[""]
}

M.Atributes = function(self,...)
	for i = 1, select("#", ...), 2 do
		local x = select(i,...)
		local y = select(i+1,...)
		frame_functions[x](self,y)
	end
end