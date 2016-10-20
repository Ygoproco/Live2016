--Booster Draft Duel
-- - Works with Single Duel

local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

--before anything
if not scard.rc_ovr then
	scard.rc_ovr=true
	local c_getrace=Card.GetRace
	Card.GetRace=function(c)
		if c:IsType(TYPE_MONSTER) then return 0xffffff end
		return c_getrace(c)
	end
	local c_getorigrace=Card.GetOriginalRace
	Card.GetOriginalRace=function(c)
		if c:IsType(TYPE_MONSTER) then return 0xffffff end
		return c_getorigrace(c)
	end
	local c_getprevraceonfield=Card.GetPreviousRaceOnField
	Card.GetPreviousRaceOnField=function(c)
		if bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0 then return 0xffffff end
		return c_getprevraceonfield(c)
	end
	local c_israce=Card.IsRace
	Card.IsRace=function(c,r)
		if c:IsType(TYPE_MONSTER) then return true end
		return c_israce(c,r)
	end
end

function scard.initial_effect(c)
	if scard.regok then return end
	scard.regok=true
	--Pre-draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetOperation(scard.op)
	Duel.RegisterEffect(e1,0)
end

--define pack
--pack=BP03
--[1]=rare, [2/3/4]=common, [5]=foil
local pack={}
	pack[1]={
		42364374,71413901,82108372,39168895,78636495,42386471,16956455,85306040,89222931,85087012,18430390,
		61802346,39303359,54040221,52319752,14089428,76203291,75081613,96235275,41113025,6061630,92826944,
		84847656,74976215,69695704,45041488,12435193,80925836,42463414,77135531,10321588,4694209,39037517,
		37792478,49680980,82199284,20474741,83957459,66816282,91438994,62950604,47013502,85682655,4611269,
		95905259,1371589,66499018,64892035,40921545,98225108,42969214,97396380,89362180,15767889,50896944
	}
	pack[2]={
		23635815,40133511,38742075,77491079,40320754,30914564,76909279,2671330,18325492,55424270,3370104,
		93130021,21074344,94689635,99861526,79409334,12398280,20586572,46508640,95943058,91596726,52035300,
		87685879,39180960,59797187,11232355,17266660,52430902,38041940,2525268,95090813,71759912,90508760,
		43426903,65422840,79337169,3603242,23927545,20351153,13521194,12235475,96930127,2137678,84747429,
		73625877,93830681,5237827,2584136,49374988,72429240,7914843,30464153,78663366,30608985,54635862
	}
	pack[3]={
		37984162,61318483,12467005,99733359,25727454,72302403,70046172,86198326,70828912,82432018,19230407,
		73915051,95281259,55991637,81385346,37684215,31036355,2204140,4861205,10012614,28106077,98045062,
		82828051,12923641,36045450,37534148,1353770,6178850,4230620,62991886,99995595,35480699,45247637,
		32180819,44887817,92346415,25789292,95507060,91580102,25518020,66835946,98867329,84428023,78082039,
		27243130,67775894,60398723,53610653,89882100,88616795,73199638,36042825,96864811,83438826,23562407
	}
	pack[4]={
		42502956,54773234,52112003,88610708,97077563,22359980,68540058,57882509,41925941,31785398,80163754,
		98239899,3149764,59744639,83133491,29267084,66742250,12503902,96008713,77538567,4923662,60306104,
		93895605,34815282,82633308,23323812,59718521,37390589,91078716,54451023,97168905,73729209,17490535,
		43889633,16678947,87106146,32854013,21636650,89792713,3146695,25642998,11741041,75987257,44046281,
		78474168,44509898,71098407,63630268,23122036,25005816,51099515,88494120,14883228,50277973,87772572
	}
	pack[5]={
		47506081,95992081,11411223,47805931,3989465,76372778,581014,12014404,48009503,74593218,57043117,
		95169481,66506689,51960178,80764541,75367227,68836428
	}
	for _,v in ipairs(pack[1]) do table.insert(pack[5],v) end
	for _,v in ipairs(pack[2]) do table.insert(pack[5],v) end
	for _,v in ipairs(pack[3]) do table.insert(pack[5],v) end
	for _,v in ipairs(pack[4]) do table.insert(pack[5],v) end
local packopen=false
local handnum={[0]=5;[1]=5}

--DangerZone

local side={[0]={};[1]={}}
local function _prepSide(p,g)
	local c=g:GetFirst()
	while c do
		table.insert(side[p],c:GetOriginalCode())
		c=g:GetNext()
	end
end

local function _printDeck()
	--[[
	local io=require("io")
	for p=0,1 do
		local f=io.open("./deck/bdduel"..p..".ydk","w+")
		f:write("#created by ...\n#main\n")
		local g=Duel.GetFieldGroup(p,LOCATION_DECK,0)
		local c=g:GetFirst()
		while c do
			f:write(c:GetOriginalCode().."\n")
			c=g:GetNext()
		end
		f:write("#extra\n")
		g=Duel.GetFieldGroup(p,LOCATION_EXTRA,0)
		c=g:GetFirst()
		while c do
			f:write(c:GetOriginalCode().."\n")
			c=g:GetNext()
		end
		f:write("!side\n")
		for _,i in ipairs(side[p]) do
			f:write(i.."\n")
		end
		f:close()
	end
	--]]
end

function scard.op(e,tp,eg,ep,ev,re,r,rp)
	if packopen then e:Reset() return end
	packopen=true
	--Hint
	Duel.Hint(HINT_CARD,0,s_id)
	for p=0,1 do
		local c=Duel.CreateToken(p,s_id)
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
		Duel.Hint(HINT_CODE,p,s_id)
		--protection (steal Boss Duel xD)
		local e10=Effect.CreateEffect(c)
		e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetCode(EFFECT_CANNOT_TO_GRAVE)
		c:RegisterEffect(e10)
		local e11=e10:Clone()
		e11:SetCode(EFFECT_CANNOT_TO_HAND)
		c:RegisterEffect(e11)
		local e12=e10:Clone()
		e12:SetCode(EFFECT_CANNOT_TO_DECK) 
		c:RegisterEffect(e12)
		local e13=e10:Clone()
		e13:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		c:RegisterEffect(e13)
	end
	--note hand card (5)
	--FOR RANDOOM
	local rseed=0
	for i=1,6 do
		local r={Duel.TossCoin(i%2,5)}
		for n=1,5 do
			rseed=bit.lshift(rseed,1)+r[n]
		end
	end
	math.randomseed(rseed)
	--
	Duel.DisableShuffleCheck()
	--remove all cards
	local fg=Duel.GetFieldGroup(0,0x43,0x43)
	Duel.SendtoDeck(fg,nil,-2,REASON_RULE)
	--Open packs
	local g=Group.CreateGroup()
	local p=0
	repeat
		if g:GetCount()==0 then
			for u=1,3 do
				for i=1,5 do
					local cpack=pack[i]
					local c=cpack[math.random(#cpack)]
					g:AddCard(Duel.CreateToken(p,c))
				end
			end
			Duel.SendtoDeck(g,nil,2,REASON_RULE)
			Duel.ConfirmCards(1-p,g)
		end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local rc=g:Select(p,1,1,nil):GetFirst()
		g:RemoveCard(rc)
		local tc=Duel.CreateToken(p,rc:GetOriginalCode())
		Duel.SendtoDeck(rc,nil,-2,REASON_RULE)
		Duel.SendtoHand(tc,nil,REASON_RULE)
		if tc:IsLocation(LOCATION_HAND) then Duel.SendtoDeck(tc,nil,2,REASON_RULE) end
		p=1-p
	until g:GetCount()==0 and Duel.GetFieldGroupCount(0,LOCATION_DECK+LOCATION_EXTRA,0)>=45 and Duel.GetFieldGroupCount(1,LOCATION_DECK+LOCATION_EXTRA,0)>=45
	--Confirm cards
	for p=0,1 do
		Duel.ConfirmCards(p,Duel.GetFieldGroup(p,LOCATION_DECK+LOCATION_EXTRA,0))
	end
	--Reduce (min. 40) if the player wants to
	local rg=Group.CreateGroup()
	for p=0,1 do
		local dg=Duel.GetFieldGroup(p,LOCATION_DECK,0)
		local ct=dg:GetCount()-40
		if ct>0 and Duel.SelectYesNo(p,aux.Stringid(4002,7)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
			local sg=g:Select(p,1,ct,nil)
			_prepSide(p,sg)
			rg:Merge(sg)
		end
	end
	if rg:GetCount()>0 then Duel.SendtoDeck(rg,nil,-2,REASON_RULE) end
	--Shuffle Deck
	for p=0,1 do
		Duel.ShuffleDeck(p)
	end
	--Readd hand
	for p=0,1 do
		Duel.SendtoHand(Duel.GetDecktopGroup(p,handnum[p]),nil,REASON_RULE)
	end
	_printDeck()
	e:Reset()
end
